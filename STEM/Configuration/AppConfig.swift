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
}
