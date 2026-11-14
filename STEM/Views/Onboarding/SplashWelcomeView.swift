import SwiftUI

public struct SplashWelcomeView: View {
    public var onContinue: (() -> Void)? = nil
    public var onContinueWithApple: (() -> Void)? = nil
    public var onContinueWithGoogle: (() -> Void)? = nil
    public var onCreateAccount: (() -> Void)? = nil

    @State private var emailOrName: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

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
                        HStack(spacing: 8) {
                            Image(systemName: "flask")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)

                            Text("STEM")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                        }
                        .padding(.top, max(geo.safeAreaInsets.top, 20) + 12)
                        .padding(.horizontal, 24)

                        // 2. Main Headline Text
                        VStack(alignment: .leading, spacing: 3) {
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

                            Text("Interactive PCM labs, real experiments and guided learning for Classes 6 – 12.")
                                .font(.system(size: 12.5, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.85))
                                .lineSpacing(3)
                                .padding(.top, 4)
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 24)

                        Spacer(minLength: 24)

                        // 3. User Login Form Section
                        VStack(spacing: 12) {
                            // Name or Email Input Field
                            HStack(spacing: 10) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "64748B"))
                                    .frame(width: 18)

                                TextField("Name or Email", text: $emailOrName)
                                    .font(.system(size: 15))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)

                            // Password Input Field (with eye button show/hide)
                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "64748B"))
                                    .frame(width: 18)

                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .font(.system(size: 15))
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Password", text: $password)
                                        .font(.system(size: 15))
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                }

                                // Eye button to toggle password visibility
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
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)

                            // Continue Button
                            Button(action: {
                                onContinue?()
                            }) {
                                HStack(spacing: 8) {
                                    Text("Continue")
                                        .font(.system(size: 16, weight: .bold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .heavy))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Theme.redButtonGradient)
                                .clipShape(Capsule())
                                .shadow(color: Theme.primaryRed.opacity(0.25), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 4)

                            // Continue with Apple & Continue with Google (Side by Side in an HStack)
                            HStack(spacing: 10) {
                                // Continue with Apple Button
                                Button(action: {
                                    onContinueWithApple?()
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "apple.logo")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Apple")
                                            .font(.system(size: 14.5, weight: .bold))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .shadow(color: Color.black.opacity(0.14), radius: 6, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())

                                // Continue with Google Button
                                Button(action: {
                                    onContinueWithGoogle?()
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "g.circle.fill")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(hex: "EA4335"))
                                        Text("Google")
                                            .font(.system(size: 14.5, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .shadow(color: Color.black.opacity(0.14), radius: 6, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.top, 2)

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
                            .padding(.top, 2)
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, max(geo.safeAreaInsets.bottom, 24) + 12)
                    }
                    .frame(minHeight: screenHeight)
                }
            }
        }
        .ignoresSafeArea()
    }
}
