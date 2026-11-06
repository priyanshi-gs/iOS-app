import Foundation

public enum Subject: String, Codable, CaseIterable, Identifiable {
    case all = "All"
    case physics = "Physics"
    case chemistry = "Chemistry"
    case biology = "Biology"
    case mathematics = "Mathematics"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .physics: return "atom"
        case .chemistry: return "flask.fill"
        case .biology: return "leaf.fill"
        case .mathematics: return "function"
        }
    }
}

public enum LabStatus: String, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
}

public struct LabExperiment: Identifiable, Codable, Hashable {
    public let id: String
    public let title: String
    public let subject: Subject
    public let grade: String
    public let estimatedMinutes: Int
    public var status: LabStatus
    public var progress: Double // 0.0 to 1.0
    public let iconName: String
    public let simulationType: String
    public let description: String
    
    public init(
        id: String,
        title: String,
        subject: Subject,
        grade: String = "Classes 9 - 12",
        estimatedMinutes: Int = 30,
        status: LabStatus = .notStarted,
        progress: Double = 0.0,
        iconName: String,
        simulationType: String = "interactive",
        description: String = ""
    ) {
        self.id = id
        self.title = title
        self.subject = subject
        self.grade = grade
        self.estimatedMinutes = estimatedMinutes
        self.status = status
        self.progress = progress
        self.iconName = iconName
        self.simulationType = simulationType
        self.description = description
    }
}

