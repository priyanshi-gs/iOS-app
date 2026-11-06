import SwiftUI

public struct SchoolConnectedSuccessView: View {
    public var schoolName: String = "Chaplin Pre-University (CPU)"
    public var onBack: (() -> Void)? = nil
    public var onGoToDashboard: (() -> Void)? = nil
    
    public init(
        schoolName: String = "Chaplin Pre-University (CPU)",
        onBack: (() -> Void)? = nil,
        onGoToDashboard: (() -> Void)? = nil
    ) {
        self.schoolName = schoolName
        self.onBack = onBack
        self.onGoToDashboard = onGoToDashboard
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "School Connected",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    // Hero School Building & Checkmark Graphic
                    ZStack {
                        Circle()
                            .fill(Theme.accentGreen.opacity(0.12))
                            .frame(width: 96, height: 96)
                        
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Theme.primaryBlue)
                        
                        // Checkmark Seal
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 26))
                            .foregroundColor(Theme.accentGreen)
                            .background(Color.white.clipShape(Circle()))
                            .offset(x: 24, y: 24)
                    }
                    .padding(.top, 16)
                    
                    // Headings
                    VStack(spacing: 6) {
                        Text("School Connected\nSuccessfully!")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Theme.textDark)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                        
                        Text("You are now linked with your school and have access to LabLearn resources.")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    
                    // Linked School Card
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Theme.accentGreen.opacity(0.12))
                                .frame(width: 40, height: 40)
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Theme.accentGreen)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(schoolName)
                                .font(.system(size: 14.5, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            Text("Institutional Access Active")
                                .font(.system(size: 11.5))
                                .foregroundColor(Theme.textMuted)
                        }
                        
                        Spacer()
                        
                        Text("Linked")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Theme.accentGreen)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(Theme.accentGreen.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.borderLight, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Access Entitlement Checklist
                    CardContainer(padding: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Access")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.textMuted)
                                .textCase(.uppercase)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                EntitlementCheckItem(text: "Access to entitled labs")
                                EntitlementCheckItem(text: "Complete experiments & assessments")
                                EntitlementCheckItem(text: "Track your learning progress")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 10)
                    
                    // Action Button: Go to Dashboard
                    Button(action: {
                        onGoToDashboard?()
                    }) {
                        HStack(spacing: 8) {
                            Text("Go to Dashboard")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                        .shadow(color: Theme.primaryRed.opacity(0.35), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

#Preview {
    SchoolConnectedSuccessView()
}

