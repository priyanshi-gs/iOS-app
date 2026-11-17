import SwiftUI

public struct SplashWelcomeView: View {
    public var onContinue: (() -> Void)? = nil
    public var onContinueWithApple: (() -> Void)? = nil
    public var onContinueWithGoogle: (() -> Void)? = nil
    public var onCreateAccount: (() -> Void)? = nil

    @State private var emailOrName: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var isGoogleSigningIn: Bool = false
    @State private var errorMessage: String? = nil

    public init(
        onContinue: (() -> Void)? = nil,
        onContinueWithApple: (() -> Void)? = nil,
        onContinueWithGoogle: (() -> Void)? = nil,
        onCreateAccount: (() -> Void)? = nil
    ) {
        self.onContinue = onContinue
        self.onContinueWithApple = onContinueWithApple
        self.onContinueWithGoogle = onContinueWithGoogle
        self.onCreateAccount = onCreateAccount
    }

    public var body: some View {
        GeometryReader { geo in
            let screenHeight = geo.size.height
            let screenWidth = geo.size.width
            // Calculate exact position of the yellow bar in the background image
            // In the 505x1024 artwork, the yellow bar starts at Y = 170.0
            let yellowBarTopY = screenHeight * (170.0 / 1024.0)
            let logoHeight: CGFloat = 30.0
            let spacingToYellowBar: CGFloat = 4.0
            let logoTopPadding = max(yellowBarTopY - logoHeight - spacingToYellowBar, 20)

            ZStack(alignment: .topLeading) {
                // MARK: - Background Artwork
                Image("splash_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight)
                    .clipped()
                    .ignoresSafeArea()

                // Subtle gradient overlay to guarantee text legibility
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.15),
                        Color.clear,
                        Color.black.opacity(0.65)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // MARK: - Foreground UI Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // 1. Top Brand Header: Flask Icon + "STEM"
                        HStack(spacing: 4) {
                            Image(systemName: "flask")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)

                            Text("STEM")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                        }
                        .frame(height: logoHeight, alignment: .bottom)
                        .padding(.top, logoTopPadding)
                        .padding(.horizontal, 24)

                        // 2. Main Headline Text
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Your Virtual")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(.white)

                            Text("Intelligent")
                                .font(.system(size: 30, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Theme.accentGold,
                                            Color(red: 1.0, green: 0.88, blue: 0.40)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("Science Lab")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(.white)

                            Text("Interactive PCM labs,")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.85))
                                .padding(.top, 8)

                            // Separator with OR
//                            HStack {
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.5))
//                                    .frame(height: 1)
//                                Text("OR")
//                                    .font(.system(size: 14, weight: .medium))
//                                    .foregroundColor(.gray)
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.5))
//                                    .frame(height: 1)
//                            }
//                            .padding(.vertical, 12)
                            Text("real experiments and ")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.85))
                            Text("guided learning for Classes 6 – 12.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.85))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 60) // increased spacing after logo
                        .padding(.horizontal, 24)

                        Spacer(minLength: 8)
                            .frame(maxHeight: 130)

                        // 3. User Login Form Section
                        VStack(spacing: 8) {
                            // Unified Email & Password Card
                            VStack(spacing: 0) {
                                // Email / Name field
                                HStack(spacing: 10) {
                                    Image(systemName: "envelope.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(width: 18)

                                    TextField(
                                        "",
                                        text: $emailOrName,
                                        prompt: Text("Name or Email")
                                            .foregroundColor(.white.opacity(0.6))
                                    )
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                    .tint(.white)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 48)

                                // Divider
                                Rectangle()
                                    .fill(Color(hex: "D1D5DB"))
                                    .frame(height: 1)
                                    .padding(.horizontal, 15)

                                // Password field with eye toggle
                                HStack(spacing: 10) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(width: 18)

                                    if isPasswordVisible {
                                        TextField(
                                            "",
                                            text: $password,
                                            prompt: Text("Password")
                                                .foregroundColor(.white.opacity(0.6))
                                        )
                                            .font(.system(size: 15))
                                            .foregroundColor(.primary)
                                            .autocorrectionDisabled()
                                            .textInputAutocapitalization(.never)
                                    } else {
                                        SecureField(
                                            "",
                                            text: $password,
                                            prompt: Text("Password")
                                                .foregroundColor(.white.opacity(0.6))
                                        )
                                            .font(.system(size: 15))
                                            .foregroundColor(.primary)
                                            .autocorrectionDisabled()
                                            .textInputAutocapitalization(.never)
                                    }

                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color(hex: "64748B"))
                                            .padding(4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 48)
                            }
                            .background(.ultraThinMaterial.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)

                            // Forgot Password Button (right‑aligned)
                            HStack {
                                Spacer()
                                Button(action: {
                                    // TODO: implement forgot password flow
                                }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color.blue)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.top, 6)
                            // Error Message Banner (if login failed)
                            if let error = errorMessage {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 13))
                                    Text(error)
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(Color(hex: "FF6B6B"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(8)
                                .padding(.top, 4)
                            }

                            // Sign In Action Button (Live Backend Authentication)
                            Button(action: {
                                let email = emailOrName.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !email.isEmpty, !password.isEmpty else {
                                    errorMessage = "Please enter both email and password."
                                    return
                                }
                                isSigningIn = true
                                errorMessage = nil

                                Task {
                                    let result = await AuthService.shared.signInWithEmail(email: email, password: password)
                                    await MainActor.run {
                                        isSigningIn = false
                                        switch result {
                                        case .success:
                                            onContinue?()
                                        case .failure(let error):
                                            errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                            }) {
                                HStack(spacing: 8) {
                                    if isSigningIn {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(0.9)
                                    } else {
                                        Text("Sign In")
                                            .font(.system(size: 16, weight: .bold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 14, weight: .heavy))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Theme.redButtonGradient)
                                .clipShape(Capsule())
                                .shadow(color: Theme.primaryRed.opacity(0.25), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(isSigningIn)
                            .padding(.top, 8)

                            // Separator with OR
                            HStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 1)
                                Text("OR")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 1)
                            }
                            .padding(.vertical, 4)

                            // Continue with Apple & Continue with Google (Side by Side in an HStack)
                            HStack(spacing: 10) {
                                // Continue with Apple Button
                                Button(action: {
                                    AuthService.shared.handleAppleSignIn(
                                        userId: UUID().uuidString,
                                        email: "apple.user@carawin.edu",
                                        fullName: nil
                                    )
                                    onContinueWithApple?()
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "apple.logo")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Continue with Apple")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Capsule())
                                    .shadow(color: Color.black.opacity(0.14), radius: 6, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(isSigningIn || isGoogleSigningIn)

                                // Continue with Google Button
                                Button(action: {
                                    guard !isGoogleSigningIn && !isSigningIn else { return }
                                    isGoogleSigningIn = true
                                    errorMessage = nil
                                    Task {
                                        let result = await GoogleAuthManager.shared.signIn()
                                        await MainActor.run {
                                            isGoogleSigningIn = false
                                            switch result {
                                            case .success:
                                                onContinueWithGoogle?()
                                            case .failure(let error):
                                                errorMessage = error.localizedDescription
                                            }
                                        }
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        if isGoogleSigningIn {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "g.circle.fill")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Color(hex: "EA4335"))
                                        }
                                        Text(isGoogleSigningIn ? "Signing In…" : "Continue with Google")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Capsule())
                                    .shadow(color: Color.black.opacity(0.14), radius: 6, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(isGoogleSigningIn || isSigningIn)
                            }
                            .padding(.top, 8)

                            

                            // Below Social Buttons: "New User ? Create Account"
                            Button(action: {
                                onCreateAccount?()
                            }) {
                                HStack(spacing: 5) {
                                    Text("New User ?")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color.white.opacity(0.88))

                                    Text("Create Account")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.accentGold)

                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.accentGold)
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 8)

                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, max(geo.safeAreaInsets.bottom, 24) + 12)
                    }
                    .frame(minHeight: screenHeight, alignment: .top)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashWelcomeView(
        onContinue: {
            print("Continue tapped")
        },
        onContinueWithApple: {
            print("Apple Sign In tapped")
        },
        onContinueWithGoogle: {
            print("Google Sign In tapped")
        },
        onCreateAccount: {
            print("Create Account tapped")
        }
    )
}
