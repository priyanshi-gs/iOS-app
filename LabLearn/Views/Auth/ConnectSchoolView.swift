import SwiftUI

public struct ConnectSchoolView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SchoolConnectViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Connect School",
                showBackButton: true,
                onBack: { appState.navigate(to: .roleSelection) }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Connect your school")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        Text("Enter the referral code provided by your school to verify your access.")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 16)
                    
                    // Code Input Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("School Referral Code")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.textMuted)
                        
                        HStack {
                            TextField("e.g. EDU-PCM-2026", text: $viewModel.referralCode)
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .textInputAutocapitalization(.characters)
                                .disableAutocorrection(true)
                            
                            Image(systemName: "viewfinder")
                                .foregroundColor(Theme.textMuted)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.borderLight, lineWidth: 1)
                        )
                    }
                    
                    // Verify Button
                    PrimaryButton(
                        "Verify Code",
                        isLoading: viewModel.isVerifying
                    ) {
                        viewModel.verifyCode { success in
                            if success {
                                appState.completeSchoolConnection()
                            }
                        }
                    }
                    
                    // Verification Card
                    if viewModel.isVerified {
                        CardContainer {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Theme.accentGreen)
                                        .font(.system(size: 20))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("School entitlement checked")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Theme.textDark)
                                        Text("Your school has active LabLearn access")
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.textMuted)
                                    }
                                }
                                
                                Divider()
                                
                                Text("Your Access")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textMuted)
                                    .textCase(.uppercase)
                                
                                EntitlementCheckRow("Access to entitled labs")
                                EntitlementCheckRow("Complete experiments & assessments")
                                EntitlementCheckRow("Track your learning progress")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct SchoolConnectedSuccessView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(title: "School Connected")
            
            VStack(spacing: 24) {
                Spacer()
                
                // School Graphic
                ZStack {
                    Circle()
                        .fill(Theme.accentGreen.opacity(0.12))
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 4) {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 44))
                            .foregroundColor(Theme.primaryBlue)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Theme.accentGreen)
                            .offset(y: -8)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("School Connected\nSuccessfully!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.textDark)
                        .multilineTextAlignment(.center)
                    
                    Text("You are now linked with your school and have access to LabLearn resources.")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Verified Badge Card
                HStack(spacing: 12) {
                    Image(systemName: "graduationcap.fill")
                        .foregroundColor(Theme.accentGreen)
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appState.activeSchool.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        Text("Institutional Access Active")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    Spacer()
                    
                    Text("Linked")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.accentGreen)
                        .padding(.horizontal, 8)
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
                
                // Entitlement list
                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Access")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .textCase(.uppercase)
                        
                        EntitlementCheckRow("Access to entitled labs")
                        EntitlementCheckRow("Complete experiments & assessments")
                        EntitlementCheckRow("Track your learning progress")
                    }
                }
                
                Spacer()
                
                PrimaryButton("Go to Dashboard") {
                    appState.enterMainApp()
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}
