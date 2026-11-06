import SwiftUI

public struct CheckoutPaymentView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SubscriptionViewModel()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "Payment",
                subtitle: "Complete your purchase",
                showBackButton: true,
                onBack: { appState.navigate(to: .subscription) }
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Plan Banner
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.accentYellow)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Premium Plan (\(appState.billingCycle.rawValue))")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text("Full access to 30+ interactive PCM labs")
                                .font(.system(size: 11))
                                .foregroundColor(Color.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                    .padding(14)
                    .background(Theme.navyBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.top, 10)
                    
                    // Order Summary
                    CardContainer(padding: 16) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Order Summary")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Premium Plan (\(appState.billingCycle.rawValue))")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textMuted)
                                Spacer()
                                Text("₹\(appState.billingCycle == .monthly ? 199 : 2399)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Theme.textDark)
                            }
                            
                            if appState.billingCycle == .yearly {
                                HStack {
                                    Text("Discount (Save 20%)")
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.accentGreen)
                                    Spacer()
                                    Text("-₹400")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Theme.accentGreen)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total Payable")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Spacer()
                                Text("₹\(appState.billingCycle == .monthly ? 199 : 1999)")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(Theme.primaryRed)
                            }
                        }
                    }
                    
                    // Promo Code Card
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(Theme.primaryRed)
                        TextField("Enter coupon code", text: $viewModel.promoCode)
                            .font(.system(size: 13))
                        Button("Apply") {
                            viewModel.applyPromo()
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.primaryRed)
                    }
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.borderLight, lineWidth: 1))
                    
                    // Payment Method Selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Choose Payment Method")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        VStack(spacing: 8) {
                            ForEach(PaymentMethodType.allCases) { method in
                                PaymentMethodRow(
                                    method: method,
                                    isSelected: viewModel.selectedPaymentMethod == method
                                ) {
                                    viewModel.selectedPaymentMethod = method
                                }
                            }
                        }
                    }
                    
                    PrimaryButton(
                        "Pay Now - ₹\(appState.billingCycle == .monthly ? 199 : 1999)",
                        isLoading: viewModel.isProcessingPayment
                    ) {
                        viewModel.processPayment { order in
                            appState.activeOrder = order
                            appState.navigate(to: .paymentSuccess)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct PaymentMethodRow: View {
    public let method: PaymentMethodType
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: method.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? Theme.primaryRed : Theme.textMuted)
                    .frame(width: 24)
                
                Text(method.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textDark)
                
                Spacer()
                
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? Theme.primaryRed : Theme.borderLight)
                    .font(.system(size: 18))
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct PaymentSuccessView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(title: "Payment Successful")
            
            VStack(spacing: 24) {
                Spacer()
                
                // Success Badge
                ZStack {
                    Circle()
                        .fill(Theme.accentGreen.opacity(0.12))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.accentGreen)
                }
                
                VStack(spacing: 6) {
                    Text("Payment Successful!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Your Premium plan is now active.")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textMuted)
                }
                
                // Plan Active Summary
                CardContainer(padding: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appState.activeOrder.planTitle)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Theme.textDark)
                                Text("Full access to 30+ PCM labs & AI features")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                            Spacer()
                            Image(systemName: "crown.fill")
                                .foregroundColor(Theme.accentYellow)
                        }
                        
                        Divider()
                        
                        VStack(spacing: 6) {
                            ReceiptRow(title: "Amount Paid", value: "₹\(appState.activeOrder.totalPayable)")
                            ReceiptRow(title: "Transaction ID", value: appState.activeOrder.id)
                            ReceiptRow(title: "Date & Time", value: "05 Nov 2026, 02:45 PM")
                        }
                    }
                }
                
                Spacer()
                
                PrimaryButton("Explore Labs") {
                    appState.enterMainApp()
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct ReceiptRow: View {
    public let title: String
    public let value: String
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.textDark)
        }
    }
}
