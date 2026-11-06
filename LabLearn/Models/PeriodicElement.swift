import Foundation
import SwiftUI

public enum ElementCategory: String, Codable, CaseIterable {
    case alkaliMetal = "Alkali Metals"
    case alkalineEarth = "Alkaline Earth Metals"
    case transitionMetal = "Transition Metals"
    case basicMetal = "Basic Metals"
    case metalloid = "Metalloids"
    case nonmetal = "Nonmetals"
    case halogen = "Halogens"
    case nobleGas = "Noble Gases"
    
    public var accentColor: Color {
        switch self {
        case .alkaliMetal: return Color(red: 0.98, green: 0.45, blue: 0.45)
        case .alkalineEarth: return Color(red: 0.98, green: 0.70, blue: 0.35)
        case .transitionMetal: return Color(red: 0.60, green: 0.75, blue: 0.98)
        case .basicMetal: return Color(red: 0.55, green: 0.85, blue: 0.75)
        case .metalloid: return Color(red: 0.85, green: 0.65, blue: 0.95)
        case .nonmetal: return Color(red: 0.45, green: 0.85, blue: 0.55)
        case .halogen: return Color(red: 0.98, green: 0.85, blue: 0.35)
        case .nobleGas: return Color(red: 0.75, green: 0.60, blue: 0.98)
        }
    }
}

public struct PeriodicElement: Identifiable, Codable, Hashable {
    public let id: Int // Atomic number
    public let symbol: String
    public let name: String
    public let category: ElementCategory
    public let group: Int
    public let period: Int
    public let atomicMass: Double
    public let valency: Int
    public let electronegativity: Double
    public let electronConfiguration: String
    public let shellElectrons: [Int] // [K, L, M, N] shells
    public let hinglishMnemonic: String
    public let mnemonicNote: String
    
    public var atomicNumber: Int { id }
    
    public static let sampleElements: [PeriodicElement] = [
        PeriodicElement(
            id: 20,
            symbol: "Ca",
            name: "Calcium",
            category: .alkalineEarth,
            group: 2,
            period: 4,
            atomicMass: 40.078,
            valency: 2,
            electronegativity: 1.00,
            electronConfiguration: "[Ar] 4s²",
            shellElectrons: [2, 8, 8, 2],
            hinglishMnemonic: "Beta Mange Car Scooter Baap Razi",
            mnemonicNote: "Ca stands for 'Car' in Group 2 (Be, Mg, Ca, Sr, Ba, Ra)"
        ),
        PeriodicElement(
            id: 12,
            symbol: "Mg",
            name: "Magnesium",
            category: .alkalineEarth,
            group: 2,
            period: 3,
            atomicMass: 24.305,
            valency: 2,
            electronegativity: 1.31,
            electronConfiguration: "[Ne] 3s²",
            shellElectrons: [2, 8, 2],
            hinglishMnemonic: "Beta Mange Car Scooter Baap Razi",
            mnemonicNote: "Mg stands for 'Mange' in Group 2"
        ),
        PeriodicElement(
            id: 4,
            symbol: "Be",
            name: "Beryllium",
            category: .alkalineEarth,
            group: 2,
            period: 2,
            atomicMass: 9.0122,
            valency: 2,
            electronegativity: 1.57,
            electronConfiguration: "[He] 2s²",
            shellElectrons: [2, 2],
            hinglishMnemonic: "Beta Mange Car Scooter Baap Razi",
            mnemonicNote: "Be stands for 'Beta' in Group 2"
        ),
        PeriodicElement(
            id: 11,
            symbol: "Na",
            name: "Sodium",
            category: .alkaliMetal,
            group: 1,
            period: 3,
            atomicMass: 22.990,
            valency: 1,
            electronegativity: 0.93,
            electronConfiguration: "[Ne] 3s¹",
            shellElectrons: [2, 8, 1],
            hinglishMnemonic: "Ha Li Na Ki Rab Se Fariyad",
            mnemonicNote: "Na stands for 'Na' in Group 1 (H, Li, Na, K, Rb, Cs, Fr)"
        ),
        PeriodicElement(
            id: 6,
            symbol: "C",
            name: "Carbon",
            category: .nonmetal,
            group: 14,
            period: 2,
            atomicMass: 12.011,
            valency: 4,
            electronegativity: 2.55,
            electronConfiguration: "[He] 2s² 2p²",
            shellElectrons: [2, 4],
            hinglishMnemonic: "Kahe Sita Ji Suno Prabhu",
            mnemonicNote: "C stands for 'Kahe' in Group 14 (C, Si, Ge, Sn, Pb)"
        ),
        PeriodicElement(
            id: 8,
            symbol: "O",
            name: "Oxygen",
            category: .nonmetal,
            group: 16,
            period: 2,
            atomicMass: 15.999,
            valency: 2,
            electronegativity: 3.44,
            electronConfiguration: "[He] 2s² 2p⁴",
            shellElectrons: [2, 6],
            hinglishMnemonic: "O Style Se Tel Polish",
            mnemonicNote: "O stands for 'O' in Group 16 (O, S, Se, Te, Po)"
        ),
        PeriodicElement(
            id: 26,
            symbol: "Fe",
            name: "Iron",
            category: .transitionMetal,
            group: 8,
            period: 4,
            atomicMass: 55.845,
            valency: 3,
            electronegativity: 1.83,
            electronConfiguration: "[Ar] 3d⁶ 4s²",
            shellElectrons: [2, 8, 14, 2],
            hinglishMnemonic: "Science Ti-V-C-Man-Fe-Co-Ni-Cu-Zn",
            mnemonicNote: "Fe stands for 'Fe' in 3d series transition metals"
        )
    ]
}

