import SwiftUI

public struct SimulationView: View {
    @StateObject private var viewModel: SimulationViewModel
    public var onBack: (() -> Void)?

    public init(
        viewModel: SimulationViewModel = SimulationViewModel(),
        onBack: (() -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onBack = onBack
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // MARK: - Dark Oxford Blue Curved Nav Bar Header
                    ZStack(alignment: .topTrailing) {
                        Theme.oxfordBlue
                            .frame(height: 150)
                            .clipShape(CurvedHeaderShape())

                        // Brand Ring Graphic
                        DecorativeArcView()
                            .offset(x: -15, y: 5)

                        // Top Nav Bar
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
                                Button(action: {}) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }

                                Button(action: {}) {
                                    Image(systemName: "viewfinder")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 46)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 150)

                    // MARK: - PeriodicLab Floating Control Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            // Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "A855F7"), Theme.crimson],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 44, height: 44)

                                Image(systemName: "atom")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("PeriodicLab")
                                    .font(Theme.heading(17))
                                    .foregroundColor(Theme.oxfordBlue)

                                Text("Interactive IUPAC Periodic Table & Mnemonics")
                                    .font(Theme.caption(11))
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }

                        // Toggle Row 1: Mnemonics & Memory Trainer
                        HStack(spacing: 8) {
                            TogglePill(
                                title: viewModel.isMnemonicsOn ? "Mnemonics: ON" : "Mnemonics: OFF",
                                systemIcon: "lightbulb.fill",
                                isOn: viewModel.isMnemonicsOn,
                                activeColor: Theme.yellow
                            ) {
                                viewModel.toggleMnemonics()
                            }

                            TogglePill(
                                title: "Memory Trainer",
                                systemIcon: "brain.head.profile",
                                isOn: viewModel.isMemoryTrainerOn,
                                activeColor: Color(hex: "E0E7FF")
                            ) {
                                viewModel.toggleMemoryTrainer()
                            }

                            Spacer()
                        }

                        // Toggle Row 2: Theory, Voice, Sound
                        HStack(spacing: 8) {
                            TogglePill(
                                title: "Theory & Laws",
                                systemIcon: "book.fill",
                                isOn: viewModel.isTheoryAndLawsOn,
                                activeColor: Color(hex: "E2E8F0")
                            ) {
                                viewModel.toggleTheoryAndLaws()
                            }

                            TogglePill(
                                title: viewModel.isVoiceOn ? "Voice: ON" : "Voice: OFF",
                                systemIcon: "mic.fill",
                                isOn: viewModel.isVoiceOn,
                                activeColor: Color(hex: "E2E8F0")
                            ) {
                                viewModel.toggleVoice()
                            }

                            TogglePill(
                                title: viewModel.isSoundOn ? "Sound: ON" : "Sound: OFF",
                                systemIcon: "speaker.wave.2.fill",
                                isOn: viewModel.isSoundOn,
                                activeColor: Color(hex: "E2E8F0")
                            ) {
                                viewModel.toggleSound()
                            }
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 3)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, -35)

                    // MARK: - Group Selector Bar
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(viewModel.groupTitle)
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)
                                .tracking(0.5)

                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.textSecondary)

                            Spacer()
                        }
                        .padding(.horizontal, 18)

                        // Element Scrubber Row (Be -> Mg -> Ca -> Sr -> Ba -> Ra)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.groupElements) { element in
                                    let isSelected = element.id == viewModel.selectedElement.id

                                    Button(action: {
                                        viewModel.selectElement(element)
                                    }) {
                                        Text(element.symbol)
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
                                            .background(isSelected ? Theme.oxfordBlue : Color(hex: "F1F5F9"))
                                            .foregroundColor(isSelected ? .white : Theme.oxfordBlue)
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .stroke(isSelected ? Theme.crimson : Color.clear, lineWidth: isSelected ? 1.5 : 0)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 18)
                        }
                    }

                    // MARK: - Search Bar
                    SearchBarView(
                        text: $viewModel.searchQuery,
                        placeholder: "Search by name, symbol or atomic number"
                    )
                    .padding(.horizontal, 16)

                    // MARK: - Category Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            categoryPill(title: "Alkali Metals", category: .alkaliMetal)
                            categoryPill(title: "Alkaline Earth", category: .alkalineEarth)
                            categoryPill(title: "Transition Metals", category: .transitionMetal)
                            categoryPill(title: "Post-Transition", category: .postTransition)
                            categoryPill(title: "Metalloids", category: .metalloid)
                            categoryPill(title: "Reactive Nonmetals", category: .reactiveNonmetal)
                        }
                        .padding(.horizontal, 16)
                    }

                    // MARK: - Periodic Table Interactive Grid
                    PeriodicTableGridView(
                        elements: viewModel.elements,
                        selectedElement: viewModel.selectedElement
                    ) { tappedElement in
                        viewModel.selectElement(tappedElement)
                    }
                    .padding(.horizontal, 14)

                    // Bottom Spacing for floating element summary
                    Spacer().frame(height: 110)
                }
            }
            .background(Color(hex: "F8FAFD").ignoresSafeArea())
            .edgesIgnoringSafeArea(.top)

            // MARK: - Bottom Floating Element Summary Bar (Opens Screen 4 Detail)
            bottomSelectedElementBar
        }
        // Sheet presentation for Screen 4 Detail
        .sheet(isPresented: $viewModel.isDetailSheetPresented) {
            ElementDetailSheetView(viewModel: viewModel) {
                viewModel.isDetailSheetPresented = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    // Category pill helper
    @ViewBuilder
    private func categoryPill(title: String, category: ElementCategory) -> some View {
        let isSelected = viewModel.selectedCategoryFilter == category

        Button(action: {
            viewModel.selectCategoryFilter(category)
        }) {
            HStack(spacing: 5) {
                Circle()
                    .fill(category.indicatorColor)
                    .frame(width: 6, height: 6)

                Text(title)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Theme.oxfordBlue : Color(hex: "F1F5F9"))
            .foregroundColor(isSelected ? .white : Theme.oxfordBlue)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // Bottom Selected Element Bar (Screen 3 bottom drawer)
    private var bottomSelectedElementBar: some View {
        Button(action: {
            viewModel.isDetailSheetPresented = true
        }) {
            HStack(spacing: 14) {
                // Element Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(viewModel.selectedElement.category.tileColor)
                        .frame(width: 44, height: 44)

                    VStack(spacing: 1) {
                        Text(viewModel.selectedElement.atomicNumberFormatted)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue.opacity(0.8))

                        Text(viewModel.selectedElement.symbol)
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                    }
                }

                // Element Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.selectedElement.name)
                        .font(Theme.subheading(16))
                        .foregroundColor(Theme.oxfordBlue)

                    Text(viewModel.selectedElement.category.rawValue.uppercased())
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: "FEF3C7"))
                        .foregroundColor(Color(hex: "B45309"))
                        .clipShape(Capsule())
                }

                Spacer()

                // Expand Chevron Button
                ZStack {
                    Circle()
                        .fill(Color(hex: "F1F5F9"))
                        .frame(width: 32, height: 32)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.oxfordBlue)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: -2)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

