import SwiftUI

public enum LabNavRoute: Hashable {
    case overview(Lab)
    case study(Lab)
    case simulation(Lab)
    case test(Lab)
    case result(Lab)
    case profile
    case notifications
}

public struct MainContainerView: View {
    @State private var selectedTab: AppTab = .home
    @State private var browseSubjectFilter: Subject? = nil
    @State private var navigationPath = NavigationPath()
    public var onLogout: (() -> Void)?

    public init(onLogout: (() -> Void)? = nil) {
        self.onLogout = onLogout
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                HomeView(
                    onLaunchSimulation: { lab in
                        DataService.shared.recordOpenedLab(id: lab.id)
                        navigationPath.append(LabNavRoute.overview(lab))
                    },
                    onNavigateToBrowse: { subject in
                        browseSubjectFilter = subject
                        selectedTab = .labs
                    },
                    onOpenProfile: {
                        navigationPath.append(LabNavRoute.profile)
                    },
                    onOpenNotifications: {
                        navigationPath.append(LabNavRoute.notifications)
                    }
                )
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

                BrowseLabsView(
                    selectedSubject: browseSubjectFilter,
                    onLaunchLab: { lab in
                        DataService.shared.recordOpenedLab(id: lab.id)
                        navigationPath.append(LabNavRoute.overview(lab))
                    },
                    onOpenProfile: {
                        navigationPath.append(LabNavRoute.profile)
                    }
                )
                .tabItem {
                    Label(AppTab.labs.title, systemImage: AppTab.labs.icon)
                }
                .tag(AppTab.labs)
            }
            .tint(Theme.oxfordBlue)
            .navigationDestination(for: LabNavRoute.self) { route in
                switch route {
                case .overview(let lab):
                    LabOverviewScreen(
                        lab: lab,
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onContinueLab: {
                            navigationPath.append(LabNavRoute.study(lab))
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .study(let lab):
                    StudyMaterialScreen(
                        lab: lab,
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onProceedToExperiment: {
                            navigationPath.append(LabNavRoute.simulation(lab))
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .simulation(let lab):
                    LabSimulationPlayerView(
                        lab: lab,
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onCompleteExperiment: {
                            navigationPath.append(LabNavRoute.test(lab))
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .test(let lab):
                    LabAssessmentScreen(
                        lab: lab,
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onCompleteTest: {
                            navigationPath.append(LabNavRoute.result(lab))
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .result(let lab):
                    LabResultScreen(
                        lab: lab,
                        onBackToLabs: {
                            navigationPath = NavigationPath()
                        },
                        onViewAllBadges: {
                            navigationPath = NavigationPath()
                            navigationPath.append(LabNavRoute.profile)
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .profile:
                    CarawinAssignedScreens(
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onLogout: {
                            navigationPath = NavigationPath()
                            onLogout?()
                        },
                        onDashboard: {
                            navigationPath = NavigationPath()
                            selectedTab = .home
                        }
                    )
                    .navigationBarBackButtonHidden(true)

                case .notifications:
                    NotificationsScreen(
                        onBack: {
                            if !navigationPath.isEmpty {
                                navigationPath.removeLast()
                            }
                        },
                        onSelectLabId: { labId in
                            if let lab = DataService.shared.getLab(by: labId) {
                                navigationPath.append(LabNavRoute.overview(lab))
                            }
                        }
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}
