import SwiftUI

public struct ConnectSchoolView: View {
    @State private var referralCode: String = "EDU-PCM-2026"
    @State private var isVerifying: Bool = false
    @State private var isVerified: Bool = true
    @State private var errorMessage: String? = nil
    
    public var onBack: (() -> Void)? = nil
    public var onVerificationSuccess: (() -> Void)? = nil
    
    public init(
        initialCode: String = "EDU-PCM-2026",
        onBack: (() -> Void)? = nil,
        onVerificationSuccess: (() -> Void)? = nil
    ) {
        self._referralCode = State(initialValue: initialCode)
        self.onBack = onBack
        self.onVerificationSuccess = onVerificationSuccess
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "Connect School",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Headline Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Connect your school")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Theme.textDark)
                        
                        Text("Enter the referral code provided by your school to verify your access.")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 16)
                    
                    // Code Input Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("School Referral Code")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .textCase(.uppercase)
                        
                        HStack {
                            TextField("e.g. EDU-PCM-2026", text: $referralCode)
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .textInputAutocapitalization(.characters)
                                .disableAutocorrection(true)
                            
                            Image(systemName: "viewfinder")
                                .font(.system(size: 16))
                                .foregroundColor(Theme.textMuted)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isVerified ? Theme.accentGreen : Theme.borderLight, lineWidth: isVerified ? 1.5 : 1)
                        )
                    }
                    
                    // Error message if any
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.primaryRed)
                    }
                    
                    // Verify Code Action Button
                    Button(action: {
                        verifyCode()
                    }) {
                        HStack(spacing: 8) {
                            if isVerifying {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Verify Code")
                                    .font(.system(size: 16, weight: .bold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .heavy))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                        .shadow(color: Theme.primaryRed.opacity(0.35), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isVerifying)
                    
                    // Verification Status Card (Matching Figma)
                    if isVerified {
                        CardContainer(padding: 16) {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.accentGreen)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("School entitlement checked")
                                            .font(.system(size: 14.5, weight: .bold))
                                            .foregroundColor(Theme.textDark)
                                        Text("Your school has active LabLearn access")
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.textMuted)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Divider()
                                
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
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
    
    private func verifyCode() {
        guard !referralCode.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your referral code."
            return
        }
        
        isVerifying = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isVerifying = false
            isVerified = true
            onVerificationSuccess?()
        }
    }
}

public struct EntitlementCheckItem: View {
    public let text: String
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.accentGreen)
            
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textDark)
            
            Spacer()
        }
    }
}

#Preview {
    ConnectSchoolView()
}

