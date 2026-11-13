import SwiftUI

public struct BrowseLabsView: View {
    @StateObject private var viewModel: BrowseLabsViewModel
    public var onLaunchLab: ((Lab) -> Void)?

    public init(
        viewModel: BrowseLabsViewModel = BrowseLabsViewModel(),
        onLaunchLab: ((Lab) -> Void)? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onLaunchLab = onLaunchLab
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                // Top Header Section with Brand Arcs
                ZStack(alignment: .topTrailing) {
                    DecorativeArcView()
                        .offset(x: 20, y: -20)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Browse Labs")
                            .font(Theme.largeTitle(26))
                            .foregroundColor(Theme.oxfordBlue)

                        Text("Explore interactive labs across PCM.")
                            .font(Theme.body(14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                }

                // Search Bar
                SearchBarView(
                    text: $viewModel.searchQuery,
                    placeholder: "Search labs, topics or experiments"
                )

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
                    if viewModel.filteredLabs.isEmpty {
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

                // Bottom padding for tab bar
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(hex: "F8FAFD").ignoresSafeArea())
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

