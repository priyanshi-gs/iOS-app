import SwiftUI

public struct SplashLoginView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Dark navy background with curved top accent
            Theme.navyBackground
                .ignoresSafeArea()
            
            // Background glowing science elements
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Theme.primaryRed.opacity(0.35))
                        .frame(width: 200, height: 200)
                        .blur(radius: 50)
                        .offset(x: 60, y: -40)
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Header Logo
                HStack(spacing: 8) {
                    Image(systemName: "flask.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.primaryRed)
                    Text("LabLearn")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Central Graphic Illustration
                ZStack {
                    // Outer glow rings
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        .frame(width: 240, height: 240)
                    Circle()
                        .stroke(Theme.primaryBlue.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 190, height: 190)
                    
                    // Central Flask Icon
                    VStack(spacing: 12) {
                        Image(systemName: "atom")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.primaryRed, Theme.primaryBlue, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Theme.primaryRed.opacity(0.5), radius: 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                
                // Tagline & Value Proposition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Virtual\nIntelligent\nScience Lab")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                    
                    Text("Interactive PCM labs, real experiments and guided learning for Classes 6 – 12.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.75))
                        .lineSpacing(3)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                // Auth Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.continueWithApple {
                            appState.navigate(to: .roleSelection)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 18))
                            Text("Continue with Apple")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        viewModel.continueWithEmail {
                            appState.navigate(to: .roleSelection)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 16))
                            Text("Continue with Email")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        appState.navigate(to: .roleSelection)
                    }) {
                        HStack(spacing: 4) {
                            Text("Create Account")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
    }
}
