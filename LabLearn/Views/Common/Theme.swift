import SwiftUI

public enum Theme {
    // MARK: - Core Brand Palette
    public static let navyBackground = Color(red: 0.04, green: 0.07, blue: 0.16)   // #0A1128
    public static let navySurface = Color(red: 0.08, green: 0.12, blue: 0.25)      // #141F40
    
    // Soft, premium matte ruby/crimson tones (rich and elegant, not neon/fluorescent)
    public static let primaryRed = Color(red: 0.86, green: 0.06, blue: 0.23)       // #DC0F3B
    public static let primaryRedDark = Color(red: 0.72, green: 0.04, blue: 0.18)   // #B80A2E
    
    // Accents
    public static let primaryBlue = Color(red: 0.16, green: 0.45, blue: 0.95)     // #2973F2
    public static let accentGold = Color(red: 0.99, green: 0.75, blue: 0.12)      // #FDBF1E
    public static let accentGreen = Color(red: 0.11, green: 0.74, blue: 0.38)     // #1CBC61
    public static let accentPurple = Color(red: 0.75, green: 0.22, blue: 0.65)    // #BF38A6
    
    // Neutrals
    public static let screenBackground = Color(red: 0.96, green: 0.97, blue: 0.99) // #F5F7FC
    public static let cardBackground = Color.white
    public static let textDark = Color(red: 0.08, green: 0.11, blue: 0.18)         // #141C2E
    public static let textMuted = Color(red: 0.45, green: 0.50, blue: 0.60)        // #738099
    public static let borderLight = Color(red: 0.90, green: 0.92, blue: 0.96)      // #E6EBF5
    
    // MARK: - Sophisticated Gradients
    public static let redButtonGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.05, blue: 0.22),
            Color(red: 0.88, green: 0.09, blue: 0.26)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let premiumCardGradient = LinearGradient(
        colors: [
            Color(red: 0.76, green: 0.06, blue: 0.18),
            Color(red: 0.88, green: 0.10, blue: 0.24)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
