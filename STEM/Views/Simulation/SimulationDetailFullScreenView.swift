import SwiftUI

public struct SimulationDetailFullScreenView: View {
    @ObservedObject public var viewModel: SimulationViewModel
    public var onBack: (() -> Void)?

    public init(viewModel: SimulationViewModel, onBack: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onBack = onBack
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Signature Waveform Header
            WaveHeader(
                title: "Simulation",
                showBackButton: true,
                onBack: onBack,
                trailing: {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Image(systemName: "viewfinder")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                }
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Compact PeriodicLab Bar
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(LinearGradient(colors: [Color(hex: "A855F7"), Theme.crimson], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 36, height: 36)
                            Image(systemName: "atom")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("PeriodicLab")
                                .font(Theme.subheading(14))
                                .foregroundColor(Theme.oxfordBlue)
                            Text("Interactive IUPAC Periodic Table & Mnemonics")
                                .font(Theme.caption(10))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 14)

                    // Detail Sheet Card
                    ElementDetailSheetView(viewModel: viewModel) {
                        onBack?()
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 40)
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

