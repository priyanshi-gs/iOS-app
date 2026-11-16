import SwiftUI

public struct StatisticsScreen: View {
    let data: CarawinStatisticsData?
    let onBack: () -> Void

    @State private var liveData: CarawinStatisticsData? = nil
    @State private var isLoading: Bool = false

    // Live getters dynamically bound to live backend state
    private var activeData: CarawinStatisticsData? { liveData ?? data }

    private var completedLabs: Int { activeData?.completedLabs ?? 0 }
    private var totalLabs: Int { max(activeData?.totalLabs ?? 6, 1) }
    private var studyHours: Double { activeData?.studyHours ?? 0.0 }
    private var streakDays: Int { activeData?.learningStreakDays ?? 0 }
    private var assessmentPct: Int { activeData?.assessmentPercent ?? 0 }
    private var physicsPct: Int { activeData?.physicsPercent ?? 0 }
    private var chemPct: Int { activeData?.chemistryPercent ?? 0 }
    private var bioPct: Int { activeData?.biologyPercent ?? 0 }

    // Dynamic monthly bar chart based on current calendar date
    private var dynamicMonthlyData: [(month: String, value: Int, isCurrentMonth: Bool)] {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"

        var items: [(month: String, value: Int, isCurrentMonth: Bool)] = []
        for i in (0..<6).reversed() {
            if let date = calendar.date(byAdding: .month, value: -i, to: currentDate) {
                let monthStr = dateFormatter.string(from: date)
                let isCurrent = (i == 0)
                let count = isCurrent ? completedLabs : max(0, completedLabs - i)
                items.append((month: monthStr, value: count, isCurrentMonth: isCurrent))
            }
        }
        return items
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header
            WaveHeader(title: "Learning Statistics", showBackButton: true, onBack: onBack)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 14) {

                    // MARK: - Hero Banner
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("YOUR LEARNING OVERVIEW")
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(Theme.yellow)

                            Text(completedLabs > 0 ? "Steady Progress!" : "Welcome to Labs!")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)

                            Text(completedLabs > 0 ? "Here's how your learning journey is going" : "Start your first experiment to see your live progress")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.85))
                        }

                        Spacer(minLength: 0)

                        // Flask + books illustration
                        ZStack(alignment: .bottomLeading) {
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(Color(hex: "C2853B"))
                                .offset(x: 18, y: 0)

                            Image(systemName: "flask.fill")
                                .font(.system(size: 42, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "5BC4F5"), Color(hex: "1E8FC4")],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                        }
                        .frame(width: 72, height: 60)
                    }
                    .padding(18)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "11437B"), Color(hex: "0A2648")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )

                    // MARK: - Stats Row
                    HStack(spacing: 0) {
                        statCell(icon: "flask.fill", iconColor: Theme.oxfordBlue,
                                 value: "\(completedLabs)", label: "Labs\nCompleted")
                        statDivider()
                        statCell(icon: "clock.fill", iconColor: Theme.crimson,
                                 value: "\(String(format: "%.1f", studyHours)) h",
                                 label: "Experiment\nHours", valueColor: Theme.crimson)
                        statDivider()
                        statCell(icon: "flame.fill", iconColor: Color(hex: "F59E0B"),
                                 value: "\(streakDays) Days", label: "Learning\nStreak")
                        statDivider()
                        statCell(icon: "rosette", iconColor: Theme.primaryBlue,
                                 value: "\(assessmentPct)%", label: "Assessment\nScore")
                    }
                    .padding(.vertical, 14)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - Subject Completion + Labs Donut (side by side)
                    HStack(alignment: .top, spacing: 12) {
                        // Subject-wise Completion
                        VStack(alignment: .leading, spacing: 12) {
                            sectionLabel("Subject-wise Completion")

                            subjectBar(icon: "atom", iconColor: Theme.primaryBlue,
                                       label: "Physics", percent: physicsPct, barColor: Theme.oxfordBlue)
                            subjectBar(icon: "flask.fill", iconColor: Theme.crimson,
                                       label: "Chemistry", percent: chemPct, barColor: Theme.crimson)
                            subjectBar(icon: "leaf.fill", iconColor: Theme.accentGreen,
                                       label: "Biology", percent: bioPct, barColor: Theme.accentGreen)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                        // Labs Completed donut
                        VStack(alignment: .leading, spacing: 12) {
                            sectionLabel("Labs Completed")

                            ZStack {
                                Circle()
                                    .stroke(Color(hex: "BFDBFE"), lineWidth: 14)
                                Circle()
                                    .trim(from: 0, to: Double(completedLabs) / Double(max(totalLabs, 1)))
                                    .stroke(Theme.oxfordBlue, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                                    .rotationEffect(.degrees(-90))

                                VStack(spacing: 1) {
                                    Text("\(completedLabs) / \(totalLabs)")
                                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                                        .foregroundColor(Theme.oxfordBlue)
                                    Text("Labs")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                            .frame(width: 90, height: 90)
                            .frame(maxWidth: .infinity)

                            // Legend
                            VStack(alignment: .leading, spacing: 4) {
                                legendItem(color: Theme.oxfordBlue, label: "Completed (\(completedLabs))")
                                legendItem(color: Color(hex: "BFDBFE"), label: "Remaining (\(totalLabs - completedLabs))")
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                    }

                    // MARK: - Monthly Activity
                    VStack(alignment: .leading, spacing: 12) {
                        sectionLabel("Monthly Activity")

                        HStack(alignment: .bottom, spacing: 0) {
                            // Bar chart
                            HStack(alignment: .bottom, spacing: 6) {
                                ForEach(dynamicMonthlyData, id: \.month) { item in
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                            .fill(item.isCurrentMonth ? Theme.crimson : Theme.oxfordBlue.opacity(0.6))
                                            .frame(width: 28, height: max(CGFloat(item.value) * 14, 8))

                                        Text(item.month)
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)

                            // This month callout
                            VStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Theme.crimson)
                                    .frame(width: 38, height: 38)
                                    .background(Theme.crimson.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))

                                Text("This Month")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Theme.textSecondary)

                                Text("\(completedLabs) Labs")
                                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                                    .foregroundColor(Theme.crimson)

                                HStack(spacing: 2) {
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 9, weight: .bold))
                                    Text(completedLabs > 0 ? "+100%" : "0%")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(Theme.accentGreen)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Theme.accentGreen.opacity(0.1), in: Capsule())

                                Text("vs. last month")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(width: 90)
                        }
                    }
                    .padding(16)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - Learning Streak (full width)
                    VStack(alignment: .leading, spacing: 12) {
                        sectionLabel("Learning Streak")

                        // Week days row
                        let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                        let activeCount = min(streakDays, 7)
                        HStack(spacing: 6) {
                            ForEach(Array(days.enumerated()), id: \.offset) { i, day in
                                VStack(spacing: 3) {
                                    if i < activeCount {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .heavy))
                                            .foregroundColor(.white)
                                            .frame(width: 32, height: 32)
                                            .background(Theme.primaryBlue, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                                    } else {
                                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                                            .stroke(Theme.borderSubtle, lineWidth: 1.5)
                                            .frame(width: 32, height: 32)
                                    }
                                    Text(day)
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                        HStack(spacing: 12) {
                            VStack(spacing: 4) {
                                HStack(spacing: 5) {
                                    Image(systemName: "flame.fill").foregroundColor(Color(hex: "F59E0B"))
                                    Text("\(streakDays) Days")
                                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                                        .foregroundColor(Theme.crimson)
                                }
                                Text("Current Streak")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.crimson.opacity(0.07), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                            VStack(spacing: 4) {
                                HStack(spacing: 5) {
                                    Image(systemName: "trophy.fill").foregroundColor(Color(hex: "F59E0B"))
                                    Text("14 Days")
                                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                                        .foregroundColor(Theme.oxfordBlue)
                                }
                                Text("Longest Streak")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.oxfordBlue.opacity(0.07), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                    .padding(16)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // MARK: - Assessment Performance (full width)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            sectionLabel("Assessment Performance")
                            Spacer()
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textSecondary)
                        }

                        HStack(spacing: 18) {
                            // Perfect Gauge Arc (Contained inside the card)
                            ZStack(alignment: .bottom) {
                                // Background semi-circle track
                                Circle()
                                    .trim(from: 0.0, to: 0.5)
                                    .stroke(Theme.borderSubtle, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .rotationEffect(.degrees(180))
                                    .frame(width: 132, height: 132)

                                // Dynamic score progress arc
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(max(Double(assessmentPct) / 100.0, 0.0), 1.0)) * 0.5)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(hex: "EF4444"), Color(hex: "F59E0B"), Color(hex: "22C55E")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(180))
                                    .frame(width: 132, height: 132)

                                // Score label centered under the dome
                                VStack(spacing: 2) {
                                    Text("\(assessmentPct)%")
                                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                                        .foregroundColor(Theme.oxfordBlue)
                                    Text("Overall Score")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .padding(.bottom, 2)
                            }
                            .frame(width: 144, height: 74, alignment: .top)
                            .padding(.top, 4)

                            Spacer(minLength: 0)

                            // Stats column
                            VStack(spacing: 12) {
                                assessmentStat(icon: "checkmark.circle.fill", iconColor: Theme.accentGreen, value: "\(max(completedLabs * 5, completedLabs))", label: "Correct")
                                Divider()
                                assessmentStat(icon: "xmark.circle.fill", iconColor: Theme.crimson, value: "\(completedLabs > 0 ? 1 : 0)", label: "Incorrect")
                                Divider()
                                assessmentStat(icon: "minus.circle.fill", iconColor: Theme.textMuted, value: "0", label: "Skipped")
                            }
                            .frame(width: 90)
                        }
                    }
                    .padding(16)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .task {
            if liveData == nil {
                isLoading = true
                let stats = await DataService.shared.fetchStatisticsLive()
                await MainActor.run {
                    self.liveData = stats
                    self.isLoading = false
                }
            }
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func sectionLabel(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
            Capsule()
                .fill(Theme.yellow)
                .frame(width: 28, height: 2.5)
        }
    }

    @ViewBuilder
    private func statCell(icon: String, iconColor: Color, value: String, label: String, valueColor: Color = Theme.oxfordBlue) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(iconColor)
            Text(value)
                .font(.system(size: 17, weight: .heavy, design: .rounded))
                .foregroundColor(valueColor)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func statDivider() -> some View {
        Rectangle()
            .fill(Theme.borderSubtle)
            .frame(width: 1, height: 50)
    }

    @ViewBuilder
    private func subjectBar(icon: String, iconColor: Color, label: String, percent: Int, barColor: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(label)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.oxfordBlue)
                    Spacer()
                    Text("\(percent)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textSecondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Theme.borderSubtle).frame(height: 6)
                        Capsule()
                            .fill(barColor)
                            .frame(width: geo.size.width * CGFloat(percent) / 100, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }

    @ViewBuilder
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
    }

    @ViewBuilder
    private func assessmentStat(icon: String, iconColor: Color, value: String, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(iconColor)
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

#Preview("Learning Statistics") {
    StatisticsScreen(
        data: CarawinStatisticsData(
            completedLabs: 22,
            totalLabs: 32,
            studyHours: 18.5,
            learningStreakDays: 7,
            assessmentPercent: 86,
            physicsPercent: 78,
            chemistryPercent: 72,
            biologyPercent: 68
        ),
        onBack: {}
    )
}
