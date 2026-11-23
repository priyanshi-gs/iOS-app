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

    // MARK: - Google OAuth Configuration (Loaded dynamically from gitignored GoogleCredentials.plist)
    public static var googleClientID: String {
        loadCredential(key: "CLIENT_ID")
    }

    public static var googleRedirectScheme: String {
        loadCredential(key: "REVERSED_CLIENT_ID")
    }

    private static func loadCredential(key: String) -> String {
        if let path = Bundle.main.path(forResource: "GoogleCredentials", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let val = dict[key] as? String, !val.isEmpty {
            return val
        }
        let localPath = "/Users/ratnamsmac/Documents/Projects/LabLearn/STEM/Configuration/GoogleCredentials.plist"
        if let dict = NSDictionary(contentsOfFile: localPath) as? [String: Any],
           let val = dict[key] as? String, !val.isEmpty {
            return val
        }
        return ""
    }
}
