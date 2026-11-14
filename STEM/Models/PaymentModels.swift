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

