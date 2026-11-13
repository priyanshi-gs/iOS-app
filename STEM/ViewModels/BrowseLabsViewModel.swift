import SwiftUI
import Combine

public final class BrowseLabsViewModel: ObservableObject {
    @Published public var allLabs: [Lab] = []
    @Published public var searchQuery: String = ""
    @Published public var selectedFilter: Subject? = nil // nil means "All"

    private let dataService: DataService

    public init(dataService: DataService = .shared) {
        self.dataService = dataService
        loadLabs()
    }

    public func loadLabs() {
        self.allLabs = dataService.fetchLabs()
    }

    public var filteredLabs: [Lab] {
        allLabs.filter { lab in
            let matchesFilter = (selectedFilter == nil) || (lab.subject == selectedFilter)
            let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            if trimmedQuery.isEmpty {
                return matchesFilter
            } else {
                let matchesSearch = lab.title.lowercased().contains(trimmedQuery) ||
                                    lab.code.lowercased().contains(trimmedQuery) ||
                                    lab.subject.rawValue.lowercased().contains(trimmedQuery) ||
                                    lab.description.lowercased().contains(trimmedQuery)
                return matchesFilter && matchesSearch
            }
        }
    }

    public func selectFilter(_ subject: Subject?) {
        selectedFilter = subject
    }

    public func clearSearch() {
        searchQuery = ""
    }
}

