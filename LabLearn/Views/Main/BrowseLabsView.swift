import SwiftUI

public struct BrowseLabsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = LabsViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Browse Labs",
                subtitle: "Explore Interactive Labs across PCM",
                height: 120
            )
            
            VStack(spacing: 14) {
                // Search Field
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.textMuted)
                    
                    TextField("Search labs, topics or experiments", text: $viewModel.searchText)
                        .font(.system(size: 14))
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.borderLight, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Subject Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Subject.allCases) { subject in
                            SubjectChip(
                                subject: subject,
                                isSelected: viewModel.selectedSubject == subject
                            ) {
                                viewModel.selectedSubject = subject
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Lab Cards List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(viewModel.filteredLabs) { lab in
                            BrowseLabCard(lab: lab) {
                                appState.selectedTab = .simulation
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 90)
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct BrowseLabCard: View {
    public let lab: LabExperiment
    public let onLaunch: () -> Void
    
    public var body: some View {
        CardContainer(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(badgeColor.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: lab.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(badgeColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lab.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textDark)
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text(lab.subject.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(badgeColor)
                        Text("•")
                            .foregroundColor(Theme.textMuted)
                        Text(lab.grade)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                
                Spacer()
                
                Button(action: onLaunch) {
                    HStack(spacing: 4) {
                        Text("Launch")
                            .font(.system(size: 12, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Theme.redButtonGradient)
                    .clipShape(Capsule())
                }
            }
        }
    }
    
    private var badgeColor: Color {
        switch lab.subject {
        case .physics: return Theme.primaryBlue
        case .chemistry: return Theme.primaryRed
        case .biology: return Theme.accentGreen
        default: return Theme.accentYellow
        }
    }
}
