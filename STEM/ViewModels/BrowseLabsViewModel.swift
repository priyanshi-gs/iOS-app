import SwiftUI
import Combine

public enum LabAccessFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case free = "Free"
    case unlock = "Unlock"

    public var id: String { rawValue }
}

@MainActor
public final class BrowseLabsViewModel: ObservableObject {
    @Published public var allLabs: [Lab] = []
    @Published public var searchQuery: String = ""
    @Published public var selectedFilter: Subject? = nil // nil means "All"
    @Published public var accessFilter: LabAccessFilter = .all
    @Published public var isLoading: Bool = false

    private let dataService: DataService

    public init(dataService: DataService = .shared) {
        self.dataService = dataService
        loadLabs()
    }

    public func loadLabs() {
        self.allLabs = []
        self.isLoading = true

        // Load strictly from backend
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let liveLabs = try await self.dataService.fetchLabsLive()
                await MainActor.run {
                    self.allLabs = liveLabs
                    self.isLoading = false
                }
            } catch {
                print("Failed to fetch live labs: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }

    public var filteredLabs: [Lab] {
        allLabs.filter { lab in
            let matchesSubject = (selectedFilter == nil) || (lab.subject == selectedFilter)

            let matchesAccess: Bool
            switch accessFilter {
            case .all:
                matchesAccess = true
            case .free:
                matchesAccess = !lab.isLocked
            case .unlock:
                matchesAccess = lab.isLocked
            }

            guard matchesSubject && matchesAccess else { return false }

            let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if trimmedQuery.isEmpty {
                return true
            }

            return lab.title.lowercased().contains(trimmedQuery) ||
                   lab.code.lowercased().contains(trimmedQuery) ||
                   lab.subject.rawValue.lowercased().contains(trimmedQuery) ||
                   lab.description.lowercased().contains(trimmedQuery)
        }
    }

    public func selectFilter(_ subject: Subject?) {
        selectedFilter = subject
    }

    public func clearSearch() {
        searchQuery = ""
    }
}

