import SwiftUI

public struct LearningStatisticsView: View {
    @StateObject private var viewModel = StatsAndBadgesViewModel()
    @State private var showingBadgesView: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Learning Statistics",
                subtitle: "Track your learning journey & progress",
                height: 120
            ) {
                Button(action: { showingBadgesView = true }) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.accentYellow)
                        .frame(width: 34, height: 34)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Steady Progress Hero Banner
                    CardContainer(padding: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Steady Progress!")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Text("You are on track to complete Class 11 PCM experiments.")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "atom")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.redButtonGradient)
                        }
                    }
                    .padding(.top, 10)
                    
                    // 4 Key Metrics Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        MetricBlock(
                            title: "Labs Completed",
                            value: "\(viewModel.stats.labsCompleted)",
                            icon: "checkmark.seal.fill",
                            color: Theme.accentGreen
                        )
                        
                        MetricBlock(
                            title: "Total Time",
                            value: "\(String(format: "%.1f", viewModel.stats.totalLabHours))h",
                            icon: "clock.fill",
                            color: Theme.primaryBlue
                        )
                        
                        MetricBlock(
                            title: "Streak",
                            value: "\(viewModel.stats.currentStreakDays) Days",
                            icon: "flame.fill",
                            color: Theme.primaryRed
                        )
                        
                        MetricBlock(
                            title: "Avg Score",
                            value: "\(viewModel.stats.avgAssessmentScore)%",
                            icon: "chart.line.uptrend.xyaxis",
                            color: Theme.accentYellow
                        )
                    }
                    
                    // Subject-wise Completion
                    CardContainer(padding: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Subject-wise Completion")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            
                            SubjectProgressBar(title: "Physics", progress: viewModel.stats.physicsProgress, color: Theme.primaryBlue)
                            SubjectProgressBar(title: "Chemistry", progress: viewModel.stats.chemistryProgress, color: Theme.primaryRed)
                            SubjectProgressBar(title: "Biology", progress: viewModel.stats.biologyProgress, color: Theme.accentGreen)
                        }
                    }
                    
                    // Monthly Activity Bar Chart
                    CardContainer(padding: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Monthly Activity")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            
                            HStack(alignment: .bottom, spacing: 14) {
                                ForEach(viewModel.stats.monthlyBars) { bar in
                                    VStack(spacing: 6) {
                                        Text("\(String(format: "%.0f", bar.hours))h")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(Theme.textMuted)
                                        
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(bar.month == "Oct" ? Theme.primaryRed : Theme.primaryBlue.opacity(0.7))
                                            .frame(height: CGFloat(bar.hours * 4.5))
                                        
                                        Text(bar.month)
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(Theme.textDark)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(height: 120)
                            .padding(.top, 8)
                        }
                    }
                    
                    // Learning Streak & Performance
                    HStack(spacing: 12) {
                        CardContainer(padding: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Learning Streak")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                
                                HStack(spacing: 6) {
                                    ForEach(0..<7, id: \.self) { day in
                                        Circle()
                                            .fill(Theme.primaryRed)
                                            .frame(width: 14, height: 14)
                                    }
                                }
                                
                                Text("7 Days Active")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Theme.primaryRed)
                            }
                        }
                        
                        CardContainer(padding: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Assessment Score")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                
                                HStack {
                                    Text("\(viewModel.stats.avgAssessmentScore)%")
                                        .font(.system(size: 22, weight: .black))
                                        .foregroundColor(Theme.accentGreen)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Theme.accentYellow)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .sheet(isPresented: $showingBadgesView) {
            MyBadgesView()
        }
    }
}

public struct MetricBlock: View {
    public let title: String
    public let value: String
    public let icon: String
    public let color: Color
    
    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textDark)
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.borderLight, lineWidth: 1)
        )
    }
}

public struct SubjectProgressBar: View {
    public let title: String
    public let progress: Double
    public let color: Color
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.textDark)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            }
            
            ProgressView(value: progress, total: 1.0)
                .tint(color)
        }
    }
}
