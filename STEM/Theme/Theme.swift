import SwiftUI

// MARK: - Brand Design System
public enum Theme {
    // Primary Brand Palette
    public static let oxfordBlue = Color(hex: "0E3A6E") // Softened smooth royal navy (lighter and softer than harsh 002147)
    public static let crimson    = Color(hex: "DC143C") // Large ring graphics, highlight cards, key phrases
    public static let yellow     = Color(hex: "FFC20E") // Eyebrow labels, process step labels, thin accents

    // Supporting UI Colors
    public static let backgroundWhite = Color.white
    public static let backgroundPage  = Color(hex: "F4F6FB")
    public static let cardBackground  = Color(hex: "FFFFFF")
    public static let surfaceGray     = Color(hex: "F0F3F8")
    public static let surfaceLight    = Color(hex: "F8FAFC")
    public static let surfaceWarm     = Color(hex: "F8FAFC")
    public static let textPrimary     = Color(hex: "0E3A6E")
    public static let textSecondary   = Color(hex: "64748B")
    public static let textMuted       = Color(hex: "94A3B8")
    public static let textLight       = Color.white
    public static let successGreen    = Color(hex: "10B981")
    public static let borderSubtle    = Color(hex: "E2E8F0")

    // Onboarding & Checkout Funnel Tokens (Soft Crimson & Navy)
    public static let navyBackground = Color(hex: "0C325D")   // Soft smooth navy background
    public static let navySurface = Color(hex: "123E72")      // Soft smooth navy surface
    public static let navyGradient = LinearGradient(
        colors: [
            Color(hex: "11437B"), // Soft luminous royal navy at top
            Color(hex: "0B2E58")  // Smooth deep royal navy at bottom
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    public static let primaryRed = Color(red: 0.73, green: 0.08, blue: 0.22)       // #BA1438 - soft matte ruby
    public static let primaryRedDark = Color(red: 0.55, green: 0.04, blue: 0.16)   // #8C0A29 - deep wine bordeaux
    public static let primaryBlue = Color(red: 0.16, green: 0.45, blue: 0.95)     // #2973F2
    public static let accentGold = Color(red: 0.99, green: 0.75, blue: 0.12)      // #FDBF1E
    public static let accentGreen = Color(red: 0.11, green: 0.74, blue: 0.38)     // #1CBC61
    public static let accentPurple = Color(red: 0.75, green: 0.22, blue: 0.65)    // #BF38A6
    public static let screenBackground = Color(red: 0.96, green: 0.97, blue: 0.99) // #F5F7FC
    public static let textDark = Color(red: 0.08, green: 0.11, blue: 0.18)         // #141C2E
    public static let borderLight = Color(red: 0.90, green: 0.92, blue: 0.96)      // #E6EBF5

    public static let redButtonGradient = LinearGradient(
        colors: [
            Color(red: 0.74, green: 0.09, blue: 0.23), // #BD173B
            Color(red: 0.64, green: 0.05, blue: 0.18)  // #A30D2E
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    public static let premiumCardGradient = LinearGradient(
        colors: [
            Color(red: 0.65, green: 0.07, blue: 0.20), // #A61233
            Color(red: 0.52, green: 0.03, blue: 0.15)  // #850826
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

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

