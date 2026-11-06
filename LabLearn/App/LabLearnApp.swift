import SwiftUI

public enum AppScreen: Hashable {
    case splash
    case roleSelection
    // School-linked flow
    case connectSchool
    case schoolConnected
    // Independent learner flow
    case learningPlan
    case checkout(BillingCycle)
    case paymentSuccess(BillingCycle)
}

@main
struct LabLearnApp: App {
    @State private var currentScreen: AppScreen = .splash
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch currentScreen {
                case .splash:
                    SplashWelcomeView(
                        onContinueWithApple: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .roleSelection
                            }
                        },
                        onContinueWithEmail: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .roleSelection
                            }
                        },
                        onCreateAccount: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .roleSelection
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                    
                case .roleSelection:
                    RoleSelectionView(
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .splash
                            }
                        },
                        onContinue: { option in
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                if option == .schoolLinked {
                                    currentScreen = .connectSchool
                                } else {
                                    currentScreen = .learningPlan
                                }
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                case .connectSchool:
                    ConnectSchoolView(
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .roleSelection
                            }
                        },
                        onVerificationSuccess: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .schoolConnected
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                case .schoolConnected:
                    SchoolConnectedSuccessView(
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .connectSchool
                            }
                        },
                        onGoToDashboard: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .splash
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                case .learningPlan:
                    LearningPlanView(
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .roleSelection
                            }
                        },
                        onContinue: { cycle, isPremium in
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .checkout(cycle)
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                case .checkout(let cycle):
                    CheckoutPaymentView(
                        billingCycle: cycle,
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .learningPlan
                            }
                        },
                        onPaymentCompleted: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .paymentSuccess(cycle)
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                case .paymentSuccess(let cycle):
                    PaymentSuccessView(
                        billingCycle: cycle,
                        onBack: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .checkout(cycle)
                            }
                        },
                        onExploreLabs: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                currentScreen = .splash
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
