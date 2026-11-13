import Foundation

public enum LabStatus: String, Codable {
    case inProgress = "In Progress"
    case completed  = "Completed"
    case notStarted = "Not Started"
}

public struct Lab: Identifiable, Hashable, Codable {
    public let id: String
    public let title: String
    public let subject: Subject
    public let code: String
    public let duration: String
    public var status: LabStatus
    public let thumbnailSymbol: String
    public let gradientStartHex: String
    public let gradientEndHex: String
    public let description: String

    public init(
        id: String = UUID().uuidString,
        title: String,
        subject: Subject,
        code: String,
        duration: String,
        status: LabStatus,
        thumbnailSymbol: String,
        gradientStartHex: String,
        gradientEndHex: String,
        description: String = ""
    ) {
        self.id = id
        self.title = title
        self.subject = subject
        self.code = code
        self.duration = duration
        self.status = status
        self.thumbnailSymbol = thumbnailSymbol
        self.gradientStartHex = gradientStartHex
        self.gradientEndHex = gradientEndHex
        self.description = description
    }
}

