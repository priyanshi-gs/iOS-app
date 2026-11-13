import SwiftUI

// MARK: - Brand Design System
public enum Theme {
    // Primary Brand Palette
    public static let oxfordBlue = Color(hex: "002147") // Dark pages, cards, and headings
    public static let crimson    = Color(hex: "DC143C") // Large ring graphics, highlight cards, key phrases
    public static let yellow     = Color(hex: "FFC20E") // Eyebrow labels, process step labels, thin accents

    // Supporting UI Colors
    public static let backgroundWhite = Color.white
    public static let backgroundPage  = Color(hex: "F4F6FB")
    public static let cardBackground  = Color(hex: "FFFFFF")
    public static let surfaceGray     = Color(hex: "F0F3F8")
    public static let surfaceLight    = Color(hex: "F8FAFC")
    public static let textPrimary     = Color(hex: "002147")
    public static let textSecondary   = Color(hex: "64748B")
    public static let textMuted       = Color(hex: "94A3B8")
    public static let textLight       = Color.white
    public static let successGreen    = Color(hex: "10B981")
    public static let borderSubtle    = Color(hex: "E2E8F0")

    // Element Category Colors (Soft pastels for Periodic Table)
    public static let alkaliMetalColor       = Color(hex: "FED7AA") // Light orange/peach
    public static let alkalineEarthColor     = Color(hex: "FEF08A") // Soft yellow
    public static let transitionMetalColor   = Color(hex: "BFDBFE") // Sky blue
    public static let postTransitionColor    = Color(hex: "BBF7D0") // Mint green
    public static let metalloidColor         = Color(hex: "DDD6FE") // Soft purple
    public static let reactiveNonmetalColor  = Color(hex: "FECDD3") // Soft rose pink
    public static let nobleGasColor          = Color(hex: "FBCFE8") // Soft violet pink
    public static let lanthanideColor        = Color(hex: "E9D5FF") // Lavender
    public static let actinideColor          = Color(hex: "FED7E2") // Pastel blush

    // Layout Dimensions
    public static let radiusSmall: CGFloat  = 8
    public static let radiusMedium: CGFloat = 14
    public static let radiusLarge: CGFloat  = 20
    public static let radiusXL: CGFloat     = 28

    // Typography
    public static func largeTitle(_ size: CGFloat = 26) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    public static func heading(_ size: CGFloat = 20) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    public static func subheading(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    public static func body(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    public static func caption(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    public static func eyebrow(_ size: CGFloat = 10) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }
}

// MARK: - Color Hex Initializer
public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: Double
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                Double((int >> 8) * 17) / 255.0,
                Double((int >> 4 & 0xF) * 17) / 255.0,
                Double((int & 0xF) * 17) / 255.0,
                1.0
            )
        case 6: // RGB (24-bit)
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255.0,
                Double((int >> 8) & 0xFF) / 255.0,
                Double(int & 0xFF) / 255.0,
                1.0
            )
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255.0,
                Double((int >> 8) & 0xFF) / 255.0,
                Double(int & 0xFF) / 255.0,
                Double((int >> 24) & 0xFF) / 255.0
            )
        default:
            (r, g, b, a) = (1, 1, 1, 1)
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

