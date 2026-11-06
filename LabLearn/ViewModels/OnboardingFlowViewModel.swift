import Foundation
import SwiftUI
import Combine

public enum FlowStep: Int, CaseIterable {
    case splash = 1
    case roleSelection = 2
    case learningPlan = 3
    case payment = 4
    case paymentSuccess = 5
}

public final class OnboardingFlowViewModel: ObservableObject {
    @Published public var currentStep: FlowStep = .splash
    @Published public var selectedRole: LearnerRole = .schoolLinked
    @Published public var billingCycle: BillingCycle = .monthly
    @Published public var selectedPaymentMethod: PaymentMethodType = .upi
    @Published public var promoCode: String = ""
    @Published public var isPromoApplied: Bool = false
    @Published public var isProcessingPayment: Bool = false
    
    // Receipt Data
    @Published public var transactionId: String = "LLN762945038"
    @Published public var transactionDateTime: String = "05 Nov 2026, 09:41 PM"
    
    public init() {}
    
    // Pricing
    public var monthlyPrice: Int { 199 }
    public var yearlyOriginalPrice: Int { 2399 }
    public var yearlyDiscount: Int { 400 }
    public var yearlyFinalPrice: Int { 1999 }
    
    public var totalPayable: Int {
        if billingCycle == .monthly {
            return monthlyPrice
        } else {
            return isPromoApplied ? (yearlyFinalPrice - 100) : yearlyFinalPrice
        }
    }
    
    // Navigation
    public func goTo(_ step: FlowStep) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.currentStep = step
        }
    }
    
    public func goBack() {
        switch currentStep {
        case .splash:
            break
        case .roleSelection:
            goTo(.splash)
        case .learningPlan:
            goTo(.roleSelection)
        case .payment:
            goTo(.learningPlan)
        case .paymentSuccess:
            goTo(.payment)
        }
    }
    
    public func applyPromo() {
        if !promoCode.trimmingCharacters(in: .whitespaces).isEmpty {
            withAnimation {
                self.isPromoApplied = true
            }
        }
    }
    
    public func processPayment() {
        isProcessingPayment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isProcessingPayment = false
            self.transactionId = "LLN\(Int.random(in: 100000000...999999999))"
            self.goTo(.paymentSuccess)
        }
    }
}

