import Foundation

public enum AppEnvironment {
    case staging
    case production
}

public struct AppConfig {
    // Current active environment - switched to .production
    public static var currentEnvironment: AppEnvironment = .production

    public static var baseURL: String {
        switch currentEnvironment {
        case .staging:
            return "https://api-staging-labs.carawintech.com"
        case .production:
            return "https://api-labs.carawintech.com"
        }
    }

    public static var payUBaseURL: String {
        switch currentEnvironment {
        case .staging:
            return "https://test.payu.in"
        case .production:
            return "https://secure.payu.in"
        }
    }

    // MARK: - Google OAuth Configuration
    public static var googleClientID: String = "485328173144-77obcm8e0vshdqcsm3dc4gp7vsgt6aab.apps.googleusercontent.com"
    public static var googleRedirectScheme: String = "com.googleusercontent.apps.485328173144-77obcm8e0vshdqcsm3dc4gp7vsgt6aab"
}
