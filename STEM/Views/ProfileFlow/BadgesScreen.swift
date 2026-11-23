import SwiftUI

public struct BadgesScreen: View {
    let initialData: [CarawinBadgeData]
    let earnedCount: Int?
    let onBack: () -> Void

    @State private var selectedFilter: BadgeFilter = .all
    @State private var liveBadges: [CarawinBadgeData] = []
    @State private var hasFetched: Bool = false
    @State private var isLoading: Bool = false
    @State private var selectedBadge: CarawinBadgeData? = nil

    // Strictly live badges from backend. Zero mock fallback!
    private var activeBadges: [CarawinBadgeData] {
        hasFetched ? liveBadges : (liveBadges.isEmpty ? initialData : liveBadges)
    }

    private var totalCount: Int { activeBadges.count }
    private var earned: Int { earnedCount ?? activeBadges.filter(\.isEarned).count }
    private var locked: Int { max(0, totalCount - earned) }
    private var completionPercent: Double { totalCount > 0 ? Double(earned) / Double(totalCount) : 0 }

    private var filteredData: [CarawinBadgeData] {
        switch selectedFilter {
        case .all:
            return activeBadges
        case .chemistry:
            return activeBadges.filter { $0.category.lowercased().contains("chem") }
        case .physics:
            return activeBadges.filter { $0.category.lowercased().contains("phys") }
        case .biology:
            return activeBadges.filter { $0.category.lowercased().contains("bio") }
        case .milestones:
            return activeBadges.filter {
                let cat = $0.category.lowercased()
                return cat.contains("milestone") || cat.contains("protocol") || cat.contains("achievement")
            }
        }
    }

    public init(data: [CarawinBadgeData] = [], earnedCount: Int? = nil, onBack: @escaping () -> Void) {
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
                                if totalCount > 0 {
                                    Text("·")
                                        .foregroundColor(.white.opacity(0.5))
                                    Text("\(locked) Locked")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.6))
                                } else {
                                    Text("·")
                                        .foregroundColor(.white.opacity(0.5))
                                    Text("Complete labs to earn")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                }
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

                    // MARK: - Filter Tabs (Only shown when there are badges to filter)
                    if !activeBadges.isEmpty {
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
                    }

                    // MARK: - Loading Indicator
                    if isLoading && !hasFetched {
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(Theme.crimson)
                                .scaleEffect(1.2)
                            Text("Loading your live badges...")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                    }
                    // MARK: - Empty State (Zero badges earned)
                    else if activeBadges.isEmpty {
                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "FFF1BF"))
                                    .frame(width: 76, height: 76)
                                Image(systemName: "trophy")
                                    .font(.system(size: 34, weight: .semibold))
                                    .foregroundColor(Color(hex: "A8650A"))
                            }
                            .padding(.top, 20)

                            Text("No Badges Yet")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)

                            Text("Complete virtual lab experiments and pass assessments to earn your official verified badges.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .padding(.horizontal, 24)

                            Button(action: onBack) {
                                HStack(spacing: 6) {
                                    Image(systemName: "flask.fill")
                                    Text("Explore Labs")
                                }
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 22)
                                .padding(.vertical, 10)
                                .background(Theme.crimson, in: Capsule())
                            }
                            .padding(.top, 6)
                            .padding(.bottom, 22)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                        .padding(.top, 8)
                    }
                    // MARK: - Category Filter Empty State
                    else if filteredData.isEmpty {
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
                    }
                    // MARK: - Live Badge Grid
                    else {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                            spacing: 12
                        ) {
                            ForEach(filteredData) { badge in
                                BadgeTileView(badge: badge)
                                    .onTapGesture {
                                        selectedBadge = badge
                                    }
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
        .sheet(item: $selectedBadge) { badge in
            BadgeDetailSheet(badge: badge)
        }
        .task {
            await fetchLiveBadges()
        }
        .refreshable {
            await fetchLiveBadges()
        }
    }

    private func fetchLiveBadges() async {
        isLoading = true
        do {
            let fetched = try await DataService.shared.fetchUserBadgesLive()
            await MainActor.run {
                self.liveBadges = fetched
                self.hasFetched = true
                self.isLoading = false
            }
        } catch {
            print("Badges live fetch error: \(error.localizedDescription)")
            await MainActor.run {
                self.hasFetched = true
                self.isLoading = false
            }
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
}

// MARK: - Filter enum
enum BadgeFilter: String, CaseIterable {
    case all, chemistry, physics, biology, milestones
}

// MARK: - Individual badge tile
struct BadgeTileView: View {
    let badge: CarawinBadgeData

    private var tileColor: Color {
        let cat = (badge.category + " " + badge.name).lowercased()
        if cat.contains("chem") { return Color(hex: "1E3A8A") }
        if cat.contains("phys") { return Color(hex: "7C3AED") }
        if cat.contains("bio")  { return Color(hex: "065F46") }
        if cat.contains("milestone") { return Color(hex: "B45309") }
        if cat.contains("protocol") { return Color(hex: "991B1B") }
        return Color(hex: "11437B")
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                // Icon tile or remote image
                Group {
                    if let imgUrlStr = badge.imageUrl, let url = URL(string: imgUrlStr) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(8)
                            default:
                                Image(systemName: badge.symbol)
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        Image(systemName: badge.symbol)
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
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
                .lineLimit(1)
        }
        .padding(10)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        .opacity(badge.isEarned ? 1.0 : 0.65)
    }
}

// MARK: - Badge Detail Sheet
struct BadgeDetailSheet: View {
    let badge: CarawinBadgeData
    @Environment(\.dismiss) private var dismiss

    private var formattedDate: String {
        guard let iso = badge.issuedAt else { return "Verified" }
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = isoFormatter.date(from: iso)
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: iso)
        }
        guard let d = date else { return iso }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: d)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Badge artwork preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "11437B"), Color(hex: "0A2648")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .shadow(color: Color(hex: "11437B").opacity(0.3), radius: 12, x: 0, y: 6)

                        if let imgUrlStr = badge.imageUrl, let url = URL(string: imgUrlStr) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                default:
                                    Image(systemName: badge.symbol)
                                        .font(.system(size: 54))
                                        .foregroundColor(Theme.yellow)
                                }
                            }
                        } else {
                            Image(systemName: badge.symbol)
                                .font(.system(size: 54))
                                .foregroundColor(Theme.yellow)
                        }
                    }
                    .padding(.top, 24)

                    // Title & Lab
                    VStack(spacing: 6) {
                        Text(badge.name)
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                            .multilineTextAlignment(.center)

                        Text(badge.category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)

                    // Status pill
                    HStack(spacing: 6) {
                        if badge.revoked {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(Theme.crimson)
                            Text("REVOKED")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(Theme.crimson)
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(Color(hex: "0F7A55"))
                            Text("ACCREDITED")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(Color(hex: "0F7A55"))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        badge.revoked ? Color(hex: "FDE4EA") : Color(hex: "DFF5EA"),
                        in: Capsule()
                    )

                    // Details Card
                    VStack(spacing: 12) {
                        HStack {
                            Text("Issued")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text(formattedDate)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Theme.oxfordBlue)
                        }

                        if let school = badge.school, !school.isEmpty {
                            Divider()
                            HStack {
                                Text("Institution")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text(school)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                            }
                        }
                    }
                    .padding(16)
                    .background(Theme.surfaceLight, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 24)

                    // External Viewer / Certificate link
                    if let viewer = badge.viewerUrl, let url = URL(string: viewer) {
                        Link(destination: url) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.right.square")
                                Text("View Official Certificate")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Theme.crimson, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer()
                }
            }
            .navigationTitle("Badge Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 15, weight: .semibold))
                }
            }
        }
    }
}
