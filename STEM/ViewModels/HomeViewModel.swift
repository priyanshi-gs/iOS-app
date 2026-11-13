import SwiftUI
import Combine

public final class HomeViewModel: ObservableObject {
    @Published public var userProfile: UserProfile
    @Published public var continueLearningLab: Lab?
    @Published public var recentLabs: [Lab] = []
    @Published public var selectedSubject: Subject? = .chemistry

    private let dataService: DataService

    public init(dataService: DataService = .shared) {
        self.dataService = dataService
        self.userProfile = dataService.fetchUserProfile()
        loadData()
    }

    public func loadData() {
        let allLabs = dataService.fetchLabs()
        self.userProfile = dataService.fetchUserProfile()

        // Continue learning lab is the first active/in-progress lab
        self.continueLearningLab = allLabs.first { $0.status == .inProgress } ?? allLabs.first

        // Recent visited labs
        self.recentLabs = allLabs
    }

    public func selectSubject(_ subject: Subject) {
        if selectedSubject == subject {
            // Keep selected or toggle
            selectedSubject = subject
        } else {
            selectedSubject = subject
        }
    }
}

