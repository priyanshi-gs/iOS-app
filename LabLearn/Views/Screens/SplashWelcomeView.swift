import SwiftUI

public struct SplashWelcomeView: View {
    public var onContinueWithApple: (() -> Void)? = nil
    public var onContinueWithEmail: (() -> Void)? = nil
    public var onCreateAccount: (() -> Void)? = nil
    
    public init(
        onContinueWithApple: (() -> Void)? = nil,
        onContinueWithEmail: (() -> Void)? = nil,
        onCreateAccount: (() -> Void)? = nil
    ) {
        self.onContinueWithApple = onContinueWithApple
        self.onContinueWithEmail = onContinueWithEmail
        self.onCreateAccount = onCreateAccount
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // MARK: - Background Artwork
                // High-resolution artwork provided by user with flask, red arc, and glow
                Image("splash_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // MARK: - Foreground UI Overlay
                VStack(alignment: .leading, spacing: 0) {
                    // 1. Top Brand Logo: Flask Icon + "LabLearn"
                    HStack(spacing: 8) {
                        Image(systemName: "flask")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("LabLearn")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 26)
                    
                    // 2. Main Headline Text (Positioned to flow alongside the background graphic)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Virtual")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Intelligent")
                            .font(.system(size: 34, weight: .black))
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
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Interactive PCM labs, real experiments and guided learning for Classes 6 – 12.")
                            .font(.system(size: 13.5, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.82))
                            .lineSpacing(4)
                            .padding(.top, 8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    // Keep width bounded so it never overlaps the beaker on the right
                    .frame(maxWidth: geo.size.width * 0.60, alignment: .leading)
                    .padding(.top, geo.size.height * 0.05)
                    .padding(.horizontal, 26)
                    
                    Spacer()
                    
                    // 3. Bottom Action Buttons
                    VStack(spacing: 13) {
                        // Continue with Apple Button
                        Button(action: {
                            onContinueWithApple?()
                        }) {
                            HStack(spacing: 9) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18))
                                Text("Continue with Apple")
                                    .font(.system(size: 15.5, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        
                        // Continue with Email Button
                        Button(action: {
                            onContinueWithEmail?()
                        }) {
                            HStack(spacing: 9) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                Text("Continue with Email")
                                    .font(.system(size: 15.5, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Theme.redButtonGradient)
                            .clipShape(Capsule())
                            .shadow(color: Theme.primaryRed.opacity(0.5), radius: 12, x: 0, y: 6)
                        }
                        
                        // Create Account Link
                        Button(action: {
                            onCreateAccount?()
                        }) {
                            HStack(spacing: 5) {
                                Text("Create Account")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.white.opacity(0.9))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundColor(Theme.accentGold)
                            }
                            .padding(.top, 6)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 28)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashWelcomeView()
}
