import SwiftUI

public struct RoleSelectionView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedRole: LearnerRole = .schoolLinked
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Join LabLearn",
                showBackButton: true,
                onBack: { appState.navigate(to: .splash) }
            )
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How will you join\nLabLearn?")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    
                    Text("Choose the option that best fits you.")
                        .font(.system(size: 15))
                        .foregroundColor(Theme.textMuted)
                }
                .padding(.top, 24)
                
                // Option 1: School-linked learner
                RoleOptionCard(
                    title: "School-linked learner",
                    subtitle: "Join through your school and use its learning entitlement.",
                    iconName: "building.columns.fill",
                    iconColor: Theme.accentYellow,
                    isSelected: selectedRole == .schoolLinked
                ) {
                    selectedRole = .schoolLinked
                }
                
                // Option 2: Independent learner
                RoleOptionCard(
                    title: "Independent learner",
                    subtitle: "Choose a plan and learn independently.",
                    iconName: "graduationcap.fill",
                    iconColor: Theme.primaryRed,
                    isSelected: selectedRole == .independent
                ) {
                    selectedRole = .independent
                }
                
                Spacer()
                
                PrimaryButton("Continue") {
                    appState.selectRoleAndProceed(selectedRole)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct RoleOptionCard: View {
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let iconColor: Color
    public let isSelected: Bool
    public let onSelect: () -> Void
    
    public var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: iconName)
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                        .lineLimit(2)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Theme.primaryRed)
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 4)
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Theme.primaryRed.opacity(0.12) : Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
