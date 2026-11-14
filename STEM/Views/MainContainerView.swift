import SwiftUI

public struct MainContainerView: View {
    @State private var selectedTab: AppTab = .home
    @State private var activeSimulationLab: Lab? = nil
    @State private var isProfilePresented: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView(
                    onLaunchSimulation: { lab in
                        activeSimulationLab = lab
                    },
                    onNavigateToBrowse: {
                        selectedTab = .labs
                    },
                    onOpenProfile: {
                        isProfilePresented = true
                    }
                )
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

                BrowseLabsView(
                    onLaunchLab: { lab in
                        activeSimulationLab = lab
                    },
                    onOpenProfile: {
                        isProfilePresented = true
                    }
                )
                .tabItem {
                    Label(AppTab.labs.title, systemImage: AppTab.labs.icon)
                }
                .tag(AppTab.labs)
            }
            .tint(Theme.oxfordBlue)
            .navigationDestination(isPresented: Binding(
                get: { activeSimulationLab != nil },
                set: { if !$0 { activeSimulationLab = nil } }
            )) {
                if let lab = activeSimulationLab {
                    SimulationView(
                        onBack: {
                            activeSimulationLab = nil
                        }
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
            .navigationDestination(isPresented: $isProfilePresented) {
                CarawinAssignedScreens(
                    onBack: {
                        isProfilePresented = false
                    },
                    onDashboard: {
                        isProfilePresented = false
                        selectedTab = .home
                    }
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
