import SwiftUI

// MARK: - Data supplied by the host app/backend

public struct CarawinProfileData {
    public var name: String?
    public var email: String?
    public var schoolName: String?
    public var accountType: String?
    public var planName: String?
    public var availableLabs: Int?
    public var accountCreated: String?
    public var accountStatus: String?
    public var lastSynced: String?
    public var badgesEarned: Int?

    public init(
        name: String? = nil, email: String? = nil, schoolName: String? = nil,
        accountType: String? = nil, planName: String? = nil, availableLabs: Int? = nil,
        accountCreated: String? = nil, accountStatus: String? = nil,
        lastSynced: String? = nil, badgesEarned: Int? = nil
    ) {
        self.name = name; self.email = email; self.schoolName = schoolName
        self.accountType = accountType; self.planName = planName; self.availableLabs = availableLabs
        self.accountCreated = accountCreated; self.accountStatus = accountStatus
        self.lastSynced = lastSynced; self.badgesEarned = badgesEarned
    }
}

public struct CarawinStatisticsData {
    public var completedLabs: Int?
    public var totalLabs: Int?
    public var studyHours: Double?
    public var learningStreakDays: Int?
    public var assessmentPercent: Int?
    public var physicsPercent: Int?
    public var chemistryPercent: Int?
    public var biologyPercent: Int?

    public init(completedLabs: Int? = nil, totalLabs: Int? = nil, studyHours: Double? = nil,
                learningStreakDays: Int? = nil, assessmentPercent: Int? = nil,
                physicsPercent: Int? = nil, chemistryPercent: Int? = nil, biologyPercent: Int? = nil) {
        self.completedLabs = completedLabs; self.totalLabs = totalLabs; self.studyHours = studyHours
        self.learningStreakDays = learningStreakDays; self.assessmentPercent = assessmentPercent
        self.physicsPercent = physicsPercent; self.chemistryPercent = chemistryPercent; self.biologyPercent = biologyPercent
    }
}

public struct CarawinBadgeData: Identifiable {
    public let id: String
    public let name: String
    public let category: String
    public let symbol: String
    public let isEarned: Bool

    public init(id: String, name: String, category: String, symbol: String, isEarned: Bool = true) {
        self.id = id; self.name = name; self.category = category; self.symbol = symbol; self.isEarned = isEarned
    }
}

// MARK: - Five assigned screens

private enum CarawinAccountRoute {
    case profile, connectSchool, connected, statistics, badges
}

/// Embed this view from your app's Profile tab. It has no app entry point and owns no teammate types.
public struct CarawinAssignedScreens: View {
    @State private var route: CarawinAccountRoute = .profile
    public var profile: CarawinProfileData?
    public var statistics: CarawinStatisticsData?
    public var badges: [CarawinBadgeData]
    public var onDashboard: () -> Void
    /// Return true when your backend accepts the code. Leave nil for preview-only behavior.
    public var verifySchoolCode: ((String) -> Bool)?

    public init(
        profile: CarawinProfileData? = nil,
        statistics: CarawinStatisticsData? = nil,
        badges: [CarawinBadgeData] = [],
        verifySchoolCode: ((String) -> Bool)? = nil,
        onDashboard: @escaping () -> Void = {}
    ) {
        self.profile = profile
        self.statistics = statistics
        self.badges = badges
        self.verifySchoolCode = verifySchoolCode
        self.onDashboard = onDashboard
    }

    public var body: some View {
        Group {
            switch route {
            case .profile:
                CarawinProfileScreen(data: profile, onConnect: { route = .connectSchool }, onStatistics: { route = .statistics }, onBadges: { route = .badges })
            case .connectSchool:
                CarawinConnectSchoolScreen(
                    onBack: { route = .profile },
                    onVerified: { route = .connected },
                    onSubmit: submitSchoolCode
                )
            case .connected:
                CarawinConnectedScreen(schoolName: profile?.schoolName, onBack: { route = .profile }, onDashboard: onDashboard)
            case .statistics:
                CarawinStatisticsScreen(data: statistics, onBack: { route = .profile })
            case .badges:
                CarawinBadgesScreen(data: badges, earnedCount: profile?.badgesEarned, onBack: { route = .profile })
            }
        }
    }

    private func submitSchoolCode(_ code: String) -> Bool {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        if let verifySchoolCode { return verifySchoolCode(trimmed) }
        return true // Preview mode until the host supplies a backend verifier.
    }
}

private struct CarawinProfileScreen: View {
    let data: CarawinProfileData?
    let onConnect: () -> Void
    let onStatistics: () -> Void
    let onBadges: () -> Void

    var body: some View {
        CarawinPage(title: "Student Profile", back: nil) {
            VStack(spacing: 14) {
                VStack(spacing: 7) {
                    Image(systemName: "person.fill").font(.system(size: 24, weight: .semibold)).foregroundStyle(.white)
                        .frame(width: 58, height: 58).background(CarawinPalette.navy.gradient, in: Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 3)).shadow(color: CarawinPalette.navy.opacity(0.2), radius: 8, y: 4)
                    Text(data?.name ?? "Your Profile").font(.system(size: 21, weight: .heavy)).foregroundStyle(CarawinPalette.ink)
                    Text(data?.email ?? "Personal details appear when your account is connected")
                        .font(.system(size: 14)).foregroundStyle(CarawinPalette.muted).multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(LinearGradient(colors: [.white, CarawinPalette.paleBlue], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .topTrailing) { Circle().fill(CarawinPalette.red.opacity(0.13)).frame(width: 40, height: 40).offset(x: -12, y: 12) }

                VStack(alignment: .leading, spacing: 12) {
                    CarawinSectionTitle(title: "Plan & Entitlement")
                    CarawinDataRow(icon: "person.text.rectangle.fill", title: "Account type", value: data?.accountType ?? "—")
                    CarawinDataRow(icon: "checkmark.seal.fill", title: "Plan details", value: data?.planName ?? "—")
                    CarawinDataRow(icon: "flask.fill", title: "Available lab access", value: data?.availableLabs.map { "\($0) labs" } ?? "—")
                    Button(action: onConnect) {
                        Label("Link your school", systemImage: "plus.circle.fill")
                            .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(LinearGradient(colors: [CarawinPalette.navy, CarawinPalette.blue], startPoint: .leading, endPoint: .trailing), in: Capsule())
                    }
                }.carawinCard()

                HStack {
                    Text("My Badges").font(.system(size: 17, weight: .heavy)).foregroundStyle(CarawinPalette.ink)
                    Spacer()
                    Button("View All  →", action: onBadges).font(.system(size: 13, weight: .bold)).foregroundStyle(CarawinPalette.red)
                }
                HStack(spacing: 12) {
                    Image(systemName: "rosette.fill").font(.system(size: 25, weight: .semibold)).foregroundStyle(CarawinPalette.red)
                        .frame(width: 48, height: 48).background(CarawinPalette.paleGold, in: RoundedRectangle(cornerRadius: 14))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(data?.badgesEarned.map { "\($0) badges earned" } ?? "Your badge collection")
                            .font(.system(size: 14, weight: .semibold)).foregroundStyle(CarawinPalette.ink)
                        Text("Your personal badges appear here").font(.system(size: 12)).foregroundStyle(CarawinPalette.muted)
                    }
                    Spacer()
                }.carawinCard()

                CarawinSectionTitle(title: "Learning")
                Button(action: onStatistics) {
                    HStack(spacing: 12) {
                        Image(systemName: "chart.bar.fill").font(.system(size: 19, weight: .bold)).foregroundStyle(.white)
                            .frame(width: 44, height: 44).background(CarawinPalette.blue.gradient, in: RoundedRectangle(cornerRadius: 13))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Learning Statistics").font(.system(size: 15, weight: .bold)).foregroundStyle(CarawinPalette.ink)
                            Text("View your progress and performance").font(.system(size: 12)).foregroundStyle(CarawinPalette.muted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundStyle(CarawinPalette.red)
                    }.carawinCard()
                }.buttonStyle(.plain)

                CarawinSectionTitle(title: "Account Specifications")
                VStack(spacing: 11) {
                    CarawinDataRow(icon: "envelope.fill", title: "Registered Email", value: data?.email ?? "—")
                    CarawinDataRow(icon: "calendar", title: "Account Created", value: data?.accountCreated ?? "—")
                    CarawinDataRow(icon: "checkmark.shield.fill", title: "Account Status", value: data?.accountStatus ?? "—")
                    CarawinDataRow(icon: "clock.fill", title: "Last Synchronized", value: data?.lastSynced ?? "—")
                }.carawinCard()
            }
        }
    }
}

private struct CarawinConnectSchoolScreen: View {
    let onBack: () -> Void
    let onVerified: () -> Void
    let onSubmit: (String) -> Bool
    @State private var code = ""
    @State private var showCodeAlert = false
    @State private var rejectedCode = false

    var body: some View {
        CarawinPage(title: "Connect School", back: onBack) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Connect your school").font(.system(size: 25, weight: .heavy, design: .rounded)).foregroundStyle(CarawinPalette.ink)
                Text("Enter the referral code provided by your school to verify your access.")
                    .font(.system(size: 15)).foregroundStyle(CarawinPalette.muted)
                Text("SCHOOL REFERRAL CODE").font(.system(size: 11, weight: .heavy)).foregroundStyle(CarawinPalette.ink)
                    .padding(.horizontal, 10).padding(.vertical, 6).background(CarawinPalette.gold.opacity(0.35), in: Capsule())
                HStack(spacing: 11) {
                    Image(systemName: "qrcode.viewfinder").foregroundStyle(CarawinPalette.navy).font(.system(size: 19))
                    TextField("Enter your code", text: $code).font(.system(size: 16))
                        .textInputAutocapitalization(.characters).autocorrectionDisabled().submitLabel(.done).onSubmit(verify)
                    Image(systemName: "viewfinder").foregroundStyle(CarawinPalette.navy).font(.system(size: 19))
                }.padding(15).background(.white, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(CarawinPalette.border, lineWidth: 1))
                Button(action: verify) {
                    Label("Verify Code", systemImage: "arrow.right").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(LinearGradient(colors: [CarawinPalette.red, Color(carawinHex: "B80E32")], startPoint: .top, endPoint: .bottom), in: Capsule())
                        .shadow(color: CarawinPalette.red.opacity(0.2), radius: 7, y: 4)
                }
                HStack(spacing: 11) {
                    Image(systemName: "info.circle.fill").font(.system(size: 22)).foregroundStyle(CarawinPalette.blue)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Ready to verify your school").font(.system(size: 13, weight: .bold)).foregroundStyle(CarawinPalette.ink)
                        Text("Your app will check this code when connected to the backend.").font(.system(size: 12)).foregroundStyle(CarawinPalette.muted)
                    }
                    Spacer(minLength: 0)
                }.padding(13).background(CarawinPalette.paleBlue, in: RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 10) {
                    CarawinSectionTitle(title: "Your Access")
                    CarawinAccessRow(icon: "flask.fill", title: "Access to entitled labs")
                    CarawinAccessRow(icon: "square.stack.3d.up.fill", title: "Experiments & assessments")
                    CarawinAccessRow(icon: "chart.bar.fill", title: "Learning progress")
                }.carawinCard()
            }
        }
        .alert(rejectedCode ? "Code not accepted" : "School code required", isPresented: $showCodeAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(rejectedCode ? "The school code could not be verified." : "Enter your school referral code, then tap Verify Code.")
        }
    }

    private func verify() {
        guard !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            rejectedCode = false
            showCodeAlert = true
            return
        }
        guard onSubmit(code) else {
            rejectedCode = true
            showCodeAlert = true
            return
        }
        onVerified()
    }
}

private struct CarawinConnectedScreen: View {
    let schoolName: String?
    let onBack: () -> Void
    let onDashboard: () -> Void

    var body: some View {
        CarawinPage(title: "School Connected", back: onBack) {
            VStack(spacing: 16) {
                ZStack {
                    Circle().fill(CarawinPalette.paleBlue).frame(width: 164, height: 164)
                    Image(systemName: "building.2.crop.circle.fill").font(.system(size: 85)).foregroundStyle(CarawinPalette.blue)
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 40)).foregroundStyle(.white, CarawinPalette.green).offset(x: 52, y: 49)
                    Image(systemName: "flag.fill").font(.system(size: 21)).foregroundStyle(CarawinPalette.red).offset(x: -4, y: -66)
                    Image(systemName: "sun.max.fill").font(.system(size: 23)).foregroundStyle(CarawinPalette.gold).offset(x: 65, y: -54)
                }.padding(.top, 4)
                VStack(spacing: 2) {
                    Text("School Connected").font(.system(size: 27, weight: .heavy, design: .rounded))
                    Text("Successfully!").font(.system(size: 27, weight: .heavy, design: .rounded))
                }.foregroundStyle(CarawinPalette.ink).multilineTextAlignment(.center)
                Text(schoolName.map { "You are now linked with \($0) and have access to your learning resources." }
                     ?? "Your code was accepted. Your school details will appear here when supplied by the app.")
                    .font(.system(size: 15)).foregroundStyle(CarawinPalette.muted).multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Image(systemName: "graduationcap.fill").font(.system(size: 24)).foregroundStyle(CarawinPalette.navy)
                        .frame(width: 48, height: 48).background(CarawinPalette.paleBlue, in: RoundedRectangle(cornerRadius: 13))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(schoolName ?? "School connection").font(.system(size: 15, weight: .bold)).foregroundStyle(CarawinPalette.ink)
                        Text(schoolName == nil ? "Connected in preview mode" : "School access is active")
                            .font(.system(size: 12)).foregroundStyle(CarawinPalette.muted)
                    }
                    Spacer()
                    Label("Linked", systemImage: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(Color(carawinHex: "087647"))
                        .padding(.horizontal, 10).padding(.vertical, 6).background(Color(carawinHex: "DDF8E9"), in: Capsule())
                }.carawinCard()
                VStack(alignment: .leading, spacing: 10) {
                    CarawinSectionTitle(title: "Your Access")
                    CarawinAccessRow(icon: "flask.fill", title: "Access to entitled labs")
                    CarawinAccessRow(icon: "square.stack.3d.up.fill", title: "Experiments & assessments")
                    CarawinAccessRow(icon: "chart.bar.fill", title: "Learning progress")
                }.carawinCard()
                Button(action: onDashboard) {
                    Label("Go to Dashboard", systemImage: "arrow.right").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(LinearGradient(colors: [CarawinPalette.red, Color(carawinHex: "B80E32")], startPoint: .top, endPoint: .bottom), in: Capsule())
                }
            }
        }
    }
}

private struct CarawinStatisticsScreen: View {
    let data: CarawinStatisticsData?
    let onBack: () -> Void

    var body: some View {
        CarawinPage(title: "Learning Statistics", back: onBack) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("YOUR LEARNING OVERVIEW").font(.system(size: 10, weight: .heavy)).foregroundStyle(CarawinPalette.gold)
                        Text("Learning overview").font(.system(size: 21, weight: .heavy)).foregroundStyle(.white)
                        Text(data == nil ? "Your personal progress will appear when account data is connected." : "A snapshot of your learning activity.")
                            .font(.system(size: 13)).foregroundStyle(.white.opacity(0.88))
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chart.bar.xaxis").font(.system(size: 34)).foregroundStyle(.white)
                }.padding(16).background(LinearGradient(colors: [CarawinPalette.navy, CarawinPalette.blue], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 16))
                HStack(spacing: 8) {
                    CarawinStatTile(icon: "flask.fill", value: data?.completedLabs.map(String.init) ?? "—", label: "Labs completed", tint: CarawinPalette.navy)
                    CarawinStatTile(icon: "clock.fill", value: data?.studyHours.map { String(format: "%.1f h", $0) } ?? "—", label: "Study time", tint: CarawinPalette.red)
                    CarawinStatTile(icon: "flame.fill", value: data?.learningStreakDays.map { "\($0) days" } ?? "—", label: "Learning streak", tint: Color(carawinHex: "D97706"))
                    CarawinStatTile(icon: "checkmark.seal.fill", value: data?.assessmentPercent.map { "\($0)%" } ?? "—", label: "Assessment score", tint: CarawinPalette.blue)
                }
                VStack(spacing: 10) {
                    CarawinSectionTitle(title: "Subject-wise Completion")
                    CarawinSubjectRow(title: "Physics", icon: "atom", percent: data?.physicsPercent, color: CarawinPalette.blue)
                    CarawinSubjectRow(title: "Chemistry", icon: "flask.fill", percent: data?.chemistryPercent, color: CarawinPalette.red)
                    CarawinSubjectRow(title: "Biology", icon: "leaf.fill", percent: data?.biologyPercent, color: CarawinPalette.green)
                }.carawinCard()
                HStack(spacing: 10) {
                    CarawinStatsEmptyCard(title: "Labs Completed", icon: "flask.fill", tint: CarawinPalette.blue, value: data?.totalLabs.map(String.init))
                    CarawinStatsEmptyCard(title: "Monthly Activity", icon: "chart.bar.fill", tint: CarawinPalette.red)
                }
                HStack(spacing: 10) {
                    CarawinStatsEmptyCard(title: "Learning Streak", icon: "flame.fill", tint: Color(carawinHex: "D97706"), value: data?.learningStreakDays.map { "\($0) days" })
                    CarawinStatsEmptyCard(title: "Assessment Score", icon: "checkmark.seal.fill", tint: CarawinPalette.green, value: data?.assessmentPercent.map { "\($0)%" })
                }
            }
        }
    }
}

private struct CarawinBadgesScreen: View {
    let data: [CarawinBadgeData]
    let earnedCount: Int?
    let onBack: () -> Void

    var body: some View {
        CarawinPage(title: "My Badges", back: onBack) {
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: "trophy.fill").font(.system(size: 26)).foregroundStyle(CarawinPalette.gold)
                        .frame(width: 52, height: 52).background(CarawinPalette.navy, in: RoundedRectangle(cornerRadius: 14))
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ACHIEVEMENT BADGES").font(.system(size: 10, weight: .heavy)).foregroundStyle(CarawinPalette.gold)
                        Text(earnedCount.map { "\($0) badges earned" } ?? "Your achievements")
                            .font(.system(size: 18, weight: .heavy)).foregroundStyle(.white)
                        Text("Your personal badge collection").font(.system(size: 12)).foregroundStyle(.white.opacity(0.82))
                    }
                    Spacer(minLength: 0)
                }.padding(14).background(LinearGradient(colors: [CarawinPalette.navy, CarawinPalette.blue], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 16))
                if data.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "rosette.fill").font(.system(size: 36)).foregroundStyle(CarawinPalette.gold)
                            .frame(width: 68, height: 68).background(CarawinPalette.paleGold, in: Circle())
                        Text("No badge details yet").font(.system(size: 18, weight: .bold)).foregroundStyle(CarawinPalette.ink)
                        Text("Your earned badges will appear here when badge data is provided.")
                            .font(.system(size: 14)).foregroundStyle(CarawinPalette.muted).multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity, minHeight: 220).padding(18).carawinCard()
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(data) { badge in
                            VStack(spacing: 7) {
                                Image(systemName: badge.symbol).font(.system(size: 25, weight: .semibold))
                                    .foregroundStyle(badge.isEarned ? CarawinPalette.blue : CarawinPalette.muted)
                                    .frame(maxWidth: .infinity).frame(height: 68)
                                    .background(badge.isEarned ? CarawinPalette.paleBlue : Color(carawinHex: "F0F3F8"), in: RoundedRectangle(cornerRadius: 13))
                                    .overlay(alignment: .bottomTrailing) {
                                        if badge.isEarned { Image(systemName: "checkmark.circle.fill").foregroundStyle(.white, CarawinPalette.green).offset(x: 3, y: 3) }
                                        else { Image(systemName: "lock.fill").font(.system(size: 10)).foregroundStyle(CarawinPalette.muted).offset(x: 3, y: 3) }
                                    }
                                Text(badge.name).font(.system(size: 12, weight: .bold)).foregroundStyle(CarawinPalette.ink).multilineTextAlignment(.center).lineLimit(2)
                                Text(badge.category).font(.system(size: 10)).foregroundStyle(CarawinPalette.muted)
                            }.padding(8).carawinCard()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Reusable private styling, namespaced to avoid clashes

private struct CarawinPage<Content: View>: View {
    let title: String
    let back: (() -> Void)?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                CarawinPalette.navy
                Circle()
                    .trim(from: 0.45, to: 0.95)
                    .stroke(CarawinPalette.red, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .offset(x: 35, y: -45)
                Circle()
                    .trim(from: 0.50, to: 0.85)
                    .stroke(CarawinPalette.gold, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 85, height: 85)
                    .offset(x: 10, y: -20)
                HStack {
                    if let back {
                        Button(action: back) { Image(systemName: "chevron.left").font(.system(size: 16, weight: .bold)).foregroundStyle(.white).frame(width: 42, height: 42) }
                    }
                    Spacer()
                    Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(.white).lineLimit(1)
                    Spacer()
                    if back != nil { Color.clear.frame(width: 42, height: 42) }
                }.padding(.horizontal, 15).padding(.top, 88)
            }
            .frame(height: 148).clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
            .overlay(alignment: .bottom) { Capsule().fill(CarawinPalette.gold).frame(width: 62, height: 2).offset(y: -10) }
            ScrollView(showsIndicators: false) {
                content.padding(.horizontal, 17).padding(.top, 16).padding(.bottom, 100)
                    .frame(maxWidth: 520).frame(maxWidth: .infinity)
            }
            .background(CarawinPageBackground())
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30))
            .offset(y: -1)
        }
        .background(CarawinPalette.navy.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }
}

private struct CarawinSectionTitle: View {
    let title: String
    var body: some View {
        HStack(spacing: 7) {
            Text(title).font(.system(size: 14, weight: .heavy)).foregroundStyle(CarawinPalette.ink)
                .lineLimit(1).minimumScaleFactor(0.75).layoutPriority(1)
            Rectangle().fill(CarawinPalette.gold).frame(height: 2)
        }
    }
}

private struct CarawinDataRow: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundStyle(CarawinPalette.blue).frame(width: 22)
            Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(CarawinPalette.ink)
            Spacer(minLength: 4)
            Text(value).font(.system(size: 12)).foregroundStyle(CarawinPalette.muted).lineLimit(1)
        }
    }
}

private struct CarawinAccessRow: View {
    let icon: String
    let title: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundStyle(CarawinPalette.navy)
                .frame(width: 28, height: 28).background(CarawinPalette.paleBlue, in: RoundedRectangle(cornerRadius: 8))
            Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(CarawinPalette.ink)
            Spacer()
            Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)).foregroundStyle(CarawinPalette.blue)
        }
    }
}

private struct CarawinStatTile: View {
    let icon: String
    let value: String
    let label: String
    let tint: Color
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundStyle(tint)
            Text(value).font(.system(size: 16, weight: .heavy)).foregroundStyle(CarawinPalette.ink)
            Text(label).font(.system(size: 10.5, weight: .medium)).multilineTextAlignment(.center).foregroundStyle(CarawinPalette.muted)
        }.frame(maxWidth: .infinity).frame(height: 78)
            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 13))
            .overlay(RoundedRectangle(cornerRadius: 13).stroke(tint.opacity(0.15), lineWidth: 1))
    }
}

private struct CarawinSubjectRow: View {
    let title: String
    let icon: String
    let percent: Int?
    let color: Color
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundStyle(color)
                Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(CarawinPalette.ink)
                Spacer()
                Text(percent.map { "\($0)%" } ?? "No data yet").font(.system(size: 11)).foregroundStyle(CarawinPalette.muted)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(CarawinPalette.border)
                    if let percent { Capsule().fill(color).frame(width: geometry.size.width * CGFloat(percent) / 100) }
                }
            }.frame(height: 5)
        }
    }
}

private struct CarawinStatsEmptyCard: View {
    let title: String
    let icon: String
    let tint: Color
    var value: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CarawinSectionTitle(title: title)
            Image(systemName: icon).font(.system(size: 23, weight: .semibold)).foregroundStyle(tint)
                .frame(width: 46, height: 46).background(tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 14)).frame(maxWidth: .infinity)
            Text(value ?? "Personal data will appear here when available.").font(.system(size: 11, weight: .medium))
                .foregroundStyle(value == nil ? CarawinPalette.muted : CarawinPalette.ink).multilineTextAlignment(.center).frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity, minHeight: 118).carawinCard()
    }
}

private struct CarawinPalette {
    static let navy = Color(carawinHex: "002147")
    static let blue = Color(carawinHex: "14589C")
    static let red = Color(carawinHex: "DC143C")
    static let gold = Color(carawinHex: "FFC20E")
    static let green = Color(carawinHex: "10B981")
    static let ink = Color(carawinHex: "002147")
    static let muted = Color(carawinHex: "64748B")
    static let border = Color(carawinHex: "DCE7F5")
    static let paleBlue = Color(carawinHex: "E7F0FF")
    static let paleGold = Color(carawinHex: "FFF6D8")
}

private struct CarawinPageBackground: View {
    var body: some View { Color(carawinHex: "F4F6FB") }
}

private extension View {
    func carawinCard() -> some View {
        padding(14)
            .background(LinearGradient(colors: [.white, Color(carawinHex: "F5F8FF")], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 19))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(CarawinPalette.border, lineWidth: 1))
            .shadow(color: CarawinPalette.navy.opacity(0.07), radius: 8, y: 3)
    }
}

private extension Color {
    init(carawinHex hex: String) {
        let value = UInt64(hex, radix: 16) ?? 0
        self.init(.sRGB, red: Double((value >> 16) & 0xFF) / 255,
                  green: Double((value >> 8) & 0xFF) / 255,
                  blue: Double(value & 0xFF) / 255, opacity: 1)
    }
}

#Preview {
    CarawinAssignedScreens()
}
