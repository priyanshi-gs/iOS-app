import Foundation

public enum LearnerRole: String, Codable {
    case schoolLinked = "School-linked learner"
    case independent = "Independent learner"
}

public struct Student: Identifiable, Codable {
    public let id: String
    public var name: String
    public var email: String
    public var initials: String
    public var grade: String
    public var role: LearnerRole
    public var schoolName: String?
    public var subscriptionTier: String
    public var registeredDate: String
    public var lastSynchronizedDate: String
    
    public static let sample = Student(
        id: "stu_101",
        name: "Samantha Taylor",
        email: "samantha.taylor@example.edu",
        initials: "ST",
        grade: "Class 11 - PCM",
        role: .schoolLinked,
        schoolName: "Chaplin Pre-University (CPU)",
        subscriptionTier: "Institutional Premium",
        registeredDate: "12 Aug, 2026",
        lastSynchronizedDate: "Today, 02:15 PM"
    )
}

public struct School: Identifiable, Codable {
    public let id: String
    public let name: String
    public let code: String
    public let isVerified: Bool
    public let entitlements: [String]
    
    public static let sample = School(
        id: "sch_cpu",
        name: "Chaplin Pre-University (CPU)",
        code: "EDU-PCM-2026",
        isVerified: true,
        entitlements: [
            "Access to entitled labs",
            "Complete experiments & assessments",
            "Track your learning progress"
        ]
    )
}

public enum BillingCycle: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    public var id: String { rawValue }
}

public struct SubscriptionPlan: Identifiable, Codable {
    public let id: String
    public let title: String
    public let monthlyPrice: Int
    public let yearlyPrice: Int
    public let originalYearlyPrice: Int
    public let discountTag: String?
    public let isPremium: Bool
    public let features: [String]
    
    public func priceText(cycle: BillingCycle) -> String {
        if !isPremium { return "Free" }
        return cycle == .monthly ? "₹\(monthlyPrice) / month" : "₹\(yearlyPrice) / year"
    }
    
    public static let basic = SubscriptionPlan(
        id: "plan_basic",
        title: "Basic",
        monthlyPrice: 0,
        yearlyPrice: 0,
        originalYearlyPrice: 0,
        discountTag: nil,
        isPremium: false,
        features: [
            "Access to 5+ demo labs",
            "Basic learning resources"
        ]
    )
    
    public static let premium = SubscriptionPlan(
        id: "plan_premium",
        title: "Premium",
        monthlyPrice: 199,
        yearlyPrice: 1999,
        originalYearlyPrice: 2399,
        discountTag: "Save 20% (₹400 OFF)",
        isPremium: true,
        features: [
            "Access to complete lab library",
            "30+ PCM interactive labs",
            "Assessments with progress tracking",
            "School & teacher support"
        ]
    )
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

public struct PaymentOrder: Identifiable {
    public let id: String
    public let planTitle: String
    public let billingCycle: BillingCycle
    public let baseAmount: Int
    public let discountAmount: Int
    public var promoCode: String?
    public var selectedMethod: PaymentMethodType
    
    public var totalPayable: Int {
        max(0, baseAmount - discountAmount)
    }
    
    public static let sample = PaymentOrder(
        id: "ORD-98421006",
        planTitle: "Premium Plan (Yearly)",
        billingCycle: .yearly,
        baseAmount: 2399,
        discountAmount: 400,
        promoCode: "EDU2026",
        selectedMethod: .upi
    )
}

public struct LearningStats: Codable {
    public var labsCompleted: Int
    public var totalLabHours: Double
    public var currentStreakDays: Int
    public var avgAssessmentScore: Int
    
    public var physicsProgress: Double // 0.0 - 1.0
    public var chemistryProgress: Double
    public var biologyProgress: Double
    
    public var monthlyBars: [MonthlyData]
    
    public static let sample = LearningStats(
        labsCompleted: 22,
        totalLabHours: 18.5,
        currentStreakDays: 7,
        avgAssessmentScore: 86,
        physicsProgress: 0.72,
        chemistryProgress: 0.88,
        biologyProgress: 0.55,
        monthlyBars: [
            MonthlyData(month: "Jun", hours: 4.2),
            MonthlyData(month: "Jul", hours: 8.5),
            MonthlyData(month: "Aug", hours: 12.0),
            MonthlyData(month: "Sep", hours: 15.2),
            MonthlyData(month: "Oct", hours: 18.5),
            MonthlyData(month: "Nov", hours: 6.0)
        ]
    )
}

public struct MonthlyData: Identifiable, Codable {
    public var id: String { month }
    public let month: String
    public let hours: Double
}
