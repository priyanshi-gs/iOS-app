import SwiftUI

public enum Theme {
    // Brand Colors matching uploaded Figma mockups
    public static let navyBackground = Color(red: 0.04, green: 0.07, blue: 0.16)   // #0A1128
    public static let navySurface = Color(red: 0.08, green: 0.12, blue: 0.25)      // #141F40
    public static let primaryRed = Color(red: 0.90, green: 0.15, blue: 0.24)       // #E5273E
    public static let primaryRedDark = Color(red: 0.73, green: 0.10, blue: 0.18)   // #BA1A2E
    
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
    
    // Gradients
    public static let redButtonGradient = LinearGradient(
        colors: [primaryRed, Color(red: 0.98, green: 0.25, blue: 0.35)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let premiumCardGradient = LinearGradient(
        colors: [Color(red: 0.75, green: 0.08, blue: 0.18), Color(red: 0.92, green: 0.16, blue: 0.26)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
