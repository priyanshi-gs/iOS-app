import SwiftUI

public struct MyBadgesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = StatsAndBadgesViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "My Badges",
                subtitle: "Unlock achievements as you master labs",
                showBackButton: true,
                onBack: { dismiss() },
                height: 120
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Badge Score Banner
                    CardContainer(padding: 16) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Theme.accentYellow.opacity(0.15))
                                    .frame(width: 50, height: 50)
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Theme.accentYellow)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(viewModel.earnedCount) / \(viewModel.totalCount) Badges")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Text("\(viewModel.totalCount - viewModel.earnedCount) badges remaining to unlock")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                            
                            Spacer()
                            
                            // Percentage Ring
                            ZStack {
                                Circle()
                                    .stroke(Theme.borderLight, lineWidth: 5)
                                    .frame(width: 46, height: 46)
                                Circle()
                                    .trim(from: 0, to: CGFloat(Double(viewModel.earnedCount) / Double(viewModel.totalCount)))
                                    .stroke(Theme.primaryRed, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 46, height: 46)
                                Text("\(viewModel.completionPercentage)%")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Subject.allCases) { subject in
                                SubjectChip(
                                    subject: subject,
                                    isSelected: viewModel.selectedBadgeSubject == subject
                                ) {
                                    viewModel.selectedBadgeSubject = subject
                                }
                            }
                        }
                    }
                    
                    // 3-Column Badges Grid (as in Figma)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.filteredBadges) { badge in
                            BadgeGridCard(badge: badge)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct BadgeGridCard: View {
    public let badge: Badge
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isEarned ? Theme.primaryRed.opacity(0.12) : Color.gray.opacity(0.1))
                    .frame(width: 52, height: 52)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: 22))
                    .foregroundColor(badge.isEarned ? Theme.primaryRed : Theme.textMuted.opacity(0.6))
            }
            
            Text(badge.title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(badge.isEarned ? Theme.textDark : Theme.textMuted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 28)
            
            if badge.isEarned {
                Text(badge.earnedDate ?? "Earned")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(Theme.accentGreen)
            } else {
                Text("Locked")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(Theme.textMuted)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(badge.isEarned ? Theme.borderLight : Color.clear, lineWidth: 1)
        )
        .opacity(badge.isEarned ? 1.0 : 0.6)
    }
}
