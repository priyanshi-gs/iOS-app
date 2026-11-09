import SwiftUI

public enum Theme {
    // MARK: - Core Brand Palette
    public static let navyBackground = Color(red: 0.04, green: 0.07, blue: 0.16)   // #0A1128
    public static let navySurface = Color(red: 0.08, green: 0.12, blue: 0.25)      // #141F40
    
    // Soft, smooth, eye-friendly matte ruby / crimson tones
    // Carefully calibrated to eliminate harsh glare and eye strain while preserving premium feel
    public static let primaryRed = Color(red: 0.73, green: 0.08, blue: 0.22)       // #BA1438 - soft matte ruby
    public static let primaryRedDark = Color(red: 0.55, green: 0.04, blue: 0.16)   // #8C0A29 - deep wine bordeaux
    
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
    
    // MARK: - Soft, Smooth, Eye-Friendly Gradients
    // Buttons: Smooth matte crimson, elegant, soft, and comfortable to look at
    public static let redButtonGradient = LinearGradient(
        colors: [
            Color(red: 0.74, green: 0.09, blue: 0.23), // #BD173B
            Color(red: 0.64, green: 0.05, blue: 0.18)  // #A30D2E
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Premium Card Rectangle: Soft, velvety, deep wine-ruby gradient from Figma (#A61233 -> #850826)
    // Completely soothing and easy on the eyes across large card surfaces
    public static let premiumCardGradient = LinearGradient(
        colors: [
            Color(red: 0.65, green: 0.07, blue: 0.20), // #A61233
            Color(red: 0.52, green: 0.03, blue: 0.15)  // #850826
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
