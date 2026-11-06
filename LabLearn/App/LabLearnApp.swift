import SwiftUI

@main
struct LabLearnApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
        }
    }
}

public struct RootCoordinatorView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        Group {
            switch appState.currentRoute {
            case .splash:
                SplashLoginView()
            case .roleSelection:
                RoleSelectionView()
            case .connectSchool:
                ConnectSchoolView()
            case .schoolConnected:
                SchoolConnectedSuccessView()
            case .mainTabs:
                MainTabView()
            case .subscription:
                LearningPlanView()
            case .checkout:
                CheckoutPaymentView()
            case .paymentSuccess:
                PaymentSuccessView()
            case .simulation(let element):
                PeriodicLabView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.currentRoute)
    }
}
