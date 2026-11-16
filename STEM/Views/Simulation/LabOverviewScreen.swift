import SwiftUI

public struct LabOverviewScreen: View {
    public let lab: Lab
    public var onBack: (() -> Void)?
    public var onContinueLab: (() -> Void)?

    @State private var isShowingUpgradeSheet: Bool = false
    @State private var isShowingConnectSchoolSheet: Bool = false

    public init(lab: Lab, onBack: (() -> Void)? = nil, onContinueLab: (() -> Void)? = nil) {
        self.lab = lab
        self.onBack = onBack
        self.onContinueLab = onContinueLab
    }

    private let stages: [(number: Int, icon: String, title: String, description: String, isComplete: Bool)] = [
        (1, "book.closed.fill", "Study Material", "Core concepts, theory & pre-reading", false),
        (2, "flask.fill", "Virtual Experiment", "Hands-on interactive simulation", false),
        (3, "list.clipboard.fill", "Assessment", "MCQs & quiz to verify learning", false),
        (4, "rosette", "Badge", "Earn verified STEM achievement badge", false)
    ]

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            WaveHeader(
                title: lab.code,
                showBackButton: true,
                onBack: onBack
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Lab Hero Card
                    HStack(spacing: 16) {
                        // Thumbnail or Gradient Icon
                        ZStack {
                            if let urlStr = lab.thumbnailUrl, let url = URL(string: urlStr) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 76, height: 76)
                                            .clipped()
                                    default:
                                        heroFallbackThumbnail
                                    }
                                }
                                .frame(width: 76, height: 76)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            } else {
                                heroFallbackThumbnail
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text(lab.subject.rawValue.uppercased())
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundColor(Theme.crimson)

                                Text("•")
                                    .foregroundColor(Theme.textMuted)

                                Text(lab.duration)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Theme.textSecondary)
                            }

                            Text(lab.title)
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)
                                .lineLimit(nil)
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 6) {
                                Text(lab.status.rawValue)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color(hex: "EFF6FF"), in: Capsule())

                                if lab.isLocked {
                                    HStack(spacing: 4) {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 9, weight: .bold))
                                        Text("LOCKED")
                                            .font(.system(size: 9, weight: .black))
                                    }
                                    .foregroundColor(Theme.crimson)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Theme.crimson.opacity(0.12), in: Capsule())
                                }
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                    // Locked Banner Notice
                    if lab.isLocked {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.yellow)

                                Text("Subscription Required")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)

                                Spacer()

                                Text("PRO")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(Theme.yellow)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Theme.oxfordBlue, in: Capsule())
                            }

                            Text("This lab is locked on the Free Tier. Unlock full access to study materials, simulation, and STEM badge with an Individual Pro plan or an enrolled school code.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Theme.textSecondary)
                                .lineSpacing(2)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "FFFDF5"))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "FDE68A"), lineWidth: 1)
                        )
                    }

                    // Description
                    if !lab.description.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("About this Lab")
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)

                            Text(lab.description)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(Theme.textSecondary)
                                .lineSpacing(3)
                        }
                        .padding(.horizontal, 4)
                    }

                    // MARK: - The 4 Learning Stages (Sequential Stepped Pipeline)
                    learningJourneySection

                    // MARK: - Action Button Section
                    if lab.isLocked {
                        VStack(spacing: 10) {
                            Button(action: { isShowingUpgradeSheet = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Theme.yellow)
                                    Text("Unlock Lab — Upgrade to Pro")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Theme.oxfordBlue)
                                .clipShape(Capsule())
                                .shadow(color: Theme.oxfordBlue.opacity(0.25), radius: 8, y: 4)
                            }

                            Button(action: { isShowingConnectSchoolSheet = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "building.columns.fill")
                                        .font(.system(size: 12))
                                    Text("Have a school code? Connect School")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundColor(Theme.crimson)
                            }
                        }
                        .padding(.top, 10)
                    } else {
                        Button(action: { onContinueLab?() }) {
                            HStack(spacing: 8) {
                                Text(lab.status == .inProgress ? "Continue Lab" : "Start Lab")
                                    .font(.system(size: 16, weight: .bold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .heavy))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Theme.redButtonGradient)
                            .clipShape(Capsule())
                            .shadow(color: Theme.crimson.opacity(0.25), radius: 8, y: 4)
                        }
                        .padding(.top, 10)
                    }

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DataService.shared.startLabSession(labId: lab.id)
        }
        .onDisappear {
            DataService.shared.endLabSession()
        }
        .sheet(isPresented: $isShowingUpgradeSheet) {
            CheckoutPaymentView(onBack: { isShowingUpgradeSheet = false })
        }
        .sheet(isPresented: $isShowingConnectSchoolSheet) {
            ConnectSchoolScreen(
                onBack: { isShowingConnectSchoolSheet = false },
                onVerified: {
                    isShowingConnectSchoolSheet = false
                }
            )
        }
    }

    // MARK: - Learning Journey Stepped Pipeline
    private var learningJourneySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with sequence indicator
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text("Learning Journey")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)

                        Capsule()
                            .fill(Theme.yellow)
                            .frame(width: 30, height: 3)
                    }

                    Text("4 sequential steps to master this experiment")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.pull")
                        .font(.system(size: 10, weight: .bold))
                    Text("Steps 1 → 4")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                }
                .foregroundColor(Theme.oxfordBlue)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(Color(hex: "EFF6FF"), in: Capsule())
            }

            // Unified Timeline Stepper Card
            VStack(spacing: 0) {
                ForEach(Array(stages.enumerated()), id: \.offset) { index, stage in
                    timelineStepRow(
                        index: index,
                        stage: stage,
                        isLast: index == stages.count - 1
                    )
                }
            }
            .padding(16)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color(hex: "F1F5F9"), lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func timelineStepRow(
        index: Int,
        stage: (number: Int, icon: String, title: String, description: String, isComplete: Bool),
        isLast: Bool
    ) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Left Column: Step Node Circle + Continuous Connecting Spine
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(nodeBackgroundColor(for: index, isComplete: stage.isComplete))
                        .frame(width: 36, height: 36)

                    if stage.isComplete {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    } else if index == 0 && !lab.isLocked {
                        Image(systemName: stage.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    } else if lab.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                    } else {
                        Text("\(stage.number)")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                    }
                }
                .overlay(
                    Circle()
                        .stroke(
                            index == 0 && !lab.isLocked ? Theme.yellow : Color.clear,
                            lineWidth: 2
                        )
                )

                // Vertical Connector Line
                if !isLast {
                    Rectangle()
                        .fill(
                            stage.isComplete
                                ? Theme.oxfordBlue
                                : Color(hex: "E2E8F0")
                        )
                        .frame(width: 2)
                        .frame(minHeight: 32)
                        .padding(.vertical, 2)
                }
            }

            // Right Column: Step Info + Tag
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    Text("\(stage.number). \(stage.title)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.oxfordBlue)

                    Spacer()

                    // Status Pill
                    if lab.isLocked {
                        HStack(spacing: 3) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 8))
                            Text("Locked")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(Theme.textMuted)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color(hex: "F1F5F9"), in: Capsule())
                    } else if stage.isComplete {
                        HStack(spacing: 3) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .bold))
                            Text("Done")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(Theme.successGreen)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color(hex: "DCFCE7"), in: Capsule())
                    } else if index == 0 {
                        Text("START HERE")
                            .font(.system(size: 8, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Theme.crimson, in: Capsule())
                    } else {
                        Text("STEP \(stage.number)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color(hex: "F8FAFC"), in: Capsule())
                    }
                }

                Text(stage.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(2)
            }
            .padding(.bottom, isLast ? 0 : 14)
        }
    }

    private func nodeBackgroundColor(for index: Int, isComplete: Bool) -> Color {
        if isComplete {
            return Theme.oxfordBlue
        } else if index == 0 && !lab.isLocked {
            return Theme.oxfordBlue
        } else {
            return Color(hex: "F1F5F9")
        }
    }

    private var heroFallbackThumbnail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: lab.gradientStartHex), Color(hex: lab.gradientEndHex)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 76, height: 76)

            Image(systemName: lab.thumbnailSymbol)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
