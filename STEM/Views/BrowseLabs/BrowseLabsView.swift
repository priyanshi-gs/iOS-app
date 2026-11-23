import SwiftUI

@MainActor
public struct BrowseLabsView: View {
    @StateObject private var viewModel: BrowseLabsViewModel
    public var selectedSubject: Subject?
    public var onLaunchLab: ((Lab) -> Void)?
    public var onOpenProfile: (() -> Void)?

    public init(
        viewModel: BrowseLabsViewModel? = nil,
        selectedSubject: Subject? = nil,
        onLaunchLab: ((Lab) -> Void)? = nil,
        onOpenProfile: (() -> Void)? = nil
    ) {
        let vm = viewModel ?? BrowseLabsViewModel()
        if let selectedSubject = selectedSubject {
            vm.selectedFilter = selectedSubject
        }
        self._viewModel = StateObject(wrappedValue: vm)
        self.selectedSubject = selectedSubject
        self.onLaunchLab = onLaunchLab
        self.onOpenProfile = onOpenProfile
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Standard Waveform Header (consistent with all other screens)
            WaveHeader(
                title: "Browse Labs",
                showBackButton: false
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Search Bar with Native Glass Effect & Filter Menu (Free / Unlock)
                    HStack(spacing: 10) {
                        SearchBarView(
                            text: $viewModel.searchQuery,
                            placeholder: "Search labs, topics or experiments"
                        )

                        // Access Filter Button (Free / Unlock)
                        Menu {
                            Button(action: { viewModel.accessFilter = .all }) {
                                Label("All Labs", systemImage: viewModel.accessFilter == .all ? "checkmark" : "")
                            }
                            Button(action: { viewModel.accessFilter = .free }) {
                                Label("Free", systemImage: viewModel.accessFilter == .free ? "checkmark" : "")
                            }
                            Button(action: { viewModel.accessFilter = .unlock }) {
                                Label("Unlock", systemImage: viewModel.accessFilter == .unlock ? "checkmark" : "")
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(viewModel.accessFilter != .all ? Theme.oxfordBlue : Color.white)
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(viewModel.accessFilter != .all ? Color.clear : Color.black.opacity(0.08), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)

                                Image(systemName: viewModel.accessFilter != .all ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(viewModel.accessFilter != .all ? .white : Theme.oxfordBlue)
                            }
                        }
                    }
                    .padding(.top, 14)

                    // Active Access Filter Chip (if not All)
                    if viewModel.accessFilter != .all {
                        HStack(spacing: 6) {
                            Text("Showing:")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Theme.textSecondary)

                            HStack(spacing: 6) {
                                Text("\(viewModel.accessFilter.rawValue) Labs")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)

                                Button(action: { viewModel.accessFilter = .all }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(hex: "EFF6FF"), in: Capsule())

                            Spacer()
                        }
                        .padding(.top, -6)
                    }

                    // Subject Filter Chips

                // Subject Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // "All" Pill
                        filterChip(
                            title: "All",
                            isSelected: viewModel.selectedFilter == nil
                        ) {
                            viewModel.selectFilter(nil)
                        }

                        // PCM Filter Pills
                        ForEach(Subject.allCases) { subject in
                            filterChip(
                                title: subject.rawValue,
                                isSelected: viewModel.selectedFilter == subject
                            ) {
                                viewModel.selectFilter(subject)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }

                // Lab Cards List
                VStack(spacing: 14) {
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(Theme.oxfordBlue)
                            Text("Loading labs from server...")
                                .font(Theme.body(13))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else if viewModel.filteredLabs.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 36))
                                .foregroundColor(Theme.textMuted)
                            Text("No labs found matching your query")
                                .font(Theme.body(14))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(viewModel.filteredLabs) { lab in
                            LabCardView(lab: lab) {
                                onLaunchLab?(lab)
                            }
                        }
                    }
                }

                // Bottom padding for floating tab bar
                Spacer().frame(height: 84)
            }
            .padding(.horizontal, 20)
        }
    }
    .background(Theme.screenBackground.ignoresSafeArea())
    .task {
        if let subject = selectedSubject {
            viewModel.selectFilter(subject)
        }
        if viewModel.allLabs.isEmpty {
            viewModel.loadLabs()
        }
    }
    .onAppear {
        if let subject = selectedSubject {
            viewModel.selectFilter(subject)
        }
    }
    .onChange(of: selectedSubject) { newSubject in
        viewModel.selectFilter(newSubject)
    }
}

    // Helper for filter chip pill
    @ViewBuilder
    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.crimson : Color(hex: "F1F5F9"))
                .foregroundColor(isSelected ? .white : Theme.oxfordBlue)
                .clipShape(Capsule())
                .shadow(color: isSelected ? Theme.crimson.opacity(0.25) : Color.clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

