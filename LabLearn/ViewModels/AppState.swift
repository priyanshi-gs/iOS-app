import SwiftUI
import Combine

public enum AppRoute: Hashable {
    case splash
    case roleSelection
    case connectSchool
    case schoolConnected
    case mainTabs
    case simulation(PeriodicElement)
    case subscription
    case checkout
    case paymentSuccess
}

public enum TabItem: String, CaseIterable, Identifiable {
    case home = "Home"
    case labs = "Labs"
    case simulation = "Simulation"
    case stats = "Stats"
    case profile = "Profile"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .labs: return "flask.fill"
        case .simulation: return "atom"
        case .stats: return "chart.bar.xaxis"
        case .profile: return "person.fill"
        }
    }
}

public final class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var currentRoute: AppRoute = .splash
    @Published public var selectedTab: TabItem = .home
    @Published public var selectedRole: LearnerRole = .schoolLinked
    @Published public var currentStudent: Student = Student.sample
    @Published public var activeSchool: School = School.sample
    @Published public var billingCycle: BillingCycle = .yearly
    @Published public var activeOrder: PaymentOrder = PaymentOrder.sample
    
    // Global Navigation Coordinator
    public func navigate(to route: AppRoute) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.currentRoute = route
        }
    }
    
    public func selectRoleAndProceed(_ role: LearnerRole) {
        self.selectedRole = role
        self.currentStudent.role = role
        if role == .schoolLinked {
            navigate(to: .connectSchool)
        } else {
            navigate(to: .subscription)
        }
    }
    
    public func completeSchoolConnection() {
        navigate(to: .schoolConnected)
    }
    
    public func enterMainApp() {
        navigate(to: .mainTabs)
    }
    
    public func startSimulation(for element: PeriodicElement? = nil) {
        selectedTab = .simulation
        navigate(to: .mainTabs)
    }
    
    public func signOut() {
        navigate(to: .splash)
    }
}

