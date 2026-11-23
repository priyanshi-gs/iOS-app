// Combined Carawin data models and UI stubs
import SwiftUI

// MARK: - Data models (public)
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
    public init(name: String? = nil, email: String? = nil, schoolName: String? = nil, accountType: String? = nil, planName: String? = nil, availableLabs: Int? = nil, accountCreated: String? = nil, accountStatus: String? = nil, lastSynced: String? = nil, badgesEarned: Int? = nil) {
        self.name = name; self.email = email; self.schoolName = schoolName; self.accountType = accountType; self.planName = planName; self.availableLabs = availableLabs; self.accountCreated = accountCreated; self.accountStatus = accountStatus; self.lastSynced = lastSynced; self.badgesEarned = badgesEarned
    }
}

public struct CarawinStatisticsData {
    public var completedLabs: Int?
    public var totalLabs: Int?
    public var studyHours: Double?
    public var learningStreakDays: Int?
    public var longestStreakDays: Int?
    public var assessmentPercent: Int?
    public var physicsPercent: Int?
    public var chemistryPercent: Int?
    public var biologyPercent: Int?
    public var correctAnswers: Int?
    public var incorrectAnswers: Int?
    public var skippedAnswers: Int?

    public init(
        completedLabs: Int? = nil,
        totalLabs: Int? = nil,
        studyHours: Double? = nil,
        learningStreakDays: Int? = nil,
        longestStreakDays: Int? = nil,
        assessmentPercent: Int? = nil,
        physicsPercent: Int? = nil,
        chemistryPercent: Int? = nil,
        biologyPercent: Int? = nil,
        correctAnswers: Int? = nil,
        incorrectAnswers: Int? = nil,
        skippedAnswers: Int? = nil
    ) {
        self.completedLabs = completedLabs
        self.totalLabs = totalLabs
        self.studyHours = studyHours
        self.learningStreakDays = learningStreakDays
        self.longestStreakDays = longestStreakDays
        self.assessmentPercent = assessmentPercent
        self.physicsPercent = physicsPercent
        self.chemistryPercent = chemistryPercent
        self.biologyPercent = biologyPercent
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.skippedAnswers = skippedAnswers
    }
}

public struct CarawinBadgeData: Identifiable {
    public let id: UUID
    public let name: String
    public let category: String
    public let symbol: String
    public let isEarned: Bool
    public let issuedAt: String?
    public let imageUrl: String?
    public let viewerUrl: String?
    public let school: String?
    public let revoked: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        category: String,
        symbol: String = "rosette",
        isEarned: Bool = true,
        issuedAt: String? = nil,
        imageUrl: String? = nil,
        viewerUrl: String? = nil,
        school: String? = nil,
        revoked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.symbol = symbol
        self.isEarned = isEarned
        self.issuedAt = issuedAt
        self.imageUrl = imageUrl
        self.viewerUrl = viewerUrl
        self.school = school
        self.revoked = revoked
    }
}

// MARK: - Palette
public struct CarawinPalette {
    public static let navy = Color.blue
    public static let blue = Color.blue
    public static let red = Color.red
    public static let ink = Color.black
    public static let muted = Color.gray
    public static let paleBlue = Color.blue.opacity(0.2)
    public static let gold = Color.yellow
    public static let paleGold = Color.yellow.opacity(0.2)
    public static let green = Color.green
    public static let border = Color.gray.opacity(0.3)   
}

extension Color {
    // Simple hex initializer placeholder – returns gray for any value
    public init(carawinHex: String) {
        self = Color.gray
    }
}

// MARK: - Page wrapper
public struct CarawinPage<Content: View>: View {
    public var title: String
    public var back: (() -> Void)?
    @ViewBuilder public var content: () -> Content
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let back = back {
                    Button(action: back) { Image(systemName: "chevron.left") }
                }
                Text(title).font(.title2).foregroundColor(CarawinPalette.ink)
                Spacer()
            }
            content()
        }
        .padding()
        .background(CarawinPageBackground())
    }
}

public struct CarawinPageBackground: View {
    public var body: some View { Color.white }
}

// MARK: - Simple view modifiers
extension View {
    @inlinable public func carawinCard() -> some View {
        self.background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 2))
    }
}

// MARK: - Section title
public struct CarawinSectionTitle: View {
    public var title: String
    public var body: some View {
        Text(title).font(.headline).foregroundColor(CarawinPalette.ink)
    }
}

// MARK: - Data row
public struct CarawinDataRow: View {
    public var icon: String
    public var title: String
    public var value: String
    public var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(CarawinPalette.navy)
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).foregroundColor(CarawinPalette.muted)
                Text(value).font(.body).foregroundColor(CarawinPalette.ink)
            }
            Spacer()
        }
    }
}
//// MARK: - Profile screen implementation

// MARK: - Statistic tile
public struct CarawinStatTile: View {
    public var icon: String
    public var value: String
    public var label: String
    public var tint: Color
    public var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(tint)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(tint.opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - Subject row
public struct CarawinSubjectRow: View {
    public var title: String
    public var icon: String
    public var percent: Int?
    public var color: Color
    public var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            if let p = percent {
                Text("\(p)%")
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            } else {
                Text("—")
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Stats empty card (placeholder)
public struct CarawinStatsEmptyCard: View {
    public var title: String
    public var icon: String
    public var tint: Color
    public var value: String? = nil
    public var body: some View {
        VStack(spacing: 8) {
            if let v = value {
                Text(v)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(tint)
            }
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(tint.opacity(0.2))
        .cornerRadius(8)
    }
}

//public struct CarawinProfileScreen: View {
//}








// Alias for compatibility with older name




// MARK: - Profile Wave Header (simple placeholder)
public struct ProfileWaveHeader: View {
    public var name: String
    public var onBack: (() -> Void)?
    public var body: some View {
        ZStack(alignment: .bottom) {
            // Simple wave‑like background using a rounded rectangle with gradient
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(colors: [CarawinPalette.navy, CarawinPalette.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
                .overlay(
                    // Back button if provided
                    Group {
                        if let back = onBack {
                            Button(action: back) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Circle().fill(Color.black.opacity(0.3)))
                            }
                            .padding(.leading, 16)
                            .padding(.top, 44)
                        }
                    }, alignment: .topLeading
                )

            // Avatar placeholder – a circle overlapping the bottom edge
            Circle()
                .fill(CarawinPalette.paleGold)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(CarawinPalette.ink)
                )
                .offset(y: 50)
        }
        .padding(.bottom, 60) // push content below the overlapping avatar
        .overlay(
            Text(name)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.white)
                .padding(.top, 120),
            alignment: .top
        )
    }
}






// Alias for compatibility with older name



public struct CarawinConnectSchoolScreen: View {
    public var onBack: () -> Void
    public var onVerified: () -> Void
    public var onSubmit: (String) -> Bool
    @State private var code: String = ""
    public var body: some View {
        CarawinPage(title: "Connect School", back: onBack) {
            VStack {
                TextField("Enter code", text: $code).textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Submit") { _ = onSubmit(code); onVerified() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

public struct CarawinConnectedScreen: View {
    public var schoolName: String?
    public var onBack: () -> Void
    public var onDashboard: () -> Void
    public var body: some View {
        CarawinPage(title: "School Connected", back: onBack) {
            VStack {
                Text(schoolName ?? "School")
                Button("Go to Dashboard", action: onDashboard)
            }
        }
    }
}

public struct CarawinStatisticsScreen: View {
    public var data: CarawinStatisticsData?
    public var onBack: () -> Void
    public var body: some View {
        CarawinPage(title: "Statistics", back: onBack) {
            if let data = data {
                VStack(alignment: .leading) {
                    Text("Completed Labs: \(data.completedLabs.map { "\($0)" } ?? "—")")
                    Text("Study Hours: \(data.studyHours.map { "\($0)" } ?? "—")")
                }
            } else {
                Text("No statistics available")
            }
        }
    }
}

public struct CarawinBadgesScreen: View {
    public var data: [CarawinBadgeData]
    public var earnedCount: Int?
    public var onBack: () -> Void
    public var body: some View {
        CarawinPage(title: "My Badges", back: onBack) {
            if data.isEmpty {
                Text("No badges")
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(data) { badge in
                        VStack {
                            Image(systemName: badge.symbol)
                                .foregroundColor(badge.isEarned ? CarawinPalette.blue : CarawinPalette.muted)
                            Text(badge.name).font(.caption)
                        }
                        .padding()
                        .carawinCard()
                    }
                }
            }
        }
    }
}
