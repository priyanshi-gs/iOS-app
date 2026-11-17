import Foundation
import StoreKit
import Combine

public enum SubscriptionTier: String {
    case basic = "Basic"
    case premiumMonthly = "Premium Monthly"
    case premiumYearly = "Premium Yearly"
}

@MainActor
public final class StoreKitManager: ObservableObject {
    public static let shared = StoreKitManager()

    // Subscription product identifiers
    public static let monthlyID = "stem.premium.monthly"
    public static let yearlyID  = "stem.premium.yearly"
    public static let allProductIDs: Set<String> = [monthlyID, yearlyID]

    @Published public private(set) var products: [Product] = []
    @Published public private(set) var purchasedProductIDs = Set<String>()
    @Published public private(set) var isPurchasing: Bool = false
    @Published public private(set) var hasActivePremium: Bool = false
    @Published public var errorMessage: String? = nil

    private var transactionUpdatesTask: Task<Void, Never>? = nil

    public init() {
        // Start background transaction listener for App Store updates/renewals
        transactionUpdatesTask = listenForTransactions()

        Task {
            await loadProducts()
            await updateCustomerProductStatus()
        }
    }

    deinit {
        transactionUpdatesTask?.cancel()
    }

    // MARK: - Load Products from App Store / StoreKit
    public func loadProducts() async {
        do {
            let fetchedProducts = try await Product.products(for: Self.allProductIDs)
            self.products = fetchedProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load StoreKit products: \(error.localizedDescription)")
            self.errorMessage = "Could not load subscription products."
        }
    }

    // MARK: - Purchase Flow by Billing Cycle
    public func purchase(cycle: BillingCycle) async -> Bool {
        let targetID = (cycle == .monthly) ? Self.monthlyID : Self.yearlyID

        // If products are loaded, purchase the actual StoreKit product
        if let product = products.first(where: { $0.id == targetID }) {
            return await purchase(product: product)
        }

        // If product is not loaded from App Store
        self.errorMessage = "In-App Purchase product is currently unavailable."
        return false
    }

    // MARK: - StoreKit 2 Purchase
    public func purchase(product: Product) async -> Bool {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updateCustomerProductStatus()
                return true

            case .userCancelled:
                return false

            case .pending:
                return false

            @unknown default:
                return false
            }
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Restore Purchases
    public func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateCustomerProductStatus()
        } catch {
            self.errorMessage = "Failed to sync App Store purchases."
        }
    }

    // MARK: - Update Active Entitlements
    public func updateCustomerProductStatus() async {
        var activeIDs = Set<String>()

        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                if transaction.revocationDate == nil {
                    activeIDs.insert(transaction.productID)
                }
            }
        }

        self.purchasedProductIDs = activeIDs
        self.hasActivePremium = activeIDs.contains(Self.monthlyID) || activeIDs.contains(Self.yearlyID)
    }

    // MARK: - Transaction Updates Listener
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? self.checkVerified(result) {
                    await transaction.finish()
                    await self.updateCustomerProductStatus()
                }
            }
        }
    }

    // Verify JWS Signature on Transaction
    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
}

