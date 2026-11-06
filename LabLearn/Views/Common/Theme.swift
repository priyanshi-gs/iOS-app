import SwiftUI

public enum Theme {
    // Brand Colors
    public static let navyBackground = Color(red: 0.05, green: 0.08, blue: 0.18) // #0D142E
    public static let navySurface = Color(red: 0.09, green: 0.13, blue: 0.28)    // #172147
    public static let primaryRed = Color(red: 0.90, green: 0.18, blue: 0.28)     // #E62E47
    public static let primaryRedDark = Color(red: 0.78, green: 0.12, blue: 0.22)
    public static let primaryBlue = Color(red: 0.20, green: 0.45, blue: 0.96)    // #3373F5
    public static let accentGreen = Color(red: 0.10, green: 0.75, blue: 0.45)    // #1AC073
    public static let accentYellow = Color(red: 0.98, green: 0.72, blue: 0.15)   // #FAB826
    
    // Neutrals
    public static let screenBackground = Color(red: 0.96, green: 0.97, blue: 0.99) // #F5F7FC
    public static let cardBackground = Color.white
    public static let textDark = Color(red: 0.08, green: 0.11, blue: 0.18)         // #141C2E
    public static let textMuted = Color(red: 0.45, green: 0.50, blue: 0.60)        // #738099
    public static let textLight = Color.white
    public static let borderLight = Color(red: 0.90, green: 0.92, blue: 0.96)      // #E6EBF5
    
    // Gradients
    public static let headerNavyGradient = LinearGradient(
        colors: [navyBackground, navySurface],
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let redButtonGradient = LinearGradient(
        colors: [primaryRed, Color(red: 0.98, green: 0.28, blue: 0.38)],
        startPoint: .leading,
        endPoint: .trailing
    )
}
