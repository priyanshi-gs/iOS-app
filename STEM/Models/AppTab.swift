import Foundation

public enum AppTab: Int, CaseIterable, Identifiable {
    case home = 0
    case labs = 1

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .home: return "Home"
        case .labs: return "Labs"
        }
    }

    public var icon: String {
        switch self {
        case .home: return "house.fill"
        case .labs: return "flask.fill"
        }
    }
}

