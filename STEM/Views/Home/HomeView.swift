import SwiftUI

@MainActor
public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    public var onLaunchSimulation: ((Lab) -> Void)?
    public var onNavigateToBrowse: ((Subject?) -> Void)?
    public var onOpenProfile: (() -> Void)?
    public var onOpenNotifications: (() -> Void)?

    public init(
        viewModel: HomeViewModel? = nil,
        onLaunchSimulation: ((Lab) -> Void)? = nil,
        onNavigateToBrowse: ((Subject?) -> Void)? = nil,
        onOpenProfile: (() -> Void)? = nil,
        onOpenNotifications: (() -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel ?? HomeViewModel())
        self.onLaunchSimulation = onLaunchSimulation
        self.onNavigateToBrowse = onNavigateToBrowse
        self.onOpenProfile = onOpenProfile
        self.onOpenNotifications = onOpenNotifications
    }

    // Filtered labs based on chosen subject
    private var displayedLabs: [Lab] {
        if let subject = viewModel.selectedSubject {
            let matched = viewModel.recentLabs.filter { $0.subject == subject }
            return matched
        }
        return viewModel.recentLabs
    }


    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            DashboardWaveHeader(
                icon: "house",
                title: "Home",
                subtitlePrefix: "Welcome, ",
                subtitleHighlight: viewModel.userProfile.name,
                onNotificationTap: {
                    onOpenNotifications?()
                },
                onProfileTap: {
                    onOpenProfile?()
                }
            )

            // MARK: - Dashboard content

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Continue Learning Card
                    if let continueLab = viewModel.continueLearningLab {
                        ContinueLearningCardView(lab: continueLab) {
                            viewModel.updateActiveLab(continueLab)
                            onLaunchSimulation?(continueLab)
                        }
                        .padding(.top, 14)
                    }
                    // Stats Cards Row (100% Dynamic & Live from Backend)
                    HStack(spacing: 10) {
                        // Available Labs (Soft Pastel Sky Blue - derived from Brand Navy / Cyan)
                        Button(action: {
                            onNavigateToBrowse?(nil)
                        }) {
                            StatCard(
                                icon: "flask.fill",
                                iconColor: Color(hex: "0284C7"),
                                iconBgColor: Color(hex: "E0F2FE"),
                                cardBgColor: Color(hex: "F0F7FF"),
                                cardBorderColor: Color(hex: "D9EAFD"),
                                value: "\(viewModel.userProfile.availableLabsCount)",
                                label: "Available Labs",
                                sublabel: viewModel.userProfile.accessTierLabel
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Badges Won (Soft Pastel Rose Blush - derived from Brand Crimson)
                        Button(action: {
                            onOpenProfile?()
                        }) {
                            StatCard(
                                icon: "medal.fill",
                                iconColor: Theme.crimson,
                                iconBgColor: Color(hex: "FFE4E6"),
                                cardBgColor: Color(hex: "FFF1F2"),
                                cardBorderColor: Color(hex: "FFE2E5"),
                                value: "\(viewModel.userProfile.badgesWonCount)",
                                label: "Badges Won",
                                sublabel: nil
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Lab Hours (Soft Pastel Warm Gold/Amber - derived from Brand Yellow)
                        Button(action: {
                            onOpenProfile?()
                        }) {
                            StatCard(
                                icon: "clock.fill",
                                iconColor: Color(hex: "D97706"),
                                iconBgColor: Color(hex: "FEF3C7"),
                                cardBgColor: Color(hex: "FFFBEB"),
                                cardBorderColor: Color(hex: "FEF3C7"),
                                value: "\(String(format: "%.1f", viewModel.userProfile.labHoursTotal))h",
                                label: "Lab Hours",
                                sublabel: nil
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    // Explore by Subject Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore by Subject")
                            .font(Theme.heading(17))
                            .foregroundColor(Theme.textPrimary)

                        HStack(spacing: 12) {
                            subjectButton(for: .physics)
                            subjectButton(for: .chemistry)
                            subjectButton(for: .biology)
                        }
                    }

                    // Experiments List Section (Dynamically filtered by Subject)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(viewModel.selectedSubject != nil ? "\(viewModel.selectedSubject!.rawValue) Experiments" : "Recent Visited Labs")
                                .font(Theme.heading(17))
                                .foregroundColor(Theme.textPrimary)

                            Spacer()

                            Button(action: {
                                onNavigateToBrowse?(viewModel.selectedSubject)
                            }) {
                                HStack(spacing: 4) {
                                    Text(viewModel.selectedSubject != nil ? "All \(viewModel.selectedSubject!.rawValue)" : "View All")
                                        .font(Theme.caption(12))
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(Theme.crimson)
                            }
                        }

                        VStack(spacing: 4) {
                            if viewModel.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .tint(Theme.oxfordBlue)
                                        .padding(.vertical, 20)
                                    Spacer()
                                }
                            } else if displayedLabs.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: viewModel.selectedSubject?.systemIcon ?? "flask.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(Theme.textSecondary.opacity(0.6))
                                        .padding(.top, 12)
                                    Text("No \(viewModel.selectedSubject?.rawValue ?? "") experiments found")
                                        .font(Theme.body(13))
                                        .foregroundColor(Theme.textSecondary)
                                    Button(action: {
                                        onNavigateToBrowse?(viewModel.selectedSubject)
                                    }) {
                                        Text("Explore in Catalog →")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Theme.primaryBlue)
                                    }
                                    .padding(.bottom, 12)
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                ForEach(displayedLabs.prefix(5)) { lab in
                                    RecentLabRowView(lab: lab) {
                                        viewModel.updateActiveLab(lab)
                                        onLaunchSimulation?(lab)
                                    }
                                    if lab.id != displayedLabs.prefix(5).last?.id {
                                        Divider()
                                            .background(Color(hex: "F1F5F9"))
                                    }
                                }
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                        )
                    }

                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 18)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .onAppear {
            viewModel.loadData()
        }
    }

    // Helper for Subject pill buttons
    @ViewBuilder
    private func subjectButton(for subject: Subject) -> some View {
        let isSelected = viewModel.selectedSubject == subject

        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                viewModel.selectSubject(subject)
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: subject.systemIcon)
                    .font(.system(size: 20, weight: .semibold))

                Text(subject.rawValue)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? Theme.oxfordBlue : Color(hex: "F1F5F9"))
            .foregroundColor(isSelected ? .white : Theme.oxfordBlue)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: isSelected ? Theme.oxfordBlue.opacity(0.2) : Color.clear, radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview("Home Screen") {
    HomeView()
        .preferredColorScheme(.light)
}
