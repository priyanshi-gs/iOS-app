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
                        .shadow(color: Theme.primaryRed.opacity(0.16), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

// MARK: - Billing Cycle Toggle (Native Draggable Segmented Control with Glass Effect)
public struct CycleToggleBar: View {
    @Binding public var selectedCycle: BillingCycle
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    public var body: some View {
        GeometryReader { geo in
            let itemWidth = geo.size.width / 2
            let currentOffset: CGFloat = isDragging
                ? min(max((selectedCycle == .monthly ? 0 : itemWidth) + dragOffset, 0), itemWidth)
                : (selectedCycle == .monthly ? 0 : itemWidth)
            
            ZStack(alignment: .leading) {
                // 1. Deep Navy Segment Track (Matches Figma mockup #022B5F)
                Capsule()
                    .fill(Color(red: 0.01, green: 0.17, blue: 0.38))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.08), lineWidth: 0.8)
                    )
                
                // 2. Draggable Glass Crimson Pill Indicator
                ZStack {
                    // Base soft crimson fill
                    Capsule()
                        .fill(Theme.redButtonGradient)
                    
                    // Glass specular highlight overlay (top-lit refraction)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.32),
                                    Color.white.opacity(0.08),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Glass frosted bevel rim / specular edge
                    Capsule()
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.48),
                                    Color.white.opacity(0.12)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
                .frame(width: itemWidth)
                .offset(x: currentOffset)
                .scaleEffect(isDragging ? 1.02 : 1.0)
                .shadow(color: Color.black.opacity(0.20), radius: 6, x: 0, y: 3)
                .shadow(color: Theme.primaryRed.opacity(0.22), radius: 8, x: 0, y: 2)
                .animation(.spring(response: 0.28, dampingFraction: 0.78), value: selectedCycle)
                .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.85), value: dragOffset)
                
                // 3. Segment Labels & Tap Targets
                HStack(spacing: 0) {
                    // Monthly Segment
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                            selectedCycle = .monthly
                            dragOffset = 0
                        }
                    }) {
                        Text("Monthly")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Yearly Segment
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                            selectedCycle = .yearly
                            dragOffset = 0
                        }
                    }) {
                        Text("Yearly")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .contentShape(Capsule())
            .gesture(
                DragGesture(minimumDistance: 3)
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        let translation = value.translation.width
                        let predicted = value.predictedEndTranslation.width
                        let targetCycle: BillingCycle
                        
                        if selectedCycle == .monthly {
                            // Dragging from Monthly towards Yearly
                            if translation > itemWidth * 0.38 || predicted > itemWidth * 0.45 {
                                targetCycle = .yearly
                            } else {
                                targetCycle = .monthly
                            }
                        } else {
                            // Dragging from Yearly towards Monthly
                            if translation < -itemWidth * 0.38 || predicted < -itemWidth * 0.45 {
                                targetCycle = .monthly
                            } else {
                                targetCycle = .yearly
                            }
                        }
                        
                        dragOffset = 0
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                            selectedCycle = targetCycle
                        }
                    }
            )
        }
        .frame(height: 42)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
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
            .background(Theme.premiumCardGradient)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Theme.primaryRed.opacity(0.12), radius: 8, x: 0, y: 4)
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

