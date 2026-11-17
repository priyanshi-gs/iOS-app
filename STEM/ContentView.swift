import SwiftUI

// Compatibility typealiases — point to the real screens, not the stubs
public typealias ConnectSchoolView = ConnectSchoolScreen
public typealias SchoolConnectedView = SchoolConnectedScreen
public typealias CarawinAssignedScreens = AssignedScreens


public enum AppFlowState {
    case onboarding
    case mainDashboard
}

public enum OnboardingStep: Hashable {
    case splash
    case createAccount
    case roleSelection
    case connectSchool
    case schoolConnected
    case learningPlan
    case checkout(BillingCycle)
    case paymentSuccess(BillingCycle)
}

struct ContentView: View {
    @ObservedObject private var authService = AuthService.shared
    @State private var flowState: AppFlowState = .onboarding
    @State private var currentStep: OnboardingStep = .splash
    @State private var connectedSchoolName: String = "Graphic Era University (GEU)"
    @State private var isShowingInitialSplash: Bool = true
    @State private var isShowingWelcomeVideo: Bool = false
    
    var body: some View {
        ZStack {
            if isShowingInitialSplash {
                InitialLaunchSplashView()
                    .transition(.opacity)
            } else if isShowingWelcomeVideo {
                WelcomeVideoSplashView {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        isShowingWelcomeVideo = false
                    }
                }
                .transition(.opacity)
            } else if flowState == .mainDashboard || (authService.currentUser != nil && authService.authState.isAuthenticated) {
                MainContainerView(
                    onLogout: {
                        authService.signOut()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            flowState = .onboarding
                            currentStep = .splash
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            } else {
                onboardingFlowView
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isShowingInitialSplash = false
                    isShowingWelcomeVideo = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var onboardingFlowView: some View {
        ZStack {
            switch currentStep {
            case .splash:
                SplashWelcomeView(
                    onContinue: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if authService.currentUser != nil && authService.authState.isAuthenticated {
                                flowState = .mainDashboard
                            } else {
                                currentStep = .roleSelection
                            }
                        }
                    },
                    onContinueWithApple: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if authService.currentUser != nil && authService.authState.isAuthenticated {
                                flowState = .mainDashboard
                            } else {
                                currentStep = .roleSelection
                            }
                        }
                    },
                    onContinueWithGoogle: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if authService.currentUser != nil && authService.authState.isAuthenticated {
                                flowState = .mainDashboard
                            } else {
                                currentStep = .roleSelection
                            }
                        }
                    },
                    onCreateAccount: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .createAccount
                        }
                    }
                )
                .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))

            case .createAccount:
                CreateAccountView(
                    onBack: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .splash
                        }
                    },
                    onSubmit: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            currentStep = .splash
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
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
                    },
                    onVerifiedSchool: { schoolName in
                        connectedSchoolName = schoolName
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .schoolConnected:
                SchoolConnectedView(
                    schoolName: connectedSchoolName,
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
