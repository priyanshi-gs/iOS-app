import SwiftUI

public enum LearnerOption: String, CaseIterable, Identifiable {
    case schoolLinked = "School-linked learner"
    case independent = "Independent learner"
    
    public var id: String { rawValue }
}

public struct RoleSelectionView: View {
    @State public var selectedOption: LearnerOption = .schoolLinked
    public var onBack: (() -> Void)? = nil
    public var onContinue: ((LearnerOption) -> Void)? = nil
    
    public init(
        initialSelection: LearnerOption = .schoolLinked,
        onBack: (() -> Void)? = nil,
        onContinue: ((LearnerOption) -> Void)? = nil
    ) {
        self._selectedOption = State(initialValue: initialSelection)
        self.onBack = onBack
        self.onContinue = onContinue
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "Join LabLearn",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            // 2. Main Screen Content
            VStack(alignment: .leading, spacing: 0) {
                // Headline Section
                VStack(alignment: .leading, spacing: 6) {
                    Text("How will you join\nLabLearn?")
                        .font(.system(size: 27, weight: .heavy))
                        .foregroundColor(Theme.textDark)
                        .lineSpacing(4)
                    
                    // Golden-yellow accent underline
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.accentGold)
                        .frame(width: 44, height: 3.5)
                        .padding(.top, 2)
                    
                    Text("Choose the option that best fits you.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.textMuted)
                        .padding(.top, 6)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // Selection Cards Section
                VStack(spacing: 16) {
                    // Option 1: School-linked learner
                    SchoolLinkedCard(
                        isSelected: selectedOption == .schoolLinked
                    ) {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selectedOption = .schoolLinked
                        }
                    }
                    
                    // Option 2: Independent learner
                    IndependentLearnerCard(
                        isSelected: selectedOption == .independent
                    ) {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selectedOption = .independent
                        }
                    }
                }
                .padding(.top, 28)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottom Continue Button
                Button(action: {
                    onContinue?(selectedOption)
                }) {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .heavy))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.redButtonGradient)
                    .clipShape(Capsule())
                    .shadow(color: Theme.primaryRed.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

// MARK: - School-Linked Learner Card (Matches Selected Figma State)
public struct SchoolLinkedCard: View {
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Yellow Temple/School Icon inside container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color(red: 0.08, green: 0.14, blue: 0.30) : Theme.accentGold.opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.accentGold)
                }
                
                // Subtle Vertical Divider
                Rectangle()
                    .fill(isSelected ? Color.white.opacity(0.18) : Theme.borderLight)
                    .frame(width: 1, height: 38)
                
                // Text details
                VStack(alignment: .leading, spacing: 3) {
                    Text("School-linked learner")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(isSelected ? .white : Theme.textDark)
                    
                    Text("Join through your school and use its learning entitlement.")
                        .font(.system(size: 11.5))
                        .foregroundColor(isSelected ? Color.white.opacity(0.75) : Theme.textMuted)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Right Selection Indicator (Gold check badge when selected)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Theme.accentGold)
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(Theme.navyBackground)
                    }
                } else {
                    Circle()
                        .stroke(Theme.borderLight, lineWidth: 1.8)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                isSelected ? Theme.navyBackground : Color.white
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Theme.accentGold : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: isSelected ? Theme.accentGold.opacity(0.2) : Color.black.opacity(0.04),
                radius: isSelected ? 10 : 6,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Independent Learner Card (Matches Unselected Figma State)
public struct IndependentLearnerCard: View {
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Red Graduation Cap Icon inside soft container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color(red: 0.15, green: 0.10, blue: 0.22) : Color(red: 0.99, green: 0.92, blue: 0.94))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.primaryRed)
                }
                
                // Subtle Vertical Divider
                Rectangle()
                    .fill(isSelected ? Color.white.opacity(0.18) : Theme.borderLight)
                    .frame(width: 1, height: 38)
                
                // Text details
                VStack(alignment: .leading, spacing: 3) {
                    Text("Independent learner")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(isSelected ? .white : Theme.textDark)
                    
                    Text("Choose a plan and learn independently.")
                        .font(.system(size: 11.5))
                        .foregroundColor(isSelected ? Color.white.opacity(0.75) : Theme.textMuted)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Right Selection Indicator
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Theme.primaryRed)
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.white)
                    }
                } else {
                    Circle()
                        .stroke(Color(red: 0.45, green: 0.50, blue: 0.60), lineWidth: 1.8)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                isSelected ? Theme.navyBackground : Color.white
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: isSelected ? Theme.primaryRed.opacity(0.2) : Color.black.opacity(0.04),
                radius: isSelected ? 10 : 6,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RoleSelectionView()
}

