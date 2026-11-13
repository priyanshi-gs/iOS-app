import SwiftUI

public struct ElementDetailSheetView: View {
    @ObservedObject public var viewModel: SimulationViewModel
    public var onClose: (() -> Void)?

    public init(viewModel: SimulationViewModel, onClose: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onClose = onClose
    }

    public var body: some View {
        let element = viewModel.selectedElement

        VStack(spacing: 14) {
            // MARK: - Drag Handle & Close Button
            HStack {
                // Drag handle indicator
                Capsule()
                    .fill(Color(hex: "CBD5E1"))
                    .frame(width: 36, height: 4)

                Spacer()

                if let onClose = onClose {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "94A3B8"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 4)

            // MARK: - Element Hero Header
            HStack(spacing: 16) {
                // Element Box
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(element.category.tileColor)
                        .frame(width: 58, height: 62)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Theme.oxfordBlue.opacity(0.15), lineWidth: 1)
                        )

                    VStack(alignment: .leading, spacing: 0) {
                        Text(element.atomicNumberFormatted)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                            .padding(.leading, 6)
                            .padding(.top, 4)

                        Spacer()

                        HStack {
                            Spacer()
                            Text(element.symbol)
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)
                            Spacer()
                        }

                        Spacer()
                    }
                }
                .frame(width: 58, height: 62)

                // Name and Category Pill
                VStack(alignment: .leading, spacing: 5) {
                    Text(element.name)
                        .font(Theme.heading(20))
                        .foregroundColor(Theme.oxfordBlue)

                    Text(element.category.rawValue.uppercased())
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "FEF3C7"))
                        .foregroundColor(Color(hex: "B45309"))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color(hex: "FCD34D"), lineWidth: 1)
                        )
                }

                Spacer()
            }

            // MARK: - Tabs (Overview, Properties, Configuration, Uses)
            HStack(spacing: 0) {
                ForEach(DetailTab.allCases) { tab in
                    let isSelected = viewModel.selectedDetailTab == tab
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedDetailTab = tab
                        }
                    }) {
                        VStack(spacing: 6) {
                            Text(tab.rawValue)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                                .foregroundColor(isSelected ? Theme.oxfordBlue : Theme.textMuted)

                            Rectangle()
                                .fill(isSelected ? Theme.oxfordBlue : Color.clear)
                                .frame(height: 2.5)
                                .cornerRadius(1.5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 4)

            // MARK: - Tab Content Area
            switch viewModel.selectedDetailTab {
            case .overview:
                overviewTabContent(element: element)
            case .properties:
                propertiesTabContent(element: element)
            case .configuration:
                configurationTabContent(element: element)
            case .uses:
                usesTabContent(element: element)
            }

            // MARK: - Hinglish Mnemonic Trick Card
            if let mnemonic = element.mnemonicTrick, viewModel.isMnemonicsOn {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "D97706"))

                            Text("Hinglish Trick")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "92400E"))
                        }

                        Text(mnemonic)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                            .italic()
                            .lineSpacing(2)
                    }

                    Spacer()

                    // Listen Button
                    Button(action: {
                        viewModel.playAudioMnemonic()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: viewModel.isAudioPlaying ? "waveform" : "play.fill")
                                .font(.system(size: 10, weight: .bold))

                            Text(viewModel.isAudioPlaying ? "Playing" : "Listen")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Theme.oxfordBlue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(hex: "FEFCE8"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Theme.yellow, lineWidth: 1.5)
                        )
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: -4)
        )
    }

    // MARK: - Overview Tab (Bohr Model + Key Specs)
    @ViewBuilder
    private func overviewTabContent(element: Element) -> some View {
        HStack(alignment: .center, spacing: 14) {
            // Left: Bohr Orbital Model
            BohrModelView(
                symbol: element.symbol,
                atomicNumber: element.id,
                electronConfig: element.electronConfig
            )

            // Right: Properties Column
            VStack(alignment: .leading, spacing: 9) {
                specRow(icon: "atom", label: "Atomic Number", value: element.atomicNumberFormatted)
                specRow(icon: "scalemass.fill", label: "Atomic Mass", value: element.atomicMassFormatted)
                if let en = element.electronegativity {
                    specRow(icon: "bolt.fill", label: "Electronegativity", value: String(format: "%.2f", en))
                }
                if let radius = element.atomicRadius {
                    specRow(icon: "circle.circle", label: "Atomic Radius", value: "\(radius) pm")
                }
                if let ie = element.ionizationEnergy {
                    specRow(icon: "flame.fill", label: "Ionization Energy", value: String(format: "%.1f kJ/mol", ie))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Properties Tab
    @ViewBuilder
    private func propertiesTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(element.propertiesDescription.isEmpty ? element.overviewDescription : element.propertiesDescription)
                .font(Theme.body(13))
                .foregroundColor(Theme.textPrimary)
                .lineSpacing(3)

            HStack(spacing: 12) {
                specBox(title: "Group", value: "\(element.group)")
                specBox(title: "Period", value: "\(element.period)")
                specBox(title: "Electrons", value: "\(element.id)")
            }
        }
        .padding(.vertical, 6)
    }

    // MARK: - Configuration Tab
    @ViewBuilder
    private func configurationTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Electron Configuration")
                .font(Theme.subheading(14))
                .foregroundColor(Theme.oxfordBlue)

            Text(element.electronConfigurationNotation)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.crimson)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(hex: "F8FAFC"))
                .cornerRadius(8)

            Text("Shell Occupancy: " + element.electronConfig.map { String($0) }.joined(separator: ", "))
                .font(Theme.caption(12))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }

    // MARK: - Uses Tab
    @ViewBuilder
    private func usesTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(element.commonUses, id: \.self) { use in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.successGreen)
                        .padding(.top, 2)

                    Text(use)
                        .font(Theme.body(12))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }

    // Helper for key spec item
    @ViewBuilder
    private func specRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(Theme.textMuted)
                .frame(width: 14)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
        }
    }

    // Helper for box tile
    @ViewBuilder
    private func specBox(title: String, value: String) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(hex: "F8FAFC"))
        .cornerRadius(8)
    }
}

