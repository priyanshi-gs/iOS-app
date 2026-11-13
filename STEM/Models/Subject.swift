import SwiftUI

public enum Subject: String, CaseIterable, Identifiable, Codable {
    case physics     = "Physics"
    case chemistry   = "Chemistry"
    case biology     = "Biology"
    case mathematics = "Mathematics"

    public var id: String { rawValue }

    public var systemIcon: String {
        switch self {
        case .physics:     return "atom"
        case .chemistry:   return "flask.fill"
        case .biology:     return "leaf.fill"
        case .mathematics: return "function"
        }
    }

    public var accentColor: Color {
        switch self {
        case .physics:     return Color(hex: "0284C7")
        case .chemistry:   return Theme.crimson
        case .biology:     return Color(hex: "10B981")
        case .mathematics: return Color(hex: "8B5CF6")
        }
    }
}

