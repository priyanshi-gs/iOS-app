import SwiftUI

public struct BadgesScreen: View {
    let initialData: [CarawinBadgeData]
    let earnedCount: Int?
    let onBack: () -> Void

    @State private var selectedFilter: BadgeFilter = .all
    @State private var liveBadges: [CarawinBadgeData] = []
    @State private var isLoading: Bool = false

    private var activeBadges: [CarawinBadgeData] {
        liveBadges.isEmpty ? (initialData.isEmpty ? BadgesScreen.sampleBadges : initialData) : liveBadges
    }

    private var totalCount: Int { activeBadges.count }
    private var earned: Int { earnedCount ?? activeBadges.filter(\.isEarned).count }
    private var locked: Int { totalCount - earned }
    private var completionPercent: Double { totalCount > 0 ? Double(earned) / Double(totalCount) : 0 }

    private var filteredData: [CarawinBadgeData] {
        switch selectedFilter {
        case .all: return activeBadges
        case .chemistry: return activeBadges.filter { $0.category.lowercased() == "chemistry" }
        case .physics: return activeBadges.filter { $0.category.lowercased() == "physics" }
        case .biology: return activeBadges.filter { $0.category.lowercased() == "biology" }
        case .milestones: return activeBadges.filter { $0.category.lowercased() == "milestone" }
        }
    }

    public init(data: [CarawinBadgeData], earnedCount: Int? = nil, onBack: @escaping () -> Void) {
        self.initialData = data
        self.earnedCount = earnedCount
        self.onBack = onBack
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header
            WaveHeader(title: "My Badges", showBackButton: true, onBack: onBack)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: - Achievement Banner
                    HStack(spacing: 14) {
                        // Trophy icon tile
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Theme.yellow)
                            .frame(width: 58, height: 58)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "1A3A6E"), Color(hex: "0B2448")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                            )

                        // Stats
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ACHIEVEMENT BADGES")
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(Theme.yellow)

                            Text("\(earned) / \(totalCount) Badges")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)

                            HStack(spacing: 6) {
                                Text("\(earned) Earned")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.85))
                                Text("·")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("\(locked) Locked")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }

                        Spacer(minLength: 0)

                        // Circular progress ring
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.15), lineWidth: 7)
                                .frame(width: 64, height: 64)

                            Circle()
                                .trim(from: 0, to: completionPercent)
                                .stroke(
                                    Theme.yellow,
                                    style: StrokeStyle(lineWidth: 7, lineCap: .round)
                                )
                                .frame(width: 64, height: 64)
                                .rotationEffect(.degrees(-90))

                            VStack(spacing: 1) {
                                Text("\(Int(completionPercent * 100))%")
                                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                Text("Completed")
                                    .font(.system(size: 8, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "11437B"), Color(hex: "0A2648")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )

                    // MARK: - Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            filterTab(.all, label: "All (\(totalCount))", isFirst: true)
                            filterDivider()
                            filterTab(.chemistry, label: "Chemistry")
                            filterDivider()
                            filterTab(.physics, label: "Physics")
                            filterDivider()
                            filterTab(.biology, label: "Biology")
                            filterDivider()
                            filterTab(.milestones, label: "Milestones", isLast: true)
                        }
                    }

                    // MARK: - Badge Grid
                    if filteredData.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "rosette")
                                .font(.system(size: 40))
                                .foregroundColor(Theme.textMuted)
                            Text("No badges in this category")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                    } else {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                            spacing: 12
                        ) {
                            ForEach(filteredData) { badge in
                                BadgeTileView(badge: badge)
                            }
                        }
                    }

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            isLoading = true
            do {
                let badges = try await DataService.shared.fetchUserBadgesLive()
                if !badges.isEmpty {
                    self.liveBadges = badges
                }
            } catch {
                print("Badges live fetch error: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }

    // MARK: - Filter tab builder
    @ViewBuilder
    private func filterTab(_ filter: BadgeFilter, label: String, isFirst: Bool = false, isLast: Bool = false) -> some View {
        Button(action: { withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { selectedFilter = filter } }) {
            Text(label)
                .font(.system(size: 13, weight: selectedFilter == filter ? .bold : .medium))
                .foregroundColor(selectedFilter == filter ? .white : Theme.textSecondary)
                .padding(.horizontal, selectedFilter == filter ? 14 : 12)
                .padding(.vertical, 7)
                .background(
                    selectedFilter == filter ? AnyShapeStyle(Theme.crimson) : AnyShapeStyle(Color.clear),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func filterDivider() -> some View {
        Text("|")
            .font(.system(size: 13))
            .foregroundColor(Theme.borderSubtle)
            .padding(.horizontal, 2)
    }

    // MARK: - Sample badges for preview
    static let sampleBadges: [CarawinBadgeData] = [
        CarawinBadgeData(name: "Titration Master", category: "Chemistry", symbol: "flask.fill", isEarned: true),
        CarawinBadgeData(name: "Safety First", category: "Protocol", symbol: "shield.fill", isEarned: true),
        CarawinBadgeData(name: "Analytical Master", category: "Milestone", symbol: "chart.bar.xaxis", isEarned: true),
        CarawinBadgeData(name: "Beer-Lambert Law", category: "Optics", symbol: "light.max", isEarned: false),
        CarawinBadgeData(name: "Acid-Base Ace", category: "Chemistry", symbol: "flask.fill", isEarned: true),
        CarawinBadgeData(name: "Newtonian Pioneer", category: "Physics", symbol: "atom", isEarned: false),
        CarawinBadgeData(name: "Precision Burette", category: "Lab Skill", symbol: "eyedropper.halffull", isEarned: true),
        CarawinBadgeData(name: "Reaction Kinetics", category: "Chemistry", symbol: "circle.hexagongrid.fill", isEarned: false),
        CarawinBadgeData(name: "Spectra Hunter", category: "Physics", symbol: "waveform.path.ecg", isEarned: true),
        CarawinBadgeData(name: "Molecular Master", category: "Chemistry", symbol: "circle.grid.3x3.fill", isEarned: true),
        CarawinBadgeData(name: "Stoichiometry Star", category: "Chemistry", symbol: "plus.forwardslash.minus", isEarned: false),
        CarawinBadgeData(name: "Lab Veteran", category: "Milestone", symbol: "rosette", isEarned: true),
    ]
}

// MARK: - Filter enum
enum BadgeFilter: String, CaseIterable {
    case all, chemistry, physics, biology, milestones
}

// MARK: - Individual badge tile
struct BadgeTileView: View {
    let badge: CarawinBadgeData

    private var tileColor: Color {
        switch badge.category.lowercased() {
        case "chemistry": return Color(hex: "1E3A8A")
        case "physics":   return Color(hex: "7C3AED")
        case "biology":   return Color(hex: "065F46")
        case "milestone": return Color(hex: "B45309")
        case "protocol":  return Color(hex: "991B1B")
        case "lab skill": return Color(hex: "B45309")
        default:          return Color(hex: "374151")
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                // Icon tile
                Image(systemName: badge.symbol)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        LinearGradient(
                            colors: [tileColor.opacity(0.9), tileColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )

                // Earned / locked badge
                if badge.isEarned {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white, Color(hex: "F59E0B"))
                        .offset(x: 4, y: 4)
                } else {
                    Image(systemName: "lock.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white, Color(hex: "9CA3AF"))
                        .offset(x: 4, y: 4)
                }
            }

            Text(badge.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Theme.oxfordBlue)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(badge.category)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(10)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        .opacity(badge.isEarned ? 1.0 : 0.65)
    }
}

#Preview("My Badges") {
    BadgesScreen(
        data: BadgesScreen.sampleBadges,
        earnedCount: 8,
        onBack: {}
    )
}
