import Foundation

public struct UserProfile: Identifiable, Codable {
    public let id: String
    public var name: String
    public var availableLabsCount: Int
    public var badgesWonCount: Int
    public var labHoursTotal: Double
    public var activeLabId: String?
    public var accessTierLabel: String

    public init(
        id: String = UUID().uuidString,
        name: String = "Student",
        availableLabsCount: Int = 0,
        badgesWonCount: Int = 0,
        labHoursTotal: Double = 0.0,
        activeLabId: String? = nil,
        accessTierLabel: String = "Free Access"
    ) {
        self.id = id
        self.name = name
        self.availableLabsCount = availableLabsCount
        self.badgesWonCount = badgesWonCount
        self.labHoursTotal = labHoursTotal
        self.activeLabId = activeLabId
        self.accessTierLabel = accessTierLabel
    }
}

