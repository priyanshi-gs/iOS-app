import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    public var onLaunchSimulation: ((Lab) -> Void)?
    public var onNavigateToBrowse: (() -> Void)?

    public init(
        viewModel: HomeViewModel = HomeViewModel(),
        onLaunchSimulation: ((Lab) -> Void)? = nil,
        onNavigateToBrowse: (() -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onLaunchSimulation = onLaunchSimulation
        self.onNavigateToBrowse = onNavigateToBrowse
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // MARK: - Dark Oxford Blue Curved Header
                ZStack(alignment: .topTrailing) {
                    // Header Background
                    Theme.oxfordBlue
                        .frame(height: 180)
                        .clipShape(
                            CurvedHeaderShape()
                        )

                    // Brand Crimson & Yellow Arc Graphics
                    DecorativeArcView()
                        .offset(x: -10, y: 10)

                    // Header Content
                    VStack(alignment: .leading, spacing: 14) {
                        // Navigation Bar Row
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Home")
                                    .font(Theme.heading(20))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            // Right Action Icons
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(systemName: "bell")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.white.opacity(0.12))
                                            .clipShape(Circle())

                                        Circle()
                                            .fill(Theme.crimson)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 2, y: 2)
                                    }
                                }

                                Button(action: {}) {
                                    Image(systemName: "person.circle")
                                        .font(.system(size: 26, weight: .light))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 20)

                        // Welcome Subtitle
                        HStack(spacing: 4) {
                            Text("Welcome,")
                                .font(Theme.subheading(15))
                                .foregroundColor(.white.opacity(0.85))

                            Text(viewModel.userProfile.name)
                                .font(Theme.subheading(15))
                                .foregroundColor(Theme.yellow)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                }
                .frame(height: 180)

                // MARK: - Main Content Area
                VStack(spacing: 20) {
                    // Continue Learning Card
                    if let continueLab = viewModel.continueLearningLab {
                        ContinueLearningCardView(lab: continueLab) {
                            onLaunchSimulation?(continueLab)
                        }
                        .padding(.top, -30)
                    }

                    // Stats Cards Row
                    HStack(spacing: 10) {
                        StatCard(
                            icon: "microscope",
                            iconColor: Theme.oxfordBlue,
                            value: "\(viewModel.userProfile.availableLabsCount)",
                            label: "Available Labs",
                            sublabel: "Free Access"
                        )

                        StatCard(
                            icon: "medal.fill",
                            iconColor: Theme.crimson,
                            value: "\(viewModel.userProfile.badgesWonCount)",
                            label: "Badges Won"
                        )

                        StatCard(
                            icon: "clock.fill",
                            iconColor: Color(hex: "D97706"),
                            value: "\(String(format: "%.1f", viewModel.userProfile.labHoursTotal))h",
                            label: "Lab Hours"
                        )
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

                    // Recent Visited Labs Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Visited Labs")
                                .font(Theme.heading(17))
                                .foregroundColor(Theme.textPrimary)

                            Spacer()

                            Button(action: {
                                onNavigateToBrowse?()
                            }) {
                                HStack(spacing: 4) {
                                    Text("View All")
                                        .font(Theme.caption(12))
                                        .fontWeight(.bold)

                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(Theme.crimson)
                            }
                        }

                        VStack(spacing: 4) {
                            ForEach(viewModel.recentLabs.prefix(5)) { lab in
                                RecentLabRowView(lab: lab) {
                                    onLaunchSimulation?(lab)
                                }

                                if lab.id != viewModel.recentLabs.prefix(5).last?.id {
                                    Divider()
                                        .background(Color(hex: "F1F5F9"))
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

                    // Bottom padding for tab bar
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 18)
            }
        }
        .background(Color(hex: "F8FAFD").ignoresSafeArea())
        .edgesIgnoringSafeArea(.top)
    }

    // Helper for Subject pill buttons
    @ViewBuilder
    private func subjectButton(for subject: Subject) -> some View {
        let isSelected = viewModel.selectedSubject == subject

        Button(action: {
            viewModel.selectSubject(subject)
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

// Custom curved bottom shape for the top header
public struct CurvedHeaderShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 24))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - 10),
            control: CGPoint(x: rect.width * 0.5, y: rect.height + 15)
        )
        path.closeSubpath()
        return path
    }
}

