import SwiftUI
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var userProfile: UserProfile
    @Published public var continueLearningLab: Lab?
    @Published public var recentLabs: [Lab] = []
    @Published public var selectedSubject: Subject? = .chemistry
    @Published public var isLoading: Bool = false

    private let dataService: DataService

    @MainActor
    public init(dataService: DataService = .shared) {
        self.dataService = dataService
        self.userProfile = dataService.fetchUserProfile()
        loadData()
    }

    public func loadData() {
        self.isLoading = true

        // Load strictly from live backend
        Task { [weak self] in
            guard let self = self else { return }

            // 1. Fetch live profile (GET /api/v1/auth/me)
            var liveName = "Student"
            var livePlan = "Free Tier"
            var liveSchool: String? = nil

            if let user = try? await AuthService.shared.fetchMeLive() {
                liveName = user.name
                livePlan = user.planName ?? "Free Tier"
                liveSchool = user.schoolName
            } else if let cached = await MainActor.run(body: { AuthService.shared.currentUser }) {
                liveName = cached.name
                livePlan = cached.planName ?? "Free Tier"
                liveSchool = cached.schoolName
            }

            // Determine Access Tier
            let isSchool = liveSchool != nil && !(liveSchool?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isPro = livePlan.lowercased().contains("pro") || livePlan.lowercased().contains("premium") || livePlan.lowercased().contains("unlimited")
            let isProOrSchool = isSchool || isPro || livePlan.lowercased().contains("school")

            let accessTier: String
            if isSchool {
                accessTier = "School Access"
            } else if isPro {
                accessTier = "Pro Access"
            } else {
                accessTier = "Free Access"
            }

            // 2. Fetch live badges (GET /api/v1/users/me/badges)
            var badgeCount = 0
            if let badges = try? await self.dataService.fetchUserBadgesLive() {
                badgeCount = badges.filter { $0.isEarned }.count
            }

            // 3. Fetch live statistics (for total study hours)
            let stats = await self.dataService.fetchStatisticsLive()

            // 4. Fetch live labs (GET /api/v1/labs)
            do {
                let liveLabs = try await self.dataService.fetchLabsLive()
                let accessibleCount = isProOrSchool ? liveLabs.count : liveLabs.filter { !$0.isLocked }.count
                let statsHours = stats.studyHours ?? 0.0
                let completedCount = max(badgeCount, liveLabs.filter { $0.status == .completed }.count)
                let trackedHours = self.dataService.getTotalLabHours(completedLabsCount: completedCount)
                let totalHours = max(statsHours, trackedHours)

                let lastOpenedId = self.dataService.getLastOpenedLabId()
                let recentIds = self.dataService.getRecentOpenedLabIds()

                // Continue learning lab: Last opened lab by user, or in-progress, or first
                let continueLab: Lab?
                if let lastId = lastOpenedId, let matched = liveLabs.first(where: { $0.id == lastId }) {
                    var updated = matched
                    if updated.status == .notStarted {
                        updated.status = .inProgress
                    }
                    continueLab = updated
                } else {
                    continueLab = liveLabs.first { $0.status == .inProgress } ?? liveLabs.first
                }

                // Recent visited labs sorted by user's recent open history
                var orderedLabs: [Lab] = []
                for id in recentIds {
                    if let lab = liveLabs.first(where: { $0.id == id }) {
                        var updated = lab
                        if id == lastOpenedId && updated.status == .notStarted {
                            updated.status = .inProgress
                        }
                        orderedLabs.append(updated)
                    }
                }
                for lab in liveLabs {
                    if !orderedLabs.contains(where: { $0.id == lab.id }) {
                        orderedLabs.append(lab)
                    }
                }

                await MainActor.run {
                    self.recentLabs = orderedLabs
                    self.continueLearningLab = continueLab
                    self.userProfile = UserProfile(
                        name: liveName,
                        availableLabsCount: accessibleCount,
                        badgesWonCount: max(badgeCount, stats.completedLabs ?? 0),
                        labHoursTotal: totalHours,
                        activeLabId: continueLab?.id,
                        accessTierLabel: accessTier
                    )
                    self.isLoading = false
                }
            } catch {
                print("Failed to fetch live labs: \(error.localizedDescription)")
                await MainActor.run {
                    let fallbackHours = self.dataService.getTotalLabHours(completedLabsCount: badgeCount)
                    self.userProfile = UserProfile(
                        name: liveName,
                        availableLabsCount: isProOrSchool ? 6 : 5,
                        badgesWonCount: badgeCount,
                        labHoursTotal: max(stats.studyHours ?? 0.0, fallbackHours),
                        activeLabId: nil,
                        accessTierLabel: accessTier
                    )
                    self.isLoading = false
                }
            }
        }
    }

    public func updateActiveLab(_ lab: Lab) {
        dataService.recordOpenedLab(id: lab.id)
        var updated = lab
        if updated.status == .notStarted {
            updated.status = .inProgress
        }
        self.continueLearningLab = updated

        // Move to the front of recent labs
        var list = self.recentLabs
        list.removeAll { $0.id == lab.id }
        list.insert(updated, at: 0)
        self.recentLabs = list
    }

    public func selectSubject(_ subject: Subject?) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedSubject == subject {
                // Toggle off to show all
                selectedSubject = nil
            } else {
                selectedSubject = subject
            }
        }
    }
}

