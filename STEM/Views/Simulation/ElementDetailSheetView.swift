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

        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 14) {
                // MARK: - Drag Handle
                Capsule()
                    .fill(Color(hex: "64748B").opacity(0.35))
                    .frame(width: 38, height: 4.5)
                    .padding(.top, 4)

                // MARK: - Element Hero Header
                HStack(alignment: .center, spacing: 14) {
                    // Element Tile Box (Left)
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(hex: "FFF4E6"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color(hex: "FF8A3D"), lineWidth: 1.5)
                            )
                            .shadow(color: Color(hex: "FF8A3D").opacity(0.18), radius: 6, x: 0, y: 2)

                        VStack(alignment: .leading, spacing: 0) {
                            Text(element.atomicNumberFormatted)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "0F172A"))
                                .padding(.top, 6)
                                .padding(.leading, 8)

                            Spacer()

                            HStack {
                                Spacer()
                                Text(element.symbol)
                                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                                    .foregroundColor(Color(hex: "0F172A"))
                                Spacer()
                            }

                            Spacer().frame(height: 8)
                        }
                    }
                    .frame(width: 62, height: 64)

                    // Title & Category Badge (Center)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(element.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)

                        Text(element.category.rawValue.uppercased())
                            .font(.system(size: 10.5, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "EA580C"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FFF5EB"))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(Color(hex: "FF8A3D"), lineWidth: 1.5)
                            )
                    }

                    Spacer()

                    // Close Button (Right)
                    if let onClose = onClose {
                        Button(action: onClose) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "F1F4F9"))
                                    .frame(width: 36, height: 36)

                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "0F172A"))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 2)

                // MARK: - Tab Bar Pills (4 Segmented Tabs)
                HStack(spacing: 8) {
                    ForEach(DetailTab.allCases) { tab in
                        let isSelected = viewModel.selectedDetailTab == tab
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                viewModel.selectedDetailTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(.system(size: 12.5, weight: isSelected ? .bold : .medium, design: .rounded))
                                .foregroundColor(isSelected ? .white : Color(hex: "1E293B"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? Theme.oxfordBlue : Color(hex: "F1F4F9"))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 2)

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
                    hinglishTrickCard(mnemonic: mnemonic)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: -2)
        )
    }

    // MARK: - Overview Tab (Bohr 2D Model + Key Specs Card)
    @ViewBuilder
    private func overviewTabContent(element: Element) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Left Column: Bohr 2D Orbital Model
            BohrModelView(
                symbol: element.symbol,
                atomicNumber: element.id,
                electronConfig: element.electronConfig
            )

            // Right Column: Elevated White Specifications Card
            VStack(alignment: .leading, spacing: 0) {
                specRow(icon: "atom", label: "Atomic Number", value: element.atomicNumberFormatted)
                specDivider
                specRow(icon: "flask", label: "Atomic Mass", value: element.atomicMassFormatted)
                specDivider
                if let en = element.electronegativity {
                    specRow(icon: "shield", label: "Electronegativity", value: String(format: "%.2f", en))
                    specDivider
                }
                if let radius = element.atomicRadius {
                    specRow(icon: "clock", label: "Atomic Radius", value: "\(radius) pm")
                    specDivider
                }
                if let ie = element.ionizationEnergy {
                    specRow(icon: "bolt.circle", label: "Ionization Energy", value: String(format: "%.1f kJ/mol", ie))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "E2E8F0").opacity(0.85), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
        .padding(.vertical, 4)
    }

    // Specification Row with no cut text and flexible layout
    @ViewBuilder
    private func specRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "334155"))
                .frame(width: 16, height: 16, alignment: .center)

            Text(label)
                .font(.system(size: 11.5, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: "1E293B"))
                .lineLimit(1)
                .layoutPriority(0)

            Spacer(minLength: 4)

            Text(value)
                .font(.system(size: 12.5, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "0F172A"))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .layoutPriority(1)
        }
        .padding(.vertical, 7)
    }

    private var specDivider: some View {
        Rectangle()
            .fill(Color(hex: "F1F5F9"))
            .frame(height: 1)
    }

    // MARK: - Hinglish Trick Card
    @ViewBuilder
    private func hinglishTrickCard(mnemonic: String) -> some View {
        let (titleLine, subtitleLine) = parseMnemonic(mnemonic)

        VStack(alignment: .leading, spacing: 10) {
            // Header Row: 💡 Hinglish Trick ... ▶ Listen
            HStack(alignment: .center) {
                HStack(spacing: 7) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "F59E0B"))

                    Text("Hinglish Trick")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "78350F"))
                }

                Spacer()

                // Listen Audio Button
                Button(action: {
                    viewModel.playAudioMnemonic()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.isAudioPlaying ? "waveform" : "play.fill")
                            .font(.system(size: 10, weight: .bold))

                        Text(viewModel.isAudioPlaying ? "Playing" : "Listen")
                            .font(.system(size: 12.5, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Theme.oxfordBlue)
                    .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Body Lines: Bold Catchphrase & Explanation
            VStack(alignment: .leading, spacing: 4) {
                Text(titleLine)
                    .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1E293B"))
                    .fixedSize(horizontal: false, vertical: true)

                if !subtitleLine.isEmpty {
                    Text(subtitleLine)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "334155"))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: "FEF7DC"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "FDE047"), lineWidth: 1.5)
                )
        )
    }

    // Parses mnemonic string into quote title and subtitle explanation
    private func parseMnemonic(_ raw: String) -> (String, String) {
        if raw.contains(" — ") {
            let split = raw.components(separatedBy: " — ")
            let title = split[0].replacingOccurrences(of: "\"", with: "“").trimmingCharacters(in: .whitespaces) + " —"
            let subtitle = split.count > 1 ? split[1].replacingOccurrences(of: "'", with: "‘").trimmingCharacters(in: .whitespaces) : ""
            return (title, subtitle)
        } else if raw.contains(" - ") {
            let split = raw.components(separatedBy: " - ")
            let title = split[0].replacingOccurrences(of: "\"", with: "“").trimmingCharacters(in: .whitespaces) + " —"
            let subtitle = split.count > 1 ? split[1].trimmingCharacters(in: .whitespaces) : ""
            return (title, subtitle)
        }
        return (raw, "")
    }

    // MARK: - Properties Tab
    @ViewBuilder
    private func propertiesTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(element.propertiesDescription.isEmpty ? element.overviewDescription : element.propertiesDescription)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(Color(hex: "334155"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                specBox(title: "Group", value: "\(element.group)")
                specBox(title: "Period", value: "\(element.period)")
                specBox(title: "Electrons", value: "\(element.id)")
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Configuration Tab
    @ViewBuilder
    private func configurationTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Electron Configuration")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)

            Text(element.electronConfigurationNotation)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.crimson)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "F8FAFC"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(hex: "E2E8F0"), lineWidth: 1)
                )

            HStack(spacing: 8) {
                Text("Shells:")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "64748B"))

                ForEach(0..<element.electronConfig.count, id: \.self) { idx in
                    Text("\(element.electronConfig[idx])")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.oxfordBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "EFF6FF"))
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }

    // MARK: - Uses Tab
    @ViewBuilder
    private func usesTabContent(element: Element) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(element.commonUses, id: \.self) { use in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "10B981"))
                        .padding(.top, 2)

                    Text(use)
                        .font(.system(size: 12.5, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "1E293B"))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }

    // Helper for property metric tile
    @ViewBuilder
    private func specBox(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: "64748B"))
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(hex: "F8FAFC"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(hex: "E2E8F0"), lineWidth: 1)
        )
    }
}
