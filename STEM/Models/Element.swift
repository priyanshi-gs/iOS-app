import SwiftUI

public enum ElementCategory: String, CaseIterable, Identifiable, Codable {
    case alkaliMetal       = "Alkali Metals"
    case alkalineEarth     = "Alkaline Earth"
    case transitionMetal   = "Transition Metals"
    case postTransition    = "Post-Transition"
    case metalloid         = "Metalloids"
    case reactiveNonmetal  = "Reactive Nonmetals"
    case nobleGas          = "Noble Gases"
    case lanthanide        = "Lanthanides"
    case actinide          = "Actinides"

    public var id: String { rawValue }

    public var tileColor: Color {
        switch self {
        case .alkaliMetal:      return Theme.alkaliMetalColor
        case .alkalineEarth:    return Theme.alkalineEarthColor
        case .transitionMetal:  return Theme.transitionMetalColor
        case .postTransition:   return Theme.postTransitionColor
        case .metalloid:        return Theme.metalloidColor
        case .reactiveNonmetal: return Theme.reactiveNonmetalColor
        case .nobleGas:         return Theme.nobleGasColor
        case .lanthanide:       return Theme.lanthanideColor
        case .actinide:         return Theme.actinideColor
        }
    }

    public var indicatorColor: Color {
        switch self {
        case .alkaliMetal:      return Color(hex: "EA580C")
        case .alkalineEarth:    return Color(hex: "D97706")
        case .transitionMetal:  return Color(hex: "2563EB")
        case .postTransition:   return Color(hex: "059669")
        case .metalloid:        return Color(hex: "7C3AED")
        case .reactiveNonmetal: return Color(hex: "E11D48")
        case .nobleGas:         return Color(hex: "DB2777")
        case .lanthanide:       return Color(hex: "9333EA")
        case .actinide:         return Color(hex: "C026D3")
        }
    }
}

public struct Element: Identifiable, Hashable, Codable {
    public let id: Int // Atomic number
    public let symbol: String
    public let name: String
    public let atomicMass: Double
    public let category: ElementCategory
    public let group: Int // 1 to 18
    public let period: Int // 1 to 7
    public let electronConfig: [Int] // Orbit shells, e.g. [2, 8, 8, 2]
    public let electronegativity: Double?
    public let atomicRadius: Int? // in pm
    public let ionizationEnergy: Double? // in kJ/mol
    public let mnemonicTrick: String?
    public let overviewDescription: String
    public let propertiesDescription: String
    public let electronConfigurationNotation: String
    public let commonUses: [String]

    public var atomicNumberFormatted: String {
        String(id)
    }

    public var atomicMassFormatted: String {
        String(format: "%.2f u", atomicMass)
    }

    public init(
        id: Int,
        symbol: String,
        name: String,
        atomicMass: Double,
        category: ElementCategory,
        group: Int,
        period: Int,
        electronConfig: [Int],
        electronegativity: Double? = nil,
        atomicRadius: Int? = nil,
        ionizationEnergy: Double? = nil,
        mnemonicTrick: String? = nil,
        overviewDescription: String = "",
        propertiesDescription: String = "",
        electronConfigurationNotation: String = "",
        commonUses: [String] = []
    ) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.atomicMass = atomicMass
        self.category = category
        self.group = group
        self.period = period
        self.electronConfig = electronConfig
        self.electronegativity = electronegativity
        self.atomicRadius = atomicRadius
        self.ionizationEnergy = ionizationEnergy
        self.mnemonicTrick = mnemonicTrick
        self.overviewDescription = overviewDescription
        self.propertiesDescription = propertiesDescription
        self.electronConfigurationNotation = electronConfigurationNotation
        self.commonUses = commonUses
    }
}

