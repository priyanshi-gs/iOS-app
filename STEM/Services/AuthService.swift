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
    public var mobile: String?
    public var planName: String?
    public var planStatus: String?
    public var accountType: String?

    public init(
        id: String,
        name: String,
        email: String,
        role: String = "STUDENT",
        schoolName: String? = nil,
        avatar: String? = nil,
        mobile: String? = nil,
        planName: String? = nil,
        planStatus: String? = nil,
        accountType: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.schoolName = schoolName
        self.avatar = avatar
        self.mobile = mobile
        self.planName = planName
        self.planStatus = planStatus
        self.accountType = accountType
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
            name = combined.isEmpty ? "Student" : combined
        } else {
            name = "Student"
        }

        let userEmail = email ?? "student@labs.carawin.edu"
        let user = AuthUser(
            id: userId,
            name: name,
            email: userEmail,
            role: "STUDENT",
            schoolName: nil
        )

        saveSession(user: user, token: "apple_token_\(UUID().uuidString)")
    }

    // MARK: - Sign In with Google (POST /api/v1/auth/google)
    public func signInWithGoogle(idToken: String) async -> Result<AuthUser, Error> {
        authState = .authenticating
        let csrf = await fetchCsrfToken()
        let endpoints = ["/api/v1/auth/google", "/auth/google"]
        var lastError: Error?

        for endpoint in endpoints {
            guard let url = URL(string: "\(AppConfig.baseURL)\(endpoint)") else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let csrf = csrf {
                request.setValue(csrf, forHTTPHeaderField: "X-CSRF-Token")
            }

            let bodyDict: [String: Any] = ["idToken": idToken]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    if let user = parseAuthResponse(from: data, fallbackEmail: "") {
                        // Refresh live details from /me if available
                        try? await fetchMeLive()
                        return .success(currentUser ?? user)
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                    let errMsg = parseErrorMessage(from: data) ?? "Google sign-in failed. Please try again."
                    authState = .unauthenticated
                    return .failure(NSError(domain: "AuthService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errMsg]))
                }
            } catch {
                lastError = error
            }
        }

        authState = .unauthenticated
        let error = lastError ?? NSError(
            domain: "AuthService",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to connect to authentication server. Please check your internet connection."]
        )
        return .failure(error)
    }

    // MARK: - Email & Password Sign In
    public func signInWithEmail(email: String, password: String) async -> Result<AuthUser, Error> {
        authState = .authenticating

        guard !email.isEmpty, !password.isEmpty else {
            authState = .unauthenticated
            return .failure(NSError(domain: "AuthService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email and password are required."]))
        }

        let csrf = await fetchCsrfToken()

        // Try standard backend endpoints
        let endpoints = ["/api/v1/auth/login", "/auth/login", "/api/auth/login"]
        var lastError: Error?

        for endpoint in endpoints {
            guard let url = URL(string: "\(AppConfig.baseURL)\(endpoint)") else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let csrf = csrf {
                request.setValue(csrf, forHTTPHeaderField: "X-CSRF-Token")
            }

            let bodyDict: [String: Any] = [
                "email": email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                "password": password
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    if let user = parseAuthResponse(from: data, fallbackEmail: email) {
                        return .success(user)
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 || httpResponse.statusCode == 400 || httpResponse.statusCode == 403 {
                    let errMsg = parseErrorMessage(from: data) ?? "Invalid credentials. Please check your email and password."
                    authState = .unauthenticated
                    return .failure(NSError(domain: "AuthService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errMsg]))
                }
            } catch {
                lastError = error
            }
        }

        // If no endpoint succeeded, report the exact failure
        authState = .unauthenticated
        let error = lastError ?? NSError(
            domain: "AuthService",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to connect to authentication server. Please check your internet connection."]
        )
        return .failure(error)
    }

    private func fetchCsrfToken() async -> String? {
        guard let url = URL(string: "\(AppConfig.baseURL)/api/v1/auth/csrf") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let (data, response) = try? await URLSession.shared.data(for: request),
           let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return json["csrfToken"] as? String
        }
        return nil
    }

    // MARK: - Registration
    public func register(
        name: String,
        email: String,
        password: String,
        mobile: String = "9876543210",
        role: String = "STUDENT"
    ) async -> Result<AuthUser, Error> {
        authState = .authenticating

        let csrf = await fetchCsrfToken()
        let endpoints = ["/api/v1/auth/register", "/auth/register"]
        var lastError: Error?

        for endpoint in endpoints {
            guard let url = URL(string: "\(AppConfig.baseURL)\(endpoint)") else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let csrf = csrf {
                request.setValue(csrf, forHTTPHeaderField: "X-CSRF-Token")
            }

            let finalMobile = mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "9876543210" : mobile.trimmingCharacters(in: .whitespacesAndNewlines)
            let bodyDict: [String: Any] = [
                "name": name.trimmingCharacters(in: .whitespacesAndNewlines),
                "email": email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                "password": password,
                "mobile": finalMobile,
                "role": role,
                "accountType": "INDIVIDUAL"
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    authState = .unauthenticated
                    let user = AuthUser(
                        id: UUID().uuidString,
                        name: name,
                        email: email,
                        role: role
                    )
                    return .success(user)
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                    let errMsg = parseErrorMessage(from: data) ?? "Registration failed. Please try again."
                    authState = .unauthenticated
                    return .failure(NSError(domain: "AuthService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errMsg]))
                }
            } catch {
                lastError = error
            }
        }

        // If registration failed, return the exact network/server error
        authState = .unauthenticated
        let error = lastError ?? NSError(
            domain: "AuthService",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Unable to complete registration. Server unreachable."]
        )
        return .failure(error)
    }

    // MARK: - Response Parsing Helpers
    private func parseAuthResponse(
        from data: Data,
        fallbackEmail: String,
        fallbackName: String = "Student",
        role: String = "STUDENT"
    ) -> AuthUser? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }

        // Find token
        guard let token = (json["token"] as? String)
            ?? (json["accessToken"] as? String)
            ?? ((json["data"] as? [String: Any])?["token"] as? String)
            ?? ((json["data"] as? [String: Any])?["accessToken"] as? String) else {
            return nil
        }

        // Find user data
        let userDict = (json["user"] as? [String: Any])
            ?? (json["data"] as? [String: Any])
            ?? json

        let id = (userDict["id"] as? String) ?? (userDict["_id"] as? String) ?? UUID().uuidString
        let name = (userDict["name"] as? String) ?? fallbackName
        let email = (userDict["email"] as? String) ?? fallbackEmail
        let userRole = (userDict["role"] as? String)
            ?? (userDict["roles"] as? [String])?.first
            ?? role
        let school = (userDict["schoolName"] as? String)
            ?? ((userDict["schools"] as? [[String: Any]])?.first?["name"] as? String)

        let user = AuthUser(id: id, name: name, email: email, role: userRole, schoolName: school)
        saveSession(user: user, token: token)
        return user
    }

    private func parseErrorMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        if let errObj = json["error"] as? [String: Any], let msg = errObj["message"] as? String {
            return msg
        }
        if let errStr = json["error"] as? String {
            return errStr
        }
        if let msg = json["message"] as? String {
            return msg
        }
        return nil
    }

    // MARK: - School Code Verification (POST /api/v1/schools/enroll)
    public func verifySchoolCode(code: String) async -> (isValid: Bool, schoolName: String?) {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !trimmed.isEmpty else { return (false, nil) }

        let csrf = await fetchCsrfToken()
        let endpoints = ["/api/v1/schools/enroll", "/api/v1/schools/verify", "/schools/verify"]

        for endpoint in endpoints {
            guard let url = URL(string: "\(AppConfig.baseURL)\(endpoint)") else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let csrf = csrf {
                request.setValue(csrf, forHTTPHeaderField: "X-CSRF-Token")
            }

            // Include JWT Bearer token if available
            if let token = keychain.readString(key: tokenKey) {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let body: [String: Any] = ["code": trimmed, "referralCode": trimmed]
            if let bodyData = try? JSONSerialization.data(withJSONObject: body) {
                request.httpBody = bodyData
                if let (data, response) = try? await URLSession.shared.data(for: request),
                   let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let school = (json["schoolName"] as? String)
                            ?? (json["name"] as? String)
                            ?? ((json["school"] as? [String: Any])?["name"] as? String)
                            ?? ((json["data"] as? [String: Any])?["schoolName"] as? String)
                            ?? "Enrolled School"

                        // Update current user session with live school details
                        if var user = self.currentUser {
                            let updatedUser = AuthUser(
                                id: user.id,
                                name: user.name,
                                email: user.email,
                                role: user.role,
                                schoolName: school,
                                avatar: user.avatar,
                                mobile: user.mobile,
                                planName: "School Enterprise",
                                planStatus: "ACTIVE",
                                accountType: "School Enrolled"
                            )
                            saveSession(user: updatedUser, token: keychain.readString(key: tokenKey) ?? "")
                        }

                        return (true, school)
                    }
                }
            }
        }

        // Strictly return false if the server did not verify
        return (false, nil)
    }

    // MARK: - Active Session Token (100% Mandatory Auth)
    public func ensureActiveToken() -> String? {
        keychain.readString(key: tokenKey)
    }

    // MARK: - Live User Profile (GET /api/v1/auth/me)
    @discardableResult
    public func fetchMeLive() async throws -> AuthUser {
        let token = await ensureActiveToken()
        guard let token = token else {
            throw URLError(.userAuthenticationRequired)
        }

        guard let url = URL(string: "\(AppConfig.baseURL)/api/v1/auth/me") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                await MainActor.run {
                    self.signOut()
                }
            }
            throw URLError(.badServerResponse)
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }

        let userDict = (json["user"] as? [String: Any]) ?? (json["data"] as? [String: Any]) ?? json
        let id = (userDict["id"] as? String) ?? (userDict["_id"] as? String) ?? UUID().uuidString
        let name = (userDict["name"] as? String) ?? currentUser?.name ?? "Learner"
        let email = (userDict["email"] as? String) ?? currentUser?.email ?? ""
        let mobile = userDict["mobile"] as? String
        
        var schoolName: String? = nil
        if let schools = userDict["schools"] as? [[String: Any]], let firstSchool = schools.first {
            schoolName = firstSchool["name"] as? String
        }
        if schoolName == nil {
            schoolName = userDict["schoolName"] as? String
        }

        let roles = userDict["roles"] as? [String]
        let role = roles?.first ?? (userDict["role"] as? String) ?? "STUDENT"

        // Also fetch live subscription plan details: GET /api/v1/subscriptions/current
        var livePlanName = "Free Tier"
        var livePlanStatus = "ACTIVE"
        var accountType = schoolName != nil ? "School Enrolled" : "Individual Account"

        if let subUrl = URL(string: "\(AppConfig.baseURL)/api/v1/subscriptions/current") {
            var subReq = URLRequest(url: subUrl)
            subReq.httpMethod = "GET"
            subReq.setValue("application/json", forHTTPHeaderField: "Accept")
            subReq.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            if let (subData, subResp) = try? await URLSession.shared.data(for: subReq),
               let subHttp = subResp as? HTTPURLResponse, (200...299).contains(subHttp.statusCode),
               let subJson = try? JSONSerialization.jsonObject(with: subData) as? [String: Any] {
                
                let kind = subJson["kind"] as? String
                if kind == "SCHOOL", let sub = subJson["subscription"] as? [String: Any] {
                    livePlanName = (sub["plan"] as? String) ?? "School Enterprise"
                    livePlanStatus = (sub["status"] as? String) ?? "ACTIVE"
                    accountType = "School Account"
                } else if let subs = subJson["subscriptions"] as? [[String: Any]], let activeSub = subs.first {
                    livePlanName = (activeSub["plan"] as? String) ?? "Pro Plan"
                    livePlanStatus = (activeSub["status"] as? String) ?? "ACTIVE"
                    accountType = "Individual Pro"
                }
            }
        }

        let liveUser = AuthUser(
            id: id,
            name: name,
            email: email,
            role: role,
            schoolName: schoolName,
            avatar: nil,
            mobile: mobile,
            planName: livePlanName,
            planStatus: livePlanStatus,
            accountType: accountType
        )

        // Save updated session
        if let encoded = try? JSONEncoder().encode(liveUser) {
            keychain.save(key: userKey, data: encoded)
        }
        self.currentUser = liveUser
        self.authState = .authenticated(liveUser)

        return liveUser
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

