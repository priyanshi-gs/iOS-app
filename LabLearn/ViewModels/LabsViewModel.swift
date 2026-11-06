import Foundation
import Combine

public final class HomeViewModel: ObservableObject {
    @Published public var studentName: String = "Ratnam"
    @Published public var gradeTitle: String = "Class 11 - PCM"
    
    // Quick Stats
    @Published public var availableLabsCount: Int = 2
    @Published public var badgesCount: Int = 12
    @Published public var labHours: Double = 18.5
    
    // In progress lab
    @Published public var activeExperiment: LabExperiment = LabExperiment(
        id: "exp_titration",
        title: "Acid-Base Titration",
        subject: .chemistry,
        grade: "Class 11",
        estimatedMinutes: 25,
        status: .inProgress,
        progress: 0.65,
        iconName: "flask.fill",
        simulationType: "titration",
        description: "Standardize hydrochloric acid using sodium hydroxide and phenolphthalein."
    )
    
    // Recent Labs
    @Published public var recentLabs: [LabExperiment] = [
        LabExperiment(id: "r1", title: "Acid-Base Titration", subject: .chemistry, status: .inProgress, progress: 0.65, iconName: "flask.fill"),
        LabExperiment(id: "r2", title: "Simple Pendulum", subject: .physics, status: .completed, progress: 1.0, iconName: "arrow.left.and.right"),
        LabExperiment(id: "r3", title: "Refraction of Light", subject: .physics, status: .completed, progress: 1.0, iconName: "prism"),
        LabExperiment(id: "r4", title: "Magnetic Field Lines", subject: .physics, status: .completed, progress: 1.0, iconName: "point.3.filled.connected.trianglepath.dotted"),
        LabExperiment(id: "r5", title: "DNA Structure", subject: .biology, status: .completed, progress: 1.0, iconName: "dna"),
        LabExperiment(id: "r6", title: "Study of Stomata", subject: .biology, status: .completed, progress: 1.0, iconName: "allergens")
    ]
    
    public init() {}
}

public final class LabsViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public var selectedSubject: Subject = .all
    
    @Published public var allLabs: [LabExperiment] = [
        LabExperiment(
            id: "lab_titration",
            title: "Acid-Base Titration",
            subject: .chemistry,
            grade: "Classes 10 - 12",
            estimatedMinutes: 30,
            status: .inProgress,
            progress: 0.65,
            iconName: "flask.fill",
            simulationType: "periodic",
            description: "Determine the strength of given hydrochloric acid by titrating it against standard sodium hydroxide solution."
        ),
        LabExperiment(
            id: "lab_pendulum",
            title: "Simple Pendulum",
            subject: .physics,
            grade: "Classes 9 - 11",
            estimatedMinutes: 20,
            status: .notStarted,
            progress: 0.0,
            iconName: "circle.and.line.horizontal",
            simulationType: "interactive",
            description: "Study acceleration due to gravity (g) using time period of oscillations of a simple pendulum."
        ),
        LabExperiment(
            id: "lab_dispersion",
            title: "Dispersion of Light",
            subject: .physics,
            grade: "Classes 10 - 12",
            estimatedMinutes: 25,
            status: .notStarted,
            progress: 0.0,
            iconName: "rays",
            simulationType: "interactive",
            description: "Trace the path of rays through a glass prism and observe white light spectrum dispersion."
        ),
        LabExperiment(
            id: "lab_magnetic",
            title: "Magnetic Field Lines",
            subject: .physics,
            grade: "Classes 8 - 10",
            estimatedMinutes: 20,
            status: .completed,
            progress: 1.0,
            iconName: "bolt.fill",
            simulationType: "interactive",
            description: "Plot magnetic field lines around a bar magnet using iron filings and compass needles."
        ),
        LabExperiment(
            id: "lab_esters",
            title: "Esters - Preparation & Properties",
            subject: .chemistry,
            grade: "Classes 10 - 12",
            estimatedMinutes: 35,
            status: .notStarted,
            progress: 0.0,
            iconName: "drop.fill",
            simulationType: "interactive",
            description: "Esterification reaction between ethanoic acid and ethanol in presence of concentrated sulphuric acid."
        ),
        LabExperiment(
            id: "lab_dna",
            title: "DNA Structure",
            subject: .biology,
            grade: "Classes 11 - 12",
            estimatedMinutes: 30,
            status: .completed,
            progress: 1.0,
            iconName: "dna",
            simulationType: "interactive",
            description: "Explore double helix antiparallel chains, nucleotide base pairing (A-T, G-C), and phosphate backbone."
        )
    ]
    
    public var filteredLabs: [LabExperiment] {
        allLabs.filter { lab in
            let matchesSubject = (selectedSubject == .all) || (lab.subject == selectedSubject)
            let matchesSearch = searchText.isEmpty ||
                lab.title.localizedCaseInsensitiveContains(searchText) ||
                lab.subject.rawValue.localizedCaseInsensitiveContains(searchText)
            return matchesSubject && matchesSearch
        }
    }
}

