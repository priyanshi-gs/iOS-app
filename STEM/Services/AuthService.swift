import Foundation
import Combine
import AuthenticationServices

public struct AuthUser: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var email: String
    public var role: String // "STUDENT" or "PARENT"
    public var schoolName: String?
    public var avatar: String?

    public init(
        id: String,
        name: String,
        email: String,
        role: String = "STUDENT",
        schoolName: String? = nil,
        avatar: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.schoolName = schoolName
        self.avatar = avatar
    }
}

public enum AuthState: Equatable {
    case unauthenticated
    case authenticating
    case authenticated(AuthUser)

    public var isAuthenticated: Bool {
        if case .authenticated = self { return true }
        return false
    }
}

@MainActor
public final class AuthService: ObservableObject {
    public static let shared = AuthService()

    @Published public private(set) var authState: AuthState = .unauthenticated
    @Published public private(set) var currentUser: AuthUser? = nil

    private let keychain = KeychainHelper.shared
    private let tokenKey = "auth_jwt_access_token"
    private let userKey = "auth_current_user_json"

    public init() {
        restoreSession()
    }

    // MARK: - Restore Cached Session
    public func restoreSession() {
        if let userData = keychain.readData(key: userKey),
           let user = try? JSONDecoder().decode(AuthUser.self, from: userData) {
            self.currentUser = user
            self.authState = .authenticated(user)
        } else {
            self.authState = .unauthenticated
            self.currentUser = nil
        }
    }

    // MARK: - Sign In with Apple
    public func handleAppleSignIn(
        userId: String,
        email: String?,
        fullName: PersonNameComponents?
    ) {
        let name: String
        if let fullName = fullName {
            let given = fullName.givenName ?? ""
            let family = fullName.familyName ?? ""
            let combined = "\(given) \(family)".trimmingCharacters(in: .whitespaces)
            name = combined.isEmpty ? "Samantha Taylor" : combined
        } else {
            name = "Samantha Taylor"
        }

        let userEmail = email ?? "samantha.taylor@carawin.edu"
        let user = AuthUser(
            id: userId,
            name: name,
            email: userEmail,
            role: "STUDENT",
            schoolName: "Springfield High School"
        )

        saveSession(user: user, token: "apple_token_\(UUID().uuidString)")
    }

    // MARK: - Email & Password Sign In
    public func signInWithEmail(email: String, password: String) async -> Result<AuthUser, Error> {
        authState = .authenticating

        // Simulate API network validation (or connect to ai-tutor backend)
        try? await Task.sleep(nanoseconds: 500_000_000)

        guard !email.isEmpty, !password.isEmpty else {
            authState = .unauthenticated
            return .failure(NSError(domain: "AuthService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email and password are required."]))
        }

        let user = AuthUser(
            id: UUID().uuidString,
            name: "Samantha Taylor",
            email: email.lowercased(),
            role: "STUDENT",
            schoolName: "Springfield High School"
        )

        saveSession(user: user, token: "jwt_token_\(UUID().uuidString)")
        return .success(user)
    }

    // MARK: - Registration
    public func register(
        name: String,
        email: String,
        password: String,
        role: String = "STUDENT"
    ) async -> Result<AuthUser, Error> {
        authState = .authenticating

        try? await Task.sleep(nanoseconds: 500_000_000)

        let user = AuthUser(
            id: UUID().uuidString,
            name: name,
            email: email.lowercased(),
            role: role,
            schoolName: "Springfield High School"
        )

        saveSession(user: user, token: "jwt_token_\(UUID().uuidString)")
        return .success(user)
    }

    // MARK: - Sign Out
    public func signOut() {
        keychain.delete(key: tokenKey)
        keychain.delete(key: userKey)
        currentUser = nil
        authState = .unauthenticated
    }

    // MARK: - Helpers
    private func saveSession(user: AuthUser, token: String) {
        keychain.save(key: tokenKey, string: token)
        if let encoded = try? JSONEncoder().encode(user) {
            keychain.save(key: userKey, data: encoded)
        }
        self.currentUser = user
        self.authState = .authenticated(user)
    }
}

