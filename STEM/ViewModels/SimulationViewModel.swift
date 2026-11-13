import SwiftUI
import Combine

public enum DetailTab: String, CaseIterable, Identifiable {
    case overview       = "Overview"
    case properties     = "Properties"
    case configuration  = "Configuration"
    case uses           = "Uses"

    public var id: String { rawValue }
}

public final class SimulationViewModel: ObservableObject {
    @Published public var elements: [Element] = []
    @Published public var selectedElement: Element
    @Published public var selectedGroup: Int = 2
    @Published public var selectedCategoryFilter: ElementCategory? = nil
    @Published public var searchQuery: String = ""

    // Simulation Header Controls
    @Published public var isMnemonicsOn: Bool = true
    @Published public var isMemoryTrainerOn: Bool = false
    @Published public var isTheoryAndLawsOn: Bool = true
    @Published public var isVoiceOn: Bool = true
    @Published public var isSoundOn: Bool = true

    // Detail Sheet / View State
    @Published public var isDetailSheetPresented: Bool = false
    @Published public var selectedDetailTab: DetailTab = .overview
    @Published public var isAudioPlaying: Bool = false

    private let dataService: DataService

    public init(dataService: DataService = .shared) {
        self.dataService = dataService
        let fetched = dataService.fetchElements()
        self.elements = fetched

        // Default to Calcium (id: 20)
        let calcium = fetched.first { $0.id == 20 } ?? fetched[0]
        self.selectedElement = calcium

        loadElements()
    }

    public func loadElements() {
        self.elements = dataService.fetchElements()
    }

    // Elements in the currently selected group (e.g. Group 2 Alkaline Earth Metals: Be, Mg, Ca, Sr, Ba, Ra)
    public var groupElements: [Element] {
        elements.filter { $0.group == selectedGroup }.sorted { $0.id < $1.id }
    }

    public var groupTitle: String {
        switch selectedGroup {
        case 1:  return "GROUP 1: ALKALI METALS"
        case 2:  return "GROUP 2: ALKALINE EARTH METALS"
        case 13: return "GROUP 13: BORON GROUP"
        case 14: return "GROUP 14: CARBON GROUP"
        case 15: return "GROUP 15: PNICTOGENS"
        case 16: return "GROUP 16: CHALCOGENS"
        case 17: return "GROUP 17: HALOGENS"
        case 18: return "GROUP 18: NOBLE GASES"
        default: return "GROUP \(selectedGroup): TRANSITION METALS"
        }
    }

    // Filtered elements for search and category chips
    public var filteredElements: [Element] {
        elements.filter { el in
            let matchesCategory = (selectedCategoryFilter == nil) || (el.category == selectedCategoryFilter)
            let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            if trimmed.isEmpty {
                return matchesCategory
            } else {
                let matchesSearch = el.name.lowercased().contains(trimmed) ||
                                    el.symbol.lowercased().contains(trimmed) ||
                                    String(el.id) == trimmed
                return matchesCategory && matchesSearch
            }
        }
    }

    public func selectElement(_ element: Element) {
        self.selectedElement = element
        if element.group != selectedGroup && (element.group == 1 || element.group == 2 || element.group >= 13) {
            self.selectedGroup = element.group
        }
    }

    public func selectCategoryFilter(_ category: ElementCategory?) {
        if selectedCategoryFilter == category {
            selectedCategoryFilter = nil
        } else {
            selectedCategoryFilter = category
        }
    }

    public func toggleMnemonics() {
        isMnemonicsOn.toggle()
    }

    public func toggleMemoryTrainer() {
        isMemoryTrainerOn.toggle()
    }

    public func toggleTheoryAndLaws() {
        isTheoryAndLawsOn.toggle()
    }

    public func toggleVoice() {
        isVoiceOn.toggle()
    }

    public func toggleSound() {
        isSoundOn.toggle()
    }

    public func playAudioMnemonic() {
        isAudioPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.isAudioPlaying = false
        }
    }
}

