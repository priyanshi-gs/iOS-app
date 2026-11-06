import SwiftUI

public struct PaymentSuccessView: View {
    public var billingCycle: BillingCycle = .yearly
    public var onBack: (() -> Void)? = nil
    public var onExploreLabs: (() -> Void)? = nil
    
    public init(
        billingCycle: BillingCycle = .yearly,
        onBack: (() -> Void)? = nil,
        onExploreLabs: (() -> Void)? = nil
    ) {
        self.billingCycle = billingCycle
        self.onBack = onBack
        self.onExploreLabs = onExploreLabs
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "Payment Successful",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Celebration Checkmark Badge
                    ZStack {
                        // Ray bursts
                        ForEach(0..<8, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.accentGreen.opacity(0.3))
                                .frame(width: 3, height: 10)
                                .offset(y: -44)
                                .rotationEffect(.degrees(Double(i) * 45))
                        }
                        
                        Circle()
                            .fill(Theme.accentGreen.opacity(0.15))
                            .frame(width: 76, height: 76)
                        
                        Circle()
                            .fill(Theme.accentGreen)
                            .frame(width: 58, height: 58)
                            .shadow(color: Theme.accentGreen.opacity(0.35), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 14)
                    
                    // Headings
                    VStack(spacing: 4) {
                        Text("Payment Successful!")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Theme.textDark)
                        
                        Text("Your Premium plan is now active.")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    // Active Plan Banner (Red Gradient Card)
                    ZStack(alignment: .trailing) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.accentGold)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Premium Plan")
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(.white)
                                    Text("\(billingCycle.rawValue) Subscription")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                Text("Active")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Theme.navyBackground)
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 3)
                                    .background(Theme.accentGold)
                                    .clipShape(Capsule())
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.25))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                FeatureCheckBullet(text: "Access to complete lab library")
                                FeatureCheckBullet(text: "30+ PCM interactive labs")
                                FeatureCheckBullet(text: "Assessments with progress tracking")
                                FeatureCheckBullet(text: "School & teacher support")
                            }
                        }
                        .padding(16)
                        
                        // Glowing beaker icon illustration on the right
                        Image(systemName: "flask.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.4), Color.pink.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .offset(x: -16, y: 30)
                    }
                    .background(Theme.premiumCardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 20)
                    
                    // Payment Details Receipt Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Details")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        CardContainer(padding: 16) {
                            VStack(spacing: 10) {
                                ReceiptDetailRow(icon: "calendar", title: "Plan", value: "Premium (\(billingCycle.rawValue))")
                                ReceiptDetailRow(icon: "indianrupeesign", title: "Amount Paid", value: billingCycle == .monthly ? "₹199" : "₹1,999", isBold: true)
                                ReceiptDetailRow(icon: "doc.text.fill", title: "Transaction ID", value: "LLN762945038", isMonospace: true)
                                ReceiptDetailRow(icon: "clock.fill", title: "Date & Time", value: "05 Nov 2026, 09:41 PM")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Plan Activated Status Pill
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.accentGreen)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Plan Activated")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            Text("You now have full access to all premium features.")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Theme.accentGreen.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.accentGreen.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Explore Labs Action Button
                    Button(action: {
                        onExploreLabs?()
                    }) {
                        HStack(spacing: 8) {
                            Text("Explore Labs")
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

public struct ReceiptDetailRow: View {
    public let icon: String
    public let title: String
    public let value: String
    public var isBold: Bool = false
    public var isMonospace: Bool = false
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
                .frame(width: 16)
            
            Text(title)
                .font(.system(size: 12.5))
                .foregroundColor(Theme.textMuted)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12.5, weight: isBold ? .bold : .semibold, design: isMonospace ? .monospaced : .default))
                .foregroundColor(Theme.textDark)
        }
    }
}

#Preview {
    PaymentSuccessView()
}
