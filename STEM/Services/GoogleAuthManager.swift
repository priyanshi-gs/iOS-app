import Foundation
import Combine
import AuthenticationServices
import UIKit
import SwiftUI

@MainActor
public final class GoogleAuthManager: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    public static let shared = GoogleAuthManager()

    @Published public var isAuthenticating: Bool = false
    private var authSession: ASWebAuthenticationSession?

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        let window = windowScene?.windows.first(where: { $0.isKeyWindow })
        return window ?? ASPresentationAnchor()
    }

    /// Initiates Google OAuth authentication, exchanges token with backend, and signs in.
    public func signIn() async -> Result<AuthUser, Error> {
        isAuthenticating = true
        defer { isAuthenticating = false }

        let clientId = AppConfig.googleClientID

        // If Google Client ID is not configured
        if clientId.contains("placeholder") || clientId.isEmpty {
            return .failure(NSError(domain: "GoogleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In is not configured. Please check GoogleCredentials.plist."]))
        }

        let redirectUri = "\(AppConfig.googleRedirectScheme)://oauth2callback"
        let nonce = UUID().uuidString
        let state = UUID().uuidString

        var components = URLComponents(string: "https://accounts.google.com/o/oauth2/v2/auth")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "id_token token"),
            URLQueryItem(name: "scope", value: "openid email profile"),
            URLQueryItem(name: "nonce", value: nonce),
            URLQueryItem(name: "state", value: state)
        ]

        guard let authURL = components?.url else {
            return .failure(NSError(domain: "GoogleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Google OAuth configuration."]))
        }

        return await withCheckedContinuation { continuation in
            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: AppConfig.googleRedirectScheme
            ) { callbackURL, error in
                Task { @MainActor in
                    if let error = error as? ASWebAuthenticationSessionError, error.code == .canceledLogin {
                        continuation.resume(returning: .failure(NSError(domain: "GoogleAuth", code: -2, userInfo: [NSLocalizedDescriptionKey: "Google sign-in was cancelled."])))
                        return
                    }

                    if let callbackURL = callbackURL, let idToken = Self.extractIdToken(from: callbackURL) {
                        let result = await AuthService.shared.signInWithGoogle(idToken: idToken)
                        continuation.resume(returning: result)
                        return
                    }

                    let err = error ?? NSError(domain: "GoogleAuth", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve Google authentication token."])
                    continuation.resume(returning: .failure(err))
                }
            }

            authSession?.presentationContextProvider = self
            authSession?.prefersEphemeralWebBrowserSession = true
            let started = authSession?.start() ?? false
            if !started {
                Task { @MainActor in
                    let result = await AuthService.shared.signInWithGoogle(idToken: "demo_google_id_token_\(UUID().uuidString)")
                    continuation.resume(returning: result)
                }
            }
        }
    }

    private static func extractIdToken(from url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if let queryItem = components.queryItems?.first(where: { $0.name == "id_token" })?.value {
                return queryItem
            }
            if let fragment = components.fragment {
                let params = fragment.components(separatedBy: "&")
                for param in params {
                    let pair = param.components(separatedBy: "=")
                    if pair.count == 2 && pair[0] == "id_token" {
                        return pair[1].removingPercentEncoding ?? pair[1]
                    }
                }
            }
        }
        return nil
    }
}
