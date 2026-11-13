import SwiftUI

public struct MainContainerView: View {
    @State private var selectedTab: AppTab = .home
    @State private var activeSimulationLab: Lab? = nil

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
                    }
                )
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

                BrowseLabsView(
                    onLaunchLab: { lab in
                        activeSimulationLab = lab
                    }
                )
                .tabItem {
                    Label(AppTab.labs.title, systemImage: AppTab.labs.icon)
                }
                .tag(AppTab.labs)

                CarawinAssignedScreens(
                    onDashboard: {
                        selectedTab = .home
                    }
                )
                .tabItem {
                    Label(AppTab.profile.title, systemImage: AppTab.profile.icon)
                }
                .tag(AppTab.profile)
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
        }
    }
}
