import Foundation
import Combine

public final class SubscriptionViewModel: ObservableObject {
    @Published public var billingCycle: BillingCycle = .yearly
    @Published public var selectedPlan: SubscriptionPlan = SubscriptionPlan.premium
    @Published public var promoCode: String = "EDU2026"
    @Published public var isPromoApplied: Bool = true
    @Published public var selectedPaymentMethod: PaymentMethodType = .upi
    @Published public var isProcessingPayment: Bool = false
    
    public let basicPlan = SubscriptionPlan.basic
    public let premiumPlan = SubscriptionPlan.premium
    
    public init() {}
    
    public var currentPrice: Int {
        billingCycle == .monthly ? selectedPlan.monthlyPrice : selectedPlan.yearlyPrice
    }
    
    public var originalPrice: Int {
        billingCycle == .monthly ? selectedPlan.monthlyPrice : selectedPlan.originalYearlyPrice
    }
    
    public var discountAmount: Int {
        billingCycle == .monthly ? 0 : 400
    }
    
    public func selectCycle(_ cycle: BillingCycle) {
        self.billingCycle = cycle
    }
    
    public func applyPromo() {
        if promoCode.uppercased() == "EDU2026" {
            isPromoApplied = true
        }
    }
    
    public func processPayment(completion: @escaping (PaymentOrder) -> Void) {
        isProcessingPayment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isProcessingPayment = false
            let order = PaymentOrder(
                id: "ORD-\(Int.random(in: 10000000...99999999))",
                planTitle: "Premium Plan (\(self.billingCycle.rawValue))",
                billingCycle: self.billingCycle,
                baseAmount: self.originalPrice,
                discountAmount: self.discountAmount,
                promoCode: self.promoCode,
                selectedMethod: self.selectedPaymentMethod
            )
            completion(order)
        }
    }
}

public final class StatsAndBadgesViewModel: ObservableObject {
    @Published public var selectedBadgeSubject: Subject = .all
    @Published public var allBadges: [Badge] = Badge.sampleBadges
    @Published public var stats: LearningStats = LearningStats.sample
    
    public init() {}
    
    public var earnedCount: Int {
        allBadges.filter { $0.isEarned }.count
    }
    
    public var totalCount: Int {
        allBadges.count
    }
    
    public var completionPercentage: Int {
        guard totalCount > 0 else { return 0 }
        return Int((Double(earnedCount) / Double(totalCount)) * 100)
    }
    
    public var filteredBadges: [Badge] {
        if selectedBadgeSubject == .all {
            return allBadges
        }
        return allBadges.filter { $0.subject == selectedBadgeSubject }
    }
}

public final class ProfileViewModel: ObservableObject {
    @Published public var student: Student = Student.sample
    @Published public var activeSchool: School = School.sample
    
    public init() {}
}

