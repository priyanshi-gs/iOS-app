import Foundation

public struct UserProfile: Identifiable, Codable {
    public let id: String
    public var name: String
    public var availableLabsCount: Int
    public var badgesWonCount: Int
    public var labHoursTotal: Double
    public var activeLabId: String?

    public init(
        id: String = UUID().uuidString,
        name: String = "Ratnam",
        availableLabsCount: Int = 2,
        badgesWonCount: Int = 12,
        labHoursTotal: Double = 18.5,
        activeLabId: String? = "ch-101"
    ) {
        self.id = id
        self.name = name
        self.availableLabsCount = availableLabsCount
        self.badgesWonCount = badgesWonCount
        self.labHoursTotal = labHoursTotal
        self.activeLabId = activeLabId
    }
}

