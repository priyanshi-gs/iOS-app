// MARK: - Profile Flow View Model (logic)
import SwiftUI
import Combine
/// ViewModel for the profile flow. Holds data and simple actions.
public final class ProfileViewModel: ObservableObject {
    @Published public var profile: CarawinProfileData
    @Published public var statistics: CarawinStatisticsData?
    @Published public var badges: [CarawinBadgeData]

    public init(
        profile: CarawinProfileData? = nil,
        statistics: CarawinStatisticsData? = nil,
        badges: [CarawinBadgeData] = []
    ) {
        if let profile = profile {
            self.profile = profile
        } else {
            let currentAuthUser = AuthService.shared.currentUser
            self.profile = CarawinProfileData(
                name: currentAuthUser?.name ?? "Samantha Taylor",
                email: currentAuthUser?.email ?? "samantha.taylor@carawin.edu",
                schoolName: currentAuthUser?.schoolName ?? "Springfield High School",
                accountType: "Individual Account",
                planName: "Basic Learner Plan",
                availableLabs: 5,
                accountCreated: "Sep 2026",
                accountStatus: "Active",
                lastSynced: "Just now",
                badgesEarned: 3
            )
        }
        self.statistics = statistics
        self.badges = badges
    }

    // Helper used by the Connect School screen.
    public func submitSchoolCode(_ code: String, verify: ((String) -> Bool)?) -> Bool {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        if let verify = verify { return verify(trimmed) }
        return true // preview mode
    }
}
