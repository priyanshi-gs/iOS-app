import SwiftUI

public struct CheckoutPaymentView: View {
    @State private var selectedMethod: PaymentMethodType = .upi
    @State private var couponCode: String = ""
    @State private var isCouponApplied: Bool = false
    @State private var isProcessing: Bool = false
    @State private var payUHTML: String? = nil
    @State private var showPayUSheet: Bool = false
    @State private var paymentErrorMessage: String? = nil
    @State private var showErrorAlert: Bool = false
    @State private var livePlans: [CarawinPlan] = []
    @State private var selectedPlan: CarawinPlan? = nil
    
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
        selectedPlan?.priceInRupees ?? 299
    }
    
    private var discount: Int {
        (selectedPlan?.allLabs ?? false) ? 300 : 0
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
                    
                    // MARK: - Live Plans List (from GET /api/v1/plans)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Plan")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textDark)

                        if livePlans.isEmpty {
                            HStack(spacing: 10) {
                                ProgressView().tint(Theme.oxfordBlue)
                                Text("Loading live plans from server...")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.textMuted)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(livePlans) { plan in
                                    let isSelected = selectedPlan?.id == plan.id
                                    Button(action: {
                                        withAnimation {
                                            selectedPlan = plan
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .stroke(isSelected ? Theme.oxfordBlue : Theme.borderLight, lineWidth: isSelected ? 5 : 1.5)
                                                    .frame(width: 20, height: 20)
                                            }

                                            VStack(alignment: .leading, spacing: 3) {
                                                HStack(spacing: 6) {
                                                    Text(plan.name)
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(Theme.textDark)

                                                    if plan.allLabs {
                                                        Text("ALL LABS")
                                                            .font(.system(size: 8, weight: .heavy))
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 6)
                                                            .padding(.vertical, 2)
                                                            .background(Color(hex: "168B61"))
                                                            .cornerRadius(4)
                                                    } else {
                                                        Text("\(plan.labsCount > 0 ? "\(plan.labsCount) LABS" : "SUBJECT")")
                                                            .font(.system(size: 8, weight: .bold))
                                                            .foregroundColor(Theme.textSecondary)
                                                            .padding(.horizontal, 6)
                                                            .padding(.vertical, 2)
                                                            .background(Color(hex: "EEF1F8"))
                                                            .cornerRadius(4)
                                                    }
                                                }

                                                Text(plan.allLabs ? "Complete access to all STEM practicals" : "\(plan.durationDays) days access")
                                                    .font(.system(size: 11, weight: .regular))
                                                    .foregroundColor(Theme.textMuted)
                                            }

                                            Spacer()

                                            VStack(alignment: .trailing, spacing: 1) {
                                                Text(plan.formattedPrice)
                                                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                                                    .foregroundColor(Theme.textDark)
                                                Text("/ \(plan.durationDays >= 300 ? "year" : (plan.durationDays >= 180 ? "6 mo" : "month"))")
                                                    .font(.system(size: 10, weight: .medium))
                                                    .foregroundColor(Theme.textMuted)
                                            }
                                        }
                                        .padding(14)
                                        .background(isSelected ? Color(hex: "F8F7FF") : Color.white)
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(isSelected ? Theme.oxfordBlue : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Order Summary Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Summary")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        CardContainer(padding: 16) {
                            VStack(spacing: 10) {
                                SummaryRow(
                                    title: selectedPlan?.name ?? "Subscription Plan",
                                    amount: "₹\(basePrice)",
                                    amountColor: Theme.textDark
                                )
                                
                                if discount > 0 {
                                    SummaryRow(
                                        title: "Discount",
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
                    
                    // Pay Now Action Button (Live PayU Gateway)
                    Button(action: startRealPayment) {
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
        .sheet(isPresented: $showPayUSheet) {
            if let html = payUHTML {
                NavigationStack {
                    PayUWebView(
                        htmlString: html,
                        onSuccess: {
                            showPayUSheet = false
                            onPaymentCompleted?()
                        },
                        onFailure: { errorMsg in
                            showPayUSheet = false
                            paymentErrorMessage = errorMsg
                            showErrorAlert = true
                        }
                    )
                    .navigationTitle("PayU Payment")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showPayUSheet = false
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Payment"),
                message: Text(paymentErrorMessage ?? "Payment was cancelled or could not be completed."),
                dismissButton: .default(Text("OK"))
            )
        }
        .task {
            // Live fetch plans from backend (GET /api/v1/plans)
            if let plans = try? await DataService.shared.fetchPlansLive(), !plans.isEmpty {
                await MainActor.run {
                    self.livePlans = plans.filter { $0.active }
                    if self.selectedPlan == nil {
                        self.selectedPlan = plans.first { $0.allLabs } ?? plans.first
                    }
                }
            }
        }
    }

    private func startRealPayment() {
        guard let planId = selectedPlan?.id ?? livePlans.first?.id else { return }
        isProcessing = true

        Task {
            do {
                let initiate = try await PayUService.shared.startCheckout(
                    planId: planId,
                    couponCode: isCouponApplied ? couponCode : nil
                )
                let html = PayUService.shared.buildPayUHTML(
                    action: initiate.action,
                    fields: initiate.fields
                )
                await MainActor.run {
                    self.isProcessing = false
                    self.payUHTML = html
                    self.showPayUSheet = true
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    self.paymentErrorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
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

