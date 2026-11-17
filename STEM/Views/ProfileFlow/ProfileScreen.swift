import SwiftUI
import PhotosUI

public struct ProfileScreen: View {
    let data: CarawinProfileData?
    var onBack: (() -> Void)? = nil
    var onLogout: (() -> Void)? = nil
    var onUpgrade: (() -> Void)? = nil
    let onConnect: () -> Void
    let onStatistics: () -> Void
    let onBadges: () -> Void
    @State private var isShowingLogoutConfirmation: Bool = false
    @State private var isShowingUpgradeSheet: Bool = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var liveUser: AuthUser? = AuthService.shared.currentUser
    @State private var liveBadgesCount: Int = 0
    @State private var liveEarnedBadges: [CarawinBadgeData] = []
    @State private var liveLabs: [Lab] = []
    @State private var lastSyncTime: String = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)

    // Derived live display values from GET /api/v1/auth/me
    private var displayName: String { liveUser?.name ?? data?.name ?? "Student" }
    private var displayEmail: String { liveUser?.email ?? data?.email ?? "" }
    private var displayPlan: String { liveUser?.planName ?? data?.planName ?? "Free Tier" }
    private var displayAccountType: String {
        if let school = liveUser?.schoolName ?? data?.schoolName, !school.isEmpty {
            return school
        }
        return liveUser?.accountType ?? data?.accountType ?? "Individual Account"
    }

    private var isPro: Bool {
        let plan = displayPlan.lowercased()
        return plan.contains("pro") || plan.contains("premium") || plan.contains("unlimited")
    }

    private var isSchool: Bool {
        let plan = displayPlan.lowercased()
        let hasSchool = !(liveUser?.schoolName ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return hasSchool || plan.contains("school") || plan.contains("enterprise")
    }

    private var isProOrSchool: Bool {
        isPro || isSchool
    }

    private var totalLabsCount: Int {
        !liveLabs.isEmpty ? liveLabs.count : (data?.availableLabs ?? 6)
    }

    private var accessibleLabsCount: Int {
        if isProOrSchool {
            return totalLabsCount
        }
        if !liveLabs.isEmpty {
            let unlocked = liveLabs.filter { !$0.isLocked }.count
            return unlocked > 0 ? unlocked : min(5, totalLabsCount)
        }
        return min(5, totalLabsCount)
    }

    private var labAccessRatio: CGFloat {
        guard totalLabsCount > 0 else { return 0.5 }
        if isProOrSchool { return 1.0 }
        return min(max(CGFloat(accessibleLabsCount) / CGFloat(totalLabsCount), 0.0), 1.0)
    }

    private var labAccessLabelText: String {
        if isProOrSchool {
            return "All \(totalLabsCount) Labs Unlocked (\(isSchool ? "SCHOOL" : "PRO"))"
        } else {
            return "\(accessibleLabsCount) of \(totalLabsCount) Labs Accessible"
        }
    }

    private var planDescriptionText: String {
        if isSchool {
            let school = liveUser?.schoolName ?? "School"
            return "Enrolled in \(school) • Full school curriculum access"
        } else if isPro {
            return "Individual Pro Plan • Full unlimited access to all labs"
        } else {
            return "Self-directed student curriculum access"
        }
    }

    private var initials: String {
        let parts = displayName.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first.map(String.init) }.joined().uppercased()
    }

    // Avatar circle with edit pencil — rendered as overlay on WaveHeader
    private var avatarView: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Profile circle
                Group {
                    if let profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle()
                            .fill(Theme.oxfordBlue)
                            .overlay(
                                Text(initials)
                                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(color: Color.black.opacity(0.18), radius: 8, y: 3)

                // Pencil edit badge
                Image(systemName: "pencil")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(Theme.crimson, in: Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: 2, y: 2)
            }
        }
        .onChange(of: selectedPhoto) { newItem in
            Task { @MainActor in
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header (same as all other screens)
            // Avatar overlaid at the bottom of the wave, rendered ABOVE the navy gradient
            WaveHeader(title: "", showBackButton: onBack != nil, onBack: onBack)
                .overlay(alignment: .bottom) {
                    avatarView
                        .offset(y: 40) // half below the wave edge
                }
                .padding(.bottom, 40) // reserve space so scroll starts below avatar

            // MARK: - Scrollable Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // Name + Email + Account type badge (avatar space already given by wave padding)
                    VStack(spacing: 6) {
                        Text(displayName)
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)

                        Text(displayEmail)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Theme.textSecondary)

                        HStack(spacing: 5) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 12, weight: .semibold))
                            Text(displayAccountType)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(Theme.oxfordBlue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color(hex: "EFF6FF"), in: Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                    // MARK: - Plan & Entitlement (Live from Server)
                    sectionHeader("Plan & Entitlement", trailingText: displayPlan)

                    VStack(alignment: .leading, spacing: 14) {
                        // Plan header row
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text(displayPlan)
                                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                                        .foregroundColor(Theme.oxfordBlue)
                                    Text(liveUser?.planStatus ?? (isProOrSchool ? "ACTIVE" : "FREE"))
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(isProOrSchool ? Color(hex: "065F46") : Theme.textSecondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(isProOrSchool ? Color(hex: "ECFDF5") : Theme.borderSubtle, in: Capsule())
                                }
                                Text(planDescriptionText)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                            Image(systemName: isSchool ? "building.columns.fill" : (isPro ? "crown.fill" : "desktopcomputer"))
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(isPro ? Theme.yellow : Theme.oxfordBlue)
                        }

                        // Progress bar row
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Available Lab Access")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text(labAccessLabelText)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Theme.borderSubtle).frame(height: 7)
                                    Capsule()
                                        .fill(isProOrSchool ? Color(hex: "059669") : Theme.oxfordBlue)
                                        .frame(width: max(geo.size.width * labAccessRatio, 0), height: 7)
                                }
                            }
                            .frame(height: 7)
                        }

                        // Conditional Action Buttons
                        if isSchool {
                            // School License Active Indicator
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "059669"))
                                Text("School License Active • \(liveUser?.schoolName ?? "Enrolled")")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "065F46"))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(hex: "ECFDF5"), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color(hex: "A7F3D0"), lineWidth: 1)
                            )

                            // Option to switch or link another school
                            Button(action: onConnect) {
                                HStack(spacing: 6) {
                                    Text("Link Different School Code")
                                        .font(.system(size: 12, weight: .semibold))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(Theme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        } else if isPro {
                            // Pro Plan Active Banner
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.yellow)
                                Text("Individual Pro Plan Active")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Theme.yellow.opacity(0.15), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Theme.yellow.opacity(0.4), lineWidth: 1)
                            )

                            // Option to also link a school
                            Button(action: onConnect) {
                                HStack(spacing: 8) {
                                    Text("Have a school code? Link School")
                                        .font(.system(size: 13, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .heavy))
                                }
                                .foregroundColor(Theme.oxfordBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color(hex: "EFF6FF"), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        } else {
                            // Free Tier: Upgrade to Pro & Link School buttons
                            Button(action: {
                                if let onUpgrade = onUpgrade {
                                    onUpgrade()
                                } else {
                                    isShowingUpgradeSheet = true
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text("Upgrade to Individual Pro")
                                        .font(.system(size: 14, weight: .bold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .heavy))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(Theme.oxfordBlue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            .buttonStyle(.plain)

                            Button(action: onConnect) {
                                HStack(spacing: 8) {
                                    Text("Have a school code? Link School")
                                        .font(.system(size: 13, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .heavy))
                                }
                                .foregroundColor(Theme.oxfordBlue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color(hex: "EFF6FF"), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - My Badges
                    HStack {
                        sectionHeaderLabel("My Badges")
                        Spacer()
                        Button(action: onBadges) {
                            Text("View All →")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.crimson)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Theme.crimson.opacity(0.1), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }

                    // Badge previews row
                    HStack(spacing: 10) {
                        if liveEarnedBadges.isEmpty {
                            HStack(spacing: 10) {
                                Image(systemName: "rosette")
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.textMuted)
                                    .frame(width: 48, height: 48)
                                    .background(Theme.surfaceWarm, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("No Badges Yet")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Theme.oxfordBlue)
                                    Text("Complete virtual labs to earn accredited badges")
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.textSecondary)
                                        .lineLimit(2)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(Array(liveEarnedBadges.prefix(3))) { badge in
                                VStack(spacing: 6) {
                                    Group {
                                        if let imgUrlStr = badge.imageUrl, let url = URL(string: imgUrlStr) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image.resizable().aspectRatio(contentMode: .fit)
                                                default:
                                                    Image(systemName: badge.symbol)
                                                        .font(.system(size: 22, weight: .semibold))
                                                        .foregroundColor(Theme.primaryBlue)
                                                }
                                            }
                                        } else {
                                            Image(systemName: badge.symbol)
                                                .font(.system(size: 22, weight: .semibold))
                                                .foregroundColor(Theme.primaryBlue)
                                        }
                                    }
                                    .frame(width: 56, height: 56)
                                    .background(Theme.primaryBlue.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                                    Text(badge.name)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Theme.oxfordBlue)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                        // Badge count tile
                        VStack(spacing: 4) {
                            Text("\(liveBadgesCount)")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                            Text("Badges\nWon")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 70, height: 70)
                        .background(Theme.borderSubtle.opacity(0.5), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Theme.borderSubtle, lineWidth: 1)
                        )
                    }
                    .padding(14)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - Learning
                    sectionHeaderLabel("Learning")

                    Button(action: onStatistics) {
                        HStack(spacing: 14) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 46, height: 46)
                                .background(Theme.primaryBlue, in: RoundedRectangle(cornerRadius: 13, style: .continuous))

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Learning Statistics")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                                Text("View your learning progress and performance")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.crimson)
                        }
                        .padding(16)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)

                    // MARK: - Account Specifications
                    sectionHeaderLabel("Account Specifications")

                    VStack(spacing: 0) {
                        accountRow(icon: "envelope.fill",
                                   label: "Registered Email",
                                   value: displayEmail.isEmpty ? "Not available" : displayEmail,
                                   valueStyle: .plain)
                        Divider().padding(.leading, 42)
                        accountRow(icon: "calendar",
                                   label: "Account Created",
                                   value: "Active Member",
                                   valueStyle: .plain)
                        Divider().padding(.leading, 42)
                        accountRow(icon: "person.circle.fill",
                                   label: "Account Status",
                                   value: isSchool ? "Enrolled Student" : (isPro ? "Active Pro Subscriber" : "Active Free Learner"),
                                   valueStyle: .badge)
                        Divider().padding(.leading, 42)
                        accountRow(icon: "clock.fill",
                                   label: "Last Synchronized",
                                   value: "Today at \(lastSyncTime)",
                                   valueStyle: .plain)
                    }
                    .padding(.vertical, 4)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - Sign Out
                    Button(action: { isShowingLogoutConfirmation = true }) {
                        HStack(spacing: 10) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18, weight: .bold))
                            Text("Sign Out")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundColor(Theme.crimson)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Theme.crimson.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .confirmationDialog("Sign Out", isPresented: $isShowingLogoutConfirmation, titleVisibility: .visible) {
                        Button("Sign Out", role: .destructive) { onLogout?() }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to sign out of LABS?")
                    }

                    // Footer note
                    Text("Session secured via Carawin JWT encryption.")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Theme.textMuted)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 18)
            }
            .background(Theme.screenBackground)
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isShowingUpgradeSheet) {
            CheckoutPaymentView(onBack: { isShowingUpgradeSheet = false })
        }
        .task {
            await reloadLiveProfileData()
        }
        .onAppear {
            Task {
                await reloadLiveProfileData()
            }
        }
    }

    @MainActor
    private func reloadLiveProfileData() async {
        // 1. Live fetch user profile (GET /api/v1/auth/me)
        if let user = try? await AuthService.shared.fetchMeLive() {
            self.liveUser = user
        }
        // 2. Live fetch badges count & items (GET /api/v1/users/me/badges)
        if let badges = try? await DataService.shared.fetchUserBadgesLive() {
            let earned = badges.filter { $0.isEarned }
            self.liveEarnedBadges = earned
            self.liveBadgesCount = earned.count
        }
        // 3. Live fetch labs (GET /api/v1/labs) to compute actual accessible labs vs total
        if let labs = try? await DataService.shared.fetchLabsLive() {
            self.liveLabs = labs
        }
        self.lastSyncTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    }

    // MARK: - Helpers

    // Section header with yellow underline + optional trailing text
    @ViewBuilder
    private func sectionHeader(_ title: String, trailingText: String? = nil) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)
                Capsule()
                    .fill(Theme.yellow)
                    .frame(width: 36, height: 3)
            }
            Spacer()
            if let trailing = trailingText {
                Text(trailing)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }

    @ViewBuilder
    private func sectionHeaderLabel(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
            Capsule()
                .fill(Theme.yellow)
                .frame(width: 36, height: 3)
        }
    }

    enum ValueStyle { case plain, badge }

    @ViewBuilder
    private func accountRow(icon: String, label: String, value: String, valueStyle: ValueStyle) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .frame(width: 30)

            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()

            switch valueStyle {
            case .plain:
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.oxfordBlue)
                    .lineLimit(1)
            case .badge:
                Text(value)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.oxfordBlue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(hex: "EFF6FF"), in: Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#if DEBUG
struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(
            data: CarawinProfileData(
                name: "Student",
                email: "student@labs.carawin.edu",
                schoolName: nil,
                accountType: "Individual Account",
                planName: "Free Tier",
                availableLabs: 5,
                accountCreated: "Active",
                accountStatus: "Active",
                lastSynced: "Live",
                badgesEarned: 0
            ),
            onConnect: {},
            onStatistics: {},
            onBadges: {}
        )
    }
}
#endif
