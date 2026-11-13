import SwiftUI

public struct SimulationDetailFullScreenView: View {
    @ObservedObject public var viewModel: SimulationViewModel
    public var onBack: (() -> Void)?

    public init(viewModel: SimulationViewModel, onBack: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onBack = onBack
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                // MARK: - Dark Oxford Blue Header
                ZStack(alignment: .topTrailing) {
                    Theme.oxfordBlue
                        .frame(height: 140)
                        .clipShape(CurvedHeaderShape())

                    DecorativeArcView()
                        .offset(x: -15, y: 5)

                    HStack {
                        Button(action: {
                            onBack?()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Simulation")
                            .font(Theme.heading(18))
                            .foregroundColor(.white)

                        Spacer()

                        HStack(spacing: 10) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                            Image(systemName: "viewfinder")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 46)
                    .padding(.horizontal, 20)
                }
                .frame(height: 140)

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
                .padding(.top, -25)

                // Detail Sheet Card
                ElementDetailSheetView(viewModel: viewModel) {
                    onBack?()
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 40)
            }
        }
        .background(Color(hex: "F8FAFD").ignoresSafeArea())
        .edgesIgnoringSafeArea(.top)
    }
}

