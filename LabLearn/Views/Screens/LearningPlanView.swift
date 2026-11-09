import SwiftUI

public struct LearningPlanView: View {
    @State private var billingCycle: BillingCycle = .monthly
    @State private var isPremiumSelected: Bool = true
    
    public var onBack: (() -> Void)? = nil
    public var onContinue: ((BillingCycle, Bool) -> Void)? = nil
    
    public init(
        initialCycle: BillingCycle = .monthly,
        onBack: (() -> Void)? = nil,
        onContinue: ((BillingCycle, Bool) -> Void)? = nil
    ) {
        self._billingCycle = State(initialValue: initialCycle)
        self.onBack = onBack
        self.onContinue = onContinue
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "Learning Plan",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Headline Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Choose your learning plan")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Theme.textDark)
                        
                        Text("For independent learners")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 22)
                    
                    // Monthly / Yearly Cycle Switcher (Matches Screens 3 & 4)
                    CycleToggleBar(selectedCycle: $billingCycle)
                        .padding(.top, 16)
                        .padding(.horizontal, 22)
                    
                    // Plan Cards Section
                    VStack(spacing: 16) {
                        // Card 1: Basic Plan
                        BasicPlanCard(
                            isSelected: !isPremiumSelected
                        ) {
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                                isPremiumSelected = false
                            }
                        }
                        
                        // Card 2: Premium Plan (Rich Crimson Card)
                        PremiumPlanCard(
                            billingCycle: billingCycle,
                            isSelected: isPremiumSelected
                        ) {
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                                isPremiumSelected = true
                            }
                        }
                    }
                    .padding(.top, 18)
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 28)
                    
                    // Continue with Premium Action Button
                    Button(action: {
                        onContinue?(billingCycle, isPremiumSelected)
                    }) {
                        HStack(spacing: 8) {
                            Text(isPremiumSelected ? "Continue with Premium" : "Continue with Basic")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                        .shadow(color: Theme.primaryRed.opacity(0.24), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

// MARK: - Billing Cycle Toggle (Monthly vs. Yearly)
public struct CycleToggleBar: View {
    @Binding public var selectedCycle: BillingCycle
    
    public var body: some View {
        HStack(spacing: 8) {
            // Monthly Button
            Button(action: {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    selectedCycle = .monthly
                }
            }) {
                Text("Monthly")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selectedCycle == .monthly ? .white : Theme.navyBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        selectedCycle == .monthly ? Theme.primaryRed : Color.clear
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(selectedCycle == .monthly ? Color.clear : Theme.navyBackground.opacity(0.4), lineWidth: 1.2)
                    )
            }
            
            // Yearly Button
            Button(action: {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    selectedCycle = .yearly
                }
            }) {
                Text("Yearly")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selectedCycle == .yearly ? .white : Theme.navyBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        selectedCycle == .yearly ? Theme.primaryRed : Color.clear
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(selectedCycle == .yearly ? Color.clear : Theme.navyBackground.opacity(0.4), lineWidth: 1.2)
                    )
            }
        }
        .padding(4)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Theme.borderLight, lineWidth: 1))
    }
}

// MARK: - Basic Plan Card (White Card with Beaker Icon)
public struct BasicPlanCard: View {
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Top Row: Icon + Title + Free Badge
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.99, green: 0.92, blue: 0.94))
                            .frame(width: 40, height: 40)
                        Image(systemName: "flask.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.primaryRed)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Basic")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        Text("Explore selected labs and resources.")
                            .font(.system(size: 11.5))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    Spacer()
                    
                    // "Free" Badge
                    Text("Free")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.navyBackground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.92, green: 0.95, blue: 1.0))
                        .clipShape(Capsule())
                }
                
                // Features Checklist
                VStack(alignment: .leading, spacing: 8) {
                    PlanFeatureRow(text: "Access to 5+ demo labs", isChecked: true, checkColor: Theme.accentGreen)
                    PlanFeatureRow(text: "Basic learning resources", isChecked: true, checkColor: Theme.accentGreen)
                }
                .padding(.top, 2)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Premium Plan Card (Signature Crimson Gradient Card)
public struct PremiumPlanCard: View {
    public let billingCycle: BillingCycle
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {
                // Top Row: Crown Icon + Title + Price Pill
                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.18))
                            .frame(width: 32, height: 32)
                        Image(systemName: "crown.fill")
                            .font(.system(size: 15))
                            .foregroundColor(Theme.accentGold)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Premium")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                        
                        // Discount Badge for Yearly Mode
                        if billingCycle == .yearly {
                            Text("Save 20% (₹400 off)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Theme.navyBackground)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Theme.accentGold)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                    
                    // Price tag
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(billingCycle == .monthly ? "₹199 / month" : "₹1,999 / year")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.primaryRed)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .clipShape(Capsule())
                        
                        // Original price strikethrough for Yearly
                        if billingCycle == .yearly {
                            Text("₹2,399 / year")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.75))
                                .strikethrough(true, color: Color.white.opacity(0.85))
                                .padding(.trailing, 4)
                        }
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Features Checklist
                VStack(alignment: .leading, spacing: 9) {
                    PlanFeatureRow(text: "Access to complete lab library", isChecked: true, checkColor: .white, textColor: .white)
                    PlanFeatureRow(text: "30+ PCM interactive labs", isChecked: true, checkColor: .white, textColor: .white)
                    PlanFeatureRow(text: "Assessments with progress tracking", isChecked: true, checkColor: .white, textColor: .white)
                    PlanFeatureRow(text: "School & teacher support", isChecked: true, checkColor: .white, textColor: .white)
                }
                
                // Right Selection Checkmark Circle
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(Theme.primaryRed)
                    }
                }
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.72, green: 0.08, blue: 0.18),
                        Color(red: 0.90, green: 0.15, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Theme.primaryRed.opacity(0.20), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct PlanFeatureRow: View {
    public let text: String
    public var isChecked: Bool = true
    public var checkColor: Color = Theme.accentGreen
    public var textColor: Color = Theme.textDark
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(checkColor)
                .frame(width: 14)
            
            Text(text)
                .font(.system(size: 12.5, weight: .medium))
                .foregroundColor(textColor)
            
            Spacer()
        }
    }
}

#Preview {
    LearningPlanView()
}

