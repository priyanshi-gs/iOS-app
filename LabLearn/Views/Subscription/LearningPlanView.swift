import SwiftUI

public struct LearningPlanView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SubscriptionViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Learning Plan",
                subtitle: "For independent learners",
                showBackButton: true,
                onBack: { appState.navigate(to: .roleSelection) }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    VStack(spacing: 8) {
                        Text("Choose your learning plan")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        Text("Unlock comprehensive PCM practical simulations.")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 10)
                    
                    // Billing Cycle Toggle (Monthly vs. Yearly)
                    HStack(spacing: 0) {
                        CycleButton(
                            title: "Monthly",
                            isSelected: viewModel.billingCycle == .monthly
                        ) {
                            viewModel.selectCycle(.monthly)
                        }
                        
                        CycleButton(
                            title: "Yearly",
                            badge: "Save 20%",
                            isSelected: viewModel.billingCycle == .yearly
                        ) {
                            viewModel.selectCycle(.yearly)
                        }
                    }
                    .padding(4)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Theme.borderLight, lineWidth: 1))
                    
                    // Basic Plan Card
                    PlanSelectionCard(
                        title: viewModel.basicPlan.title,
                        priceText: "Free",
                        badge: nil,
                        features: viewModel.basicPlan.features,
                        isSelected: viewModel.selectedPlan.id == viewModel.basicPlan.id,
                        accentColor: Theme.textMuted
                    ) {
                        viewModel.selectedPlan = viewModel.basicPlan
                    }
                    
                    // Premium Plan Card
                    PlanSelectionCard(
                        title: viewModel.premiumPlan.title,
                        priceText: viewModel.billingCycle == .monthly ? "₹199 / month" : "₹1,999 / year",
                        badge: viewModel.billingCycle == .yearly ? "Save 20% (₹400 OFF)" : nil,
                        features: viewModel.premiumPlan.features,
                        isSelected: viewModel.selectedPlan.id == viewModel.premiumPlan.id,
                        accentColor: Theme.primaryRed,
                        isPopular: true
                    ) {
                        viewModel.selectedPlan = viewModel.premiumPlan
                    }
                    
                    Spacer().frame(height: 20)
                    
                    PrimaryButton(
                        viewModel.selectedPlan.isPremium ? "Continue with Premium" : "Continue with Basic"
                    ) {
                        if viewModel.selectedPlan.isPremium {
                            appState.billingCycle = viewModel.billingCycle
                            appState.navigate(to: .checkout)
                        } else {
                            appState.enterMainApp()
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

public struct CycleButton: View {
    public let title: String
    public var badge: String? = nil
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.primaryRed)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .foregroundColor(isSelected ? .white : Theme.textDark)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Theme.navyBackground : Color.clear)
            .clipShape(Capsule())
        }
    }
}

public struct PlanSelectionCard: View {
    public let title: String
    public let priceText: String
    public var badge: String? = nil
    public let features: [String]
    public let isSelected: Bool
    public var accentColor: Color = Theme.primaryRed
    public var isPopular: Bool = false
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            if isPopular {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.accentYellow)
                            }
                        }
                        
                        if let badge = badge {
                            Text(badge)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Theme.primaryRed)
                        }
                    }
                    
                    Spacer()
                    
                    Text(priceText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(accentColor)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(isSelected ? Theme.accentGreen : Theme.textMuted)
                            Text(feature)
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textDark)
                        }
                    }
                }
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? accentColor : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? accentColor.opacity(0.12) : Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
