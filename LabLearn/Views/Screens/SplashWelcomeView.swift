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
            let topInset = max(geo.safeAreaInsets.top, 50)
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
                
                // MARK: - Foreground UI Overlay
                VStack(alignment: .leading, spacing: 0) {
                    // 1. Top Brand Header: Flask Icon + "LabLearn"
                    // Positioned safely below the status bar clock and notch/Dynamic Island
                    HStack(spacing: 8) {
                        Image(systemName: "flask")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("LabLearn")
                            .font(.system(size: 23, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    .padding(.top, topInset + 6)
                    .padding(.horizontal, 28)
                    
                    // 2. Main Headline Text
                    // Positioned cleanly BELOW the background's yellow dash so it never overlaps or collides
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Virtual")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Intelligent")
                            .font(.system(size: 32, weight: .black))
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
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Interactive PCM labs, real experiments and guided learning for Classes 6 – 12.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.82))
                            .lineSpacing(3.5)
                            .padding(.top, 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: screenWidth * 0.58, alignment: .leading)
                    // Offset down so the background's yellow dash sits above "Your Virtual"
                    .padding(.top, screenHeight * 0.085)
                    .padding(.horizontal, 28)
                    
                    Spacer()
                    
                    // 3. Bottom Action Buttons
                    VStack(spacing: 12) {
                        // Continue with Apple
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
                            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                        }
                        
                        // Continue with Email
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
                            .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 24))
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashWelcomeView()
}
