// MARK: - Profile Flow Coordinator
import SwiftUI

// MARK: - Navigation routes for the profile flow
private enum ProfileAccountRoute {
    case profile, connectSchool, connected, statistics, badges, checkout
}

/// Embed this view from your app's Profile tab. It owns no teammate types.
public struct AssignedScreens: View {
    @State private var route: ProfileAccountRoute = .profile
    @State private var liveStatistics: CarawinStatisticsData? = nil
    @State private var liveBadges: [CarawinBadgeData] = []
    @State private var connectedSchoolName: String? = nil
    public var profile: CarawinProfileData?
    public var statistics: CarawinStatisticsData?
    public var badges: [CarawinBadgeData]
    public var onDashboard: () -> Void
    public var onBack: (() -> Void)? = nil
    public var onLogout: (() -> Void)? = nil
    /// Return true when your backend accepts the code. Leave nil for preview‑only behavior.
    public var verifySchoolCode: ((String) -> Bool)?

    public init(
        profile: CarawinProfileData? = nil,
        statistics: CarawinStatisticsData? = nil,
        badges: [CarawinBadgeData] = [],
        verifySchoolCode: ((String) -> Bool)? = nil,
        onBack: (() -> Void)? = nil,
        onLogout: (() -> Void)? = nil,
        onDashboard: @escaping () -> Void = {}
    ) {
        let currentAuthUser = AuthService.shared.currentUser
        self.profile = profile ?? CarawinProfileData(
            name: currentAuthUser?.name ?? "Student",
            email: currentAuthUser?.email ?? "",
            schoolName: currentAuthUser?.schoolName,
            accountType: currentAuthUser?.accountType ?? (currentAuthUser?.schoolName != nil ? "School Enrolled" : "Individual Account"),
            planName: currentAuthUser?.planName ?? "Free Tier",
            availableLabs: 5,
            accountCreated: "Active",
            accountStatus: currentAuthUser?.planStatus ?? "Active",
            lastSynced: "Live",
            badgesEarned: 0
        )
        self.statistics = statistics
        self.badges = badges
        self.verifySchoolCode = verifySchoolCode
        self.onBack = onBack
        self.onLogout = onLogout
        self.onDashboard = onDashboard
    }

    public var body: some View {
        Group {
            switch route {
            case .profile:
                ProfileScreen(
                    data: profile,
                    onBack: onBack,
                    onLogout: onLogout,
                    onUpgrade: { route = .checkout },
                    onConnect: { route = .connectSchool },
                    onStatistics: { route = .statistics },
                    onBadges: { route = .badges }
                )
            case .connectSchool:
                ConnectSchoolScreen(
                    onBack: { route = .profile },
                    onVerified: { route = .connected },
                    onVerifiedSchool: { name in
                        connectedSchoolName = name
                    }
                )
            case .connected:
                SchoolConnectedScreen(schoolName: connectedSchoolName ?? profile?.schoolName, onBack: { route = .profile }, onDashboard: onDashboard)
            case .statistics:
                StatisticsScreen(data: liveStatistics ?? statistics, onBack: { route = .profile })
            case .badges:
                BadgesScreen(data: liveBadges.isEmpty ? badges : liveBadges, earnedCount: liveBadges.filter { $0.isEarned }.count, onBack: { route = .profile })
            case .checkout:
                CheckoutPaymentView(
                    onBack: { route = .profile },
                    onPaymentCompleted: {
                        route = .profile
                    }
                )
            }
        }
        .task {
            let stats = await DataService.shared.fetchStatisticsLive()
            let fetchedBadges = (try? await DataService.shared.fetchUserBadgesLive()) ?? []
            await MainActor.run {
                self.liveStatistics = stats
                self.liveBadges = fetchedBadges
            }
        }
    }

    private func submitSchoolCode(_ code: String) -> Bool {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        if let verifySchoolCode { return verifySchoolCode(trimmed) }
        return true // preview mode
    }
}
