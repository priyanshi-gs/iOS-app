import SwiftUI

public enum AppFlowState {
    case onboarding
    case mainDashboard
}

public enum OnboardingStep: Hashable {
    case splash
    case roleSelection
    case connectSchool
    case schoolConnected
    case learningPlan
    case checkout(BillingCycle)
    case paymentSuccess(BillingCycle)
}

struct ContentView: View {
    @State private var flowState: AppFlowState = .onboarding
    @State private var currentStep: OnboardingStep = .splash
    
    var body: some View {
        ZStack {
            switch flowState {
            case .onboarding:
                onboardingFlowView
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                
            case .mainDashboard:
                MainContainerView(
                    onLogout: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            flowState = .onboarding
                            currentStep = .splash
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    private var onboardingFlowView: some View {
        ZStack {
            switch currentStep {
            case .splash:
                SplashWelcomeView(
                    onContinueWithApple: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .roleSelection
                        }
                    },
                    onContinueWithEmail: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .roleSelection
                        }
                    },
                    onCreateAccount: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .roleSelection
                        }
                    }
                )
                .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                
            case .roleSelection:
                RoleSelectionView(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .splash
                        }
                    },
                    onContinue: { option in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            switch option {
                            case .schoolLinked:
                                currentStep = .connectSchool
                            case .independent:
                                currentStep = .learningPlan
                            }
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .connectSchool:
                ConnectSchoolView(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .roleSelection
                        }
                    },
                    onVerified: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .schoolConnected
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .schoolConnected:
                SchoolConnectedView(
                    schoolName: "Springfield High School",
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .connectSchool
                        }
                    },
                    onDashboard: {
                        withAnimation(.spring(response: 0.40, dampingFraction: 0.8)) {
                            flowState = .mainDashboard
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                
            case .learningPlan:
                LearningPlanView(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .roleSelection
                        }
                    },
                    onContinue: { cycle, isPremium in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if isPremium {
                                currentStep = .checkout(cycle)
                            } else {
                                // Basic plan is free: link directly to the dashboard
                                flowState = .mainDashboard
                            }
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .checkout(let cycle):
                CheckoutPaymentView(
                    billingCycle: cycle,
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .learningPlan
                        }
                    },
                    onPaymentCompleted: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .paymentSuccess(cycle)
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .paymentSuccess(let cycle):
                PaymentSuccessView(
                    billingCycle: cycle,
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .checkout(cycle)
                        }
                    },
                    onExploreLabs: {
                        withAnimation(.spring(response: 0.40, dampingFraction: 0.8)) {
                            flowState = .mainDashboard
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
    }
}

#Preview {
    ContentView()
}
