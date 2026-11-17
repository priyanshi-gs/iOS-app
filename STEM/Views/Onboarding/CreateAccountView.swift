import SwiftUI

public struct CreateAccountView: View {
    public var onBack: (() -> Void)? = nil
    public var onSubmit: (() -> Void)? = nil

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var mobile: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var isSubmitting: Bool = false
    @State private var isRegistrationSuccess: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    public init(
        onBack: (() -> Void)? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.onBack = onBack
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(spacing: 0) {
            // 1. Top Wave Header with Red Arc & Transparent Liquid Back Button
            WaveHeader(
                title: "Create Account",
                showBackButton: true,
                onBack: { onBack?() }
            )

            // 2. Main Form Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Headline
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Create Account")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.textDark)

                        // Golden-yellow accent underline
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.accentGold)
                            .frame(width: 44, height: 3.5)

                        Text("Enter your details to create your LABS account.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Theme.textMuted)
                            .padding(.top, 2)
                    }
                    .padding(.top, 16)

                    // Input Fields
                    VStack(spacing: 16) {
                        // 1. Full Name Field
                        formInputField(
                            label: "Full Name",
                            icon: "person.fill",
                            placeholder: "Enter your full name"
                        ) {
                            TextField("Enter your full name", text: $name)
                                .font(.system(size: 15))
                                .autocorrectionDisabled()
                        }

                        // 2. Email Address Field
                        formInputField(
                            label: "Email Address",
                            icon: "envelope.fill",
                            placeholder: "Enter your email"
                        ) {
                            TextField("Enter your email", text: $email)
                                .font(.system(size: 15))
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        // 3. Mobile Number Field
                        formInputField(
                            label: "Mobile Number",
                            icon: "phone.fill",
                            placeholder: "Enter your 10-digit mobile number"
                        ) {
                            TextField("e.g. 9876543210", text: $mobile)
                                .font(.system(size: 15))
                                .keyboardType(.phonePad)
                                .autocorrectionDisabled()
                        }

                        // 4. Password Field (with eye button show/hide)
                        passwordField(
                            label: "Password",
                            placeholder: "At least 8 characters",
                            text: $password,
                            isVisible: $isPasswordVisible
                        )

                        // 5. Confirm Password Field (with eye button show/hide)
                        passwordField(
                            label: "Confirm Password",
                            placeholder: "Re-enter your password",
                            text: $confirmPassword,
                            isVisible: $isConfirmPasswordVisible
                        )

                        // Validation Warning if passwords don't match
                        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 12))
                                Text("Passwords do not match")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundColor(Theme.primaryRed)
                            .padding(.leading, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.top, 6)

                    // Submit Button
                    Button(action: validateAndSubmit) {
                        HStack(spacing: 8) {
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                                Text("Creating Account...")
                                    .font(.system(size: 16, weight: .bold))
                            } else {
                                Text("Submit")
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
                        .shadow(color: Theme.primaryRed.opacity(0.18), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isSubmitting)
                    .padding(.top, 10)

                    // Bottom "Already have an account? Sign In" link
                    Button(action: {
                        onBack?()
                    }) {
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Theme.textMuted)

                            Text("Sign In")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.oxfordBlue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 22)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isRegistrationSuccess ? "Success" : "Notice"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if isRegistrationSuccess {
                        onSubmit?()
                    }
                }
            )
        }
    }

    // MARK: - Validation & Submission
    private func validateAndSubmit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMobile = mobile.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            alertMessage = "Please enter your name."
            showAlert = true
            return
        }

        guard !trimmedEmail.isEmpty, trimmedEmail.contains("@") else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        guard !trimmedMobile.isEmpty else {
            alertMessage = "Please enter your mobile number."
            showAlert = true
            return
        }

        guard !password.isEmpty else {
            alertMessage = "Please enter a password."
            showAlert = true
            return
        }

        guard password.count >= 8 else {
            alertMessage = "Password must be at least 8 characters long."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        isSubmitting = true

        // Register with AuthService and backend
        Task {
            let regResult = await AuthService.shared.register(
                name: trimmedName,
                email: trimmedEmail,
                password: password,
                mobile: trimmedMobile,
                role: "STUDENT"
            )
            await MainActor.run {
                isSubmitting = false
                switch regResult {
                case .success:
                    isRegistrationSuccess = true
                    alertMessage = "Account created successfully! Please sign in with your email and password."
                    showAlert = true
                case .failure(let error):
                    isRegistrationSuccess = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func formInputField<Content: View>(
        label: String,
        icon: String,
        placeholder: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "64748B"))
                    .frame(width: 20)

                content()
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func passwordField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)

            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "64748B"))
                    .frame(width: 20)

                if isVisible.wrappedValue {
                    TextField(placeholder, text: text)
                        .font(.system(size: 15))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField(placeholder, text: text)
                        .font(.system(size: 15))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                // Eye button to show and hide text
                Button(action: {
                    isVisible.wrappedValue.toggle()
                }) {
                    Image(systemName: isVisible.wrappedValue ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "64748B"))
                        .padding(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
        }
    }
}


#Preview {
    CreateAccountView()
        .preferredColorScheme(.light)
}
