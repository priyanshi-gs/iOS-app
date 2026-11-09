import SwiftUI

public struct CheckoutPaymentView: View {
    @State private var selectedMethod: PaymentMethodType = .upi
    @State private var couponCode: String = ""
    @State private var isCouponApplied: Bool = false
    @State private var isProcessing: Bool = false
    
    public var billingCycle: BillingCycle = .yearly
    public var onBack: (() -> Void)? = nil
    public var onPaymentCompleted: (() -> Void)? = nil
    
    public init(
        billingCycle: BillingCycle = .yearly,
        onBack: (() -> Void)? = nil,
        onPaymentCompleted: (() -> Void)? = nil
    ) {
        self.billingCycle = billingCycle
        self.onBack = onBack
        self.onPaymentCompleted = onPaymentCompleted
    }
    
    private var basePrice: Int {
        billingCycle == .monthly ? 199 : 2399
    }
    
    private var discount: Int {
        billingCycle == .monthly ? 0 : 400
    }
    
    private var couponDiscount: Int {
        isCouponApplied ? 100 : 0
    }
    
    private var totalPayable: Int {
        max(0, basePrice - discount - couponDiscount)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Curved Navy Header with Red Arc & Back Button
            WaveHeader(
                title: "Payment",
                showBackButton: true,
                onBack: { onBack?() }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Headline Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Complete your purchase")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Theme.textDark)
                        
                        Text("You're almost there! Review your plan and make the payment.")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.top, 14)
                    
                    // Top Plan Summary Card (Matches Screen 5)
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
                                
                                if billingCycle == .yearly {
                                    Text("Save 20%")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Theme.navyBackground)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Theme.accentGold)
                                        .clipShape(Capsule())
                                }
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
                            .font(.system(size: 54))
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
                    .shadow(color: Theme.primaryRed.opacity(0.12), radius: 8, x: 0, y: 4)
                    
                    // Order Summary Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Summary")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        CardContainer(padding: 16) {
                            VStack(spacing: 10) {
                                SummaryRow(
                                    title: "Premium Plan (\(billingCycle.rawValue))",
                                    amount: "₹\(basePrice)",
                                    amountColor: Theme.textDark
                                )
                                
                                if discount > 0 {
                                    SummaryRow(
                                        title: "Discount (20%)",
                                        amount: "-₹\(discount)",
                                        amountColor: Theme.accentGreen
                                    )
                                }
                                
                                if isCouponApplied {
                                    SummaryRow(
                                        title: "Promo Code (SAVE100)",
                                        amount: "-₹100",
                                        amountColor: Theme.accentGreen
                                    )
                                }
                                
                                Divider()
                                
                                SummaryRow(
                                    title: "Total Payable",
                                    amount: "₹\(totalPayable)",
                                    isBold: true,
                                    amountColor: Theme.textDark
                                )
                            }
                        }
                    }
                    
                    // Coupon Code Input
                    HStack(spacing: 10) {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.primaryRed)
                        
                        TextField("Have a coupon code?", text: $couponCode)
                            .font(.system(size: 13, weight: .medium))
                            .textInputAutocapitalization(.characters)
                            .disableAutocorrection(true)
                        
                        Button(action: {
                            withAnimation {
                                isCouponApplied = true
                            }
                        }) {
                            Text(isCouponApplied ? "Applied" : "Apply")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(isCouponApplied ? Theme.accentGreen : Theme.primaryBlue)
                        }
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.borderLight, lineWidth: 1)
                    )
                    
                    // Choose Payment Method Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose Payment Method")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        VStack(spacing: 10) {
                            PaymentMethodOptionRow(
                                title: "UPI",
                                subtitle: "Pay using any UPI app",
                                iconName: "qrcode",
                                iconColor: Theme.primaryRed,
                                isSelected: selectedMethod == .upi
                            ) {
                                selectedMethod = .upi
                            }
                            
                            PaymentMethodOptionRow(
                                title: "Credit / Debit Card",
                                subtitle: "Visa, Mastercard, RuPay",
                                iconName: "creditcard.fill",
                                iconColor: Theme.primaryBlue,
                                isSelected: selectedMethod == .card
                            ) {
                                selectedMethod = .card
                            }
                            
                            PaymentMethodOptionRow(
                                title: "Net Banking",
                                subtitle: "Pay from your bank account",
                                iconName: "building.columns.fill",
                                iconColor: Theme.accentGold,
                                isSelected: selectedMethod == .netBanking
                            ) {
                                selectedMethod = .netBanking
                            }
                        }
                    }
                    
                    // Pay Now Action Button
                    Button(action: {
                        isProcessing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isProcessing = false
                            onPaymentCompleted?()
                        }
                    }) {
                        HStack(spacing: 8) {
                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 14))
                                Text("Pay Now - ₹\(totalPayable)")
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
                        .shadow(color: Theme.primaryRed.opacity(0.16), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isProcessing)
                    .padding(.top, 4)
                    
                    // Security Footer
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.accentGreen)
                        Text("100% Secure Payment | Encrypted & Trusted")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct FeatureCheckBullet: View {
    public let text: String
    
    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
            Text(text)
                .font(.system(size: 11.5))
                .foregroundColor(.white)
        }
    }
}

public struct SummaryRow: View {
    public let title: String
    public let amount: String
    public var isBold: Bool = false
    public var amountColor: Color = Theme.textDark
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: isBold ? 14 : 13, weight: isBold ? .bold : .regular))
                .foregroundColor(isBold ? Theme.textDark : Theme.textMuted)
            Spacer()
            Text(amount)
                .font(.system(size: isBold ? 16 : 13, weight: isBold ? .heavy : .semibold))
                .foregroundColor(amountColor)
        }
    }
}

public struct PaymentMethodOptionRow: View {
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let iconColor: Color
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.primaryRed : Color(red: 0.75, green: 0.80, blue: 0.88), lineWidth: 1.8)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(Theme.primaryRed)
                            .frame(width: 10, height: 10)
                    }
                }
                
                // Method Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: iconName)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }
                
                // Text details
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CheckoutPaymentView()
}

