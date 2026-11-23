import SwiftUI

public struct LabResultScreen: View {
    public let lab: Lab
    public var onBackToLabs: (() -> Void)?
    public var onViewAllBadges: (() -> Void)?

    @State private var hasEarnedBadge: Bool = true
    @State private var badgeName: String = "Lab Master"

    public init(
        lab: Lab,
        onBackToLabs: (() -> Void)? = nil,
        onViewAllBadges: (() -> Void)? = nil
    ) {
        self.lab = lab
        self.onBackToLabs = onBackToLabs
        self.onViewAllBadges = onViewAllBadges
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Wave Header
            WaveHeader(
                title: lab.code,
                showBackButton: true,
                onBack: onBackToLabs
            )

            // Step Tracker Bar (✓ Study -> ✓ Experiment -> ✓ Test -> ● Result)
            SimulationStepTracker(currentStep: .result)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 16)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Prominent Glowing Badge Earned Card
                    VStack(spacing: 16) {
                        // Glowing Gold Trophy / Badge Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FFD60A"), Color(hex: "FF9E0A")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 84, height: 84)
                                .shadow(color: Color(hex: "FFD60A").opacity(0.4), radius: 16, y: 4)
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "FFD60A").opacity(0.3), lineWidth: 6)
                                )

                            Image(systemName: "rosette")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color(hex: "00152D"))
                        }
                        .padding(.top, 12)

                        // Badge Earned Subtitle
                        Text("BADGE EARNED")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(Color(hex: "FFD60A"))
                            .tracking(2.0)

                        // Title
                        Text("Congratulations!")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)

                        // Description
                        Text("You have successfully completed all four stages of \(lab.title) and your digital badge has been officially issued.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "AEB7CF"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.horizontal, 16)

                        // Badge Pill Tag
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "FFD60A"))
                            Text("\(lab.code) Practical Certified")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(20)
                        .padding(.top, 4)

                        // Action Buttons
                        VStack(spacing: 10) {
                            Button(action: { onViewAllBadges?() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "trophy.fill")
                                        .font(.system(size: 13, weight: .bold))
                                    Text("View all badges")
                                        .font(.system(size: 13, weight: .heavy))
                                }
                                .foregroundColor(Color(hex: "00152D"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(Color(hex: "FFD60A"))
                                .cornerRadius(12)
                                .shadow(color: Color(hex: "FFD60A").opacity(0.3), radius: 8, y: 3)
                            }

                            Button(action: { onBackToLabs?() }) {
                                Text("Back to labs")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.white.opacity(0.07))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 14)
                        .padding(.horizontal, 8)
                    }
                    .padding(24)
                    .background(Color(hex: "00152D"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "FFD60A").opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color(hex: "00152D").opacity(0.4), radius: 20, y: 8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(hex: "F7F8FB").ignoresSafeArea())
    }


}
