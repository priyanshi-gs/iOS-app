import Foundation

public enum BillingCycle: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    public var id: String { rawValue }
}

public enum PaymentMethodType: String, CaseIterable, Identifiable {
    case upi = "UPI"
    case card = "Credit / Debit Card"
    case netBanking = "Net Banking"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .upi: return "qrcode"
        case .card: return "creditcard.fill"
        case .netBanking: return "building.columns.fill"
        }
    }
}

public struct CarawinPlan: Identifiable, Codable {
    public let id: String
    public let name: String
    public let type: String
    public let description: String?
    public let priceInPaise: Int
    public let currency: String
    public let durationDays: Int
    public let graceDays: Int?
    public let allLabs: Bool
    public let active: Bool
    public let labsCount: Int

    public init(
        id: String,
        name: String,
        type: String = "INDIVIDUAL",
        description: String? = nil,
        priceInPaise: Int,
        currency: String = "INR",
        durationDays: Int = 30,
        graceDays: Int? = 0,
        allLabs: Bool = true,
        active: Bool = true,
        labsCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.priceInPaise = priceInPaise
        self.currency = currency
        self.durationDays = durationDays
        self.graceDays = graceDays
        self.allLabs = allLabs
        self.active = active
        self.labsCount = labsCount
    }

    public var priceInRupees: Int {
        priceInPaise / 100
    }

    public var formattedPrice: String {
        "₹\(priceInRupees)"
    }

    public var isMonthly: Bool {
        durationDays <= 31
    }

    public var isYearly: Bool {
        durationDays >= 300
    }
}


