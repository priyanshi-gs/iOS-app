import SwiftUI

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = HomeViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header with greeting & profile badge
            WaveHeader(
                title: "Welcome, \(viewModel.studentName)",
                subtitle: viewModel.gradeTitle,
                height: 120
            ) {
                Button(action: {
                    appState.selectedTab = .profile
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 36, height: 36)
                        Text("ST")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Active Experiment In Progress Card
                    ActiveExperimentCard(
                        experiment: viewModel.activeExperiment,
                        onContinue: {
                            appState.selectedTab = .simulation
                        }
                    )
                    .padding(.top, 14)
                    
                    // Quick Stats Row: Available Labs, Badges, Lab Hours
                    HStack(spacing: 12) {
                        StatCounterCard(
                            value: "\(viewModel.availableLabsCount)",
                            label: "Available Labs",
                            icon: "flask",
                            color: Theme.primaryBlue
                        )
                        
                        StatCounterCard(
                            value: "\(viewModel.badgesCount)",
                            label: "Badges Won",
                            icon: "trophy.fill",
                            color: Theme.accentYellow
                        ) {
                            appState.selectedTab = .stats
                        }
                        
                        StatCounterCard(
                            value: "\(String(format: "%.1f", viewModel.labHours))h",
                            label: "Lab Hours",
                            icon: "clock.fill",
                            color: Theme.accentGreen
                        )
                    }
                    
                    // Explore by Subject
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore by Subject")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        HStack(spacing: 12) {
                            SubjectCard(title: "Physics", icon: "atom", color: Theme.primaryBlue) {
                                appState.selectedTab = .labs
                            }
                            SubjectCard(title: "Chemistry", icon: "flask.fill", color: Theme.primaryRed) {
                                appState.selectedTab = .labs
                            }
                            SubjectCard(title: "Biology", icon: "leaf.fill", color: Theme.accentGreen) {
                                appState.selectedTab = .labs
                            }
                        }
                    }
                    
                    // Recent Visited Labs
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Visited Labs")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            Spacer()
                            Button("View All >") {
                                appState.selectedTab = .labs
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.primaryRed)
                        }
                        
                        VStack(spacing: 10) {
                            ForEach(viewModel.recentLabs) { lab in
                                RecentLabRow(lab: lab) {
                                    appState.selectedTab = .simulation
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
    }
}

public struct ActiveExperimentCard: View {
    public let experiment: LabExperiment
    public let onContinue: () -> Void
    
    public var body: some View {
        CardContainer(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Theme.primaryRed.opacity(0.12))
                            .frame(width: 38, height: 38)
                        Image(systemName: experiment.iconName)
                            .font(.system(size: 18))
                            .foregroundColor(Theme.primaryRed)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(experiment.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        Text("\(experiment.subject.rawValue) • \(experiment.status.rawValue)")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.primaryRed)
                    }
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        HStack(spacing: 4) {
                            Text("Continue")
                                .font(.system(size: 12, weight: .bold))
                            Image(systemName: "play.fill")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                    }
                }
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: experiment.progress, total: 1.0)
                        .tint(Theme.primaryRed)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
            }
        }
    }
}

public struct StatCounterCard: View {
    public let value: String
    public let label: String
    public let icon: String
    public let color: Color
    public var onTap: (() -> Void)? = nil
    
    public var body: some View {
        Button(action: { onTap?() }) {
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(color)
                    Text(value)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textDark)
                }
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Theme.textMuted)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct SubjectCard: View {
    public let title: String
    public let icon: String
    public let color: Color
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textDark)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
        }
    }
}

public struct RecentLabRow: View {
    public let lab: LabExperiment
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(lab.subject == .chemistry ? Theme.primaryRed.opacity(0.12) : Theme.primaryBlue.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: lab.iconName)
                        .font(.system(size: 18))
                        .foregroundColor(lab.subject == .chemistry ? Theme.primaryRed : Theme.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(lab.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("\(lab.subject.rawValue) • \(lab.status.rawValue)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                Image(systemName: lab.status == .completed ? "checkmark.circle.fill" : "play.circle.fill")
                    .foregroundColor(lab.status == .completed ? Theme.accentGreen : Theme.primaryRed)
                    .font(.system(size: 20))
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
