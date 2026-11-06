import SwiftUI

public struct StudentProfileView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingBadges: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Student Profile",
                height: 110
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Profile Avatar Card
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.navyBackground)
                                .frame(width: 70, height: 70)
                            Text(viewModel.student.initials)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(viewModel.student.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        Text("\(viewModel.student.grade) • \(viewModel.student.schoolName ?? "Independent")")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 10)
                    
                    // Plan & Entitlement Card
                    CardContainer(padding: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Plan & Entitlement")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textMuted)
                                    .textCase(.uppercase)
                                Spacer()
                                Button("Manage") {
                                    appState.navigate(to: .subscription)
                                }
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.primaryRed)
                            }
                            
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(Theme.accentGreen)
                                Text(viewModel.student.subscriptionTier)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                            }
                            
                            Text("Full access provided under school institution license.")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                    
                    // Badges Quick Access
                    Button(action: { showingBadges = true }) {
                        CardContainer(padding: 14) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(Theme.accentYellow)
                                    .font(.system(size: 18))
                                
                                Text("Achievement Badges")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.textDark)
                                
                                Spacer()
                                
                                Text("12 / 18")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.primaryRed)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Account Specifications
                    CardContainer(padding: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Specifications")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.textMuted)
                                .textCase(.uppercase)
                            
                            AccountSpecRow(title: "Registered Email", value: viewModel.student.email)
                            Divider()
                            AccountSpecRow(title: "Account Created", value: viewModel.student.registeredDate)
                            Divider()
                            AccountSpecRow(title: "Role", value: viewModel.student.role.rawValue)
                            Divider()
                            AccountSpecRow(title: "Last Synchronized", value: viewModel.student.lastSynchronizedDate)
                        }
                    }
                    
                    // Sign Out Button
                    Button(action: {
                        appState.signOut()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 14))
                            Text("Sign Out")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(Theme.primaryRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.primaryRed.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .sheet(isPresented: $showingBadges) {
            MyBadgesView()
        }
    }
}

public struct AccountSpecRow: View {
    public let title: String
    public let value: String
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.textDark)
                .lineLimit(1)
        }
    }
}
