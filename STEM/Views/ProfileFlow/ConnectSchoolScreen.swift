import SwiftUI

public struct ConnectSchoolScreen: View {
    public let onBack: () -> Void
    public let onVerified: () -> Void
    public var onVerifiedSchool: ((String) -> Void)? = nil
    public var onSubmit: ((String) -> Bool)? = nil

    @State private var code = ""
    @State private var showCodeAlert = false
    @State private var rejectedCode = false
    @State private var isVerified = false
    @State private var isVerifying = false
    @State private var errorMessage: String = "The school code could not be verified."

    public init(
        onBack: @escaping () -> Void,
        onVerified: @escaping () -> Void,
        onVerifiedSchool: ((String) -> Void)? = nil,
        onSubmit: ((String) -> Bool)? = nil
    ) {
        self.onBack = onBack
        self.onVerified = onVerified
        self.onVerifiedSchool = onVerifiedSchool
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header
            WaveHeader(title: "Connect School", onBack: onBack)

            // MARK: - Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    // Headline
                    Text("Connect your school")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(Theme.oxfordBlue)

                    // Subtitle
                    Text("Enter the referral code provided by\nyour school to verify your access.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .lineSpacing(3)

                    // School Referral Code label badge
                    Text("School Referral Code")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(Theme.oxfordBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.yellow.opacity(0.35), in: Capsule())

                    // Code input field
                    HStack(spacing: 12) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Theme.oxfordBlue)

                        TextField("Enter your code", text: $code)
                            .font(.system(size: 16, weight: .medium))
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .submitLabel(.done)
                            .onSubmit(verify)

                        Image(systemName: "viewfinder")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Theme.oxfordBlue)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Theme.borderSubtle, lineWidth: 1)
                    )

                    // Verify Code button
                    Button(action: verify) {
                        HStack(spacing: 8) {
                            if isVerifying {
                                ProgressView().tint(.white)
                                Text("Verifying Code...")
                                    .font(.system(size: 16, weight: .bold))
                            } else {
                                Text("Verify Code")
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
                        .shadow(color: Theme.crimson.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isVerifying)

                    // Success / Info banner
                    if isVerified {
                        // Green success banner
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(Theme.successGreen)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("School entitlement checked")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "166534"))
                                Text("Your school has active LabLearn access.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "15803D"))
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(14)
                        .background(Color(hex: "DCFCE7"), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        // Blue info banner
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Theme.primaryBlue)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Ready to verify your school")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                                Text("Your app will check this code when connected to the backend.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(14)
                        .background(Color(hex: "EFF6FF"), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    // Your Access section
                    VStack(alignment: .leading, spacing: 14) {
                        // Section title with gold line
                        HStack(spacing: 10) {
                            Text("Your Access")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .foregroundColor(Theme.oxfordBlue)
                            Rectangle()
                                .fill(Theme.yellow)
                                .frame(height: 3)
                                .frame(maxWidth: 80)
                                .clipShape(Capsule())
                        }

                        CarawinAccessRow(icon: "flask.fill", title: "Access to entitled labs")
                        CarawinAccessRow(icon: "square.stack.3d.up.fill", title: "Complete experiments & assessments")
                        CarawinAccessRow(icon: "chart.bar.fill", title: "Track your learning progress")
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                    )

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 22)
                .padding(.top, 20)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .alert(rejectedCode ? "Code not accepted" : "School code required", isPresented: $showCodeAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(rejectedCode ? "The school code could not be verified." : "Enter your school referral code, then tap Verify Code.")
        }
    }

    private func verify() {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter your school referral code."
            rejectedCode = false
            showCodeAlert = true
            return
        }

        if let onSubmit = onSubmit {
            guard onSubmit(trimmed) else {
                errorMessage = "Invalid or expired school referral code."
                rejectedCode = true
                showCodeAlert = true
                return
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isVerified = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onVerified()
            }
            return
        }

        isVerifying = true
        Task {
            let (isValid, schoolName) = await AuthService.shared.verifySchoolCode(code: trimmed)
            await MainActor.run {
                isVerifying = false
                if isValid {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isVerified = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onVerifiedSchool?(schoolName ?? "School Enrolled")
                        onVerified()
                    }
                } else {
                    errorMessage = "Invalid or expired school referral code. Please check with your school administrator."
                    rejectedCode = true
                    showCodeAlert = true
                }
            }
        }
    }
}

#Preview("Connect School") {
    ConnectSchoolScreen(
        onBack: {},
        onVerified: {},
        onSubmit: { _ in true }
    )
}
