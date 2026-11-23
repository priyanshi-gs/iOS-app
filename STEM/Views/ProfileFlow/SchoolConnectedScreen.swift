import SwiftUI

public struct SchoolConnectedScreen: View {
    public let schoolName: String?
    public let onBack: () -> Void
    public let onDashboard: () -> Void

    public init(
        schoolName: String? = nil,
        onBack: @escaping () -> Void,
        onDashboard: @escaping () -> Void
    ) {
        self.schoolName = schoolName
        self.onBack = onBack
        self.onDashboard = onDashboard
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header (with back button)
            WaveHeader(title: "School Connected", showBackButton: true, onBack: onBack)

            // MARK: - Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {

                    // School illustration
                    ZStack {
                        // Soft background circle
                        Circle()
                            .fill(Color(hex: "EFF6FF"))
                            .frame(width: 170, height: 170)

                        // Building icon
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 70, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "5B9BD5"), Color(hex: "2E75B6")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        // Green checkmark badge
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 38, weight: .medium))
                            .foregroundStyle(.white, Theme.successGreen)
                            .offset(x: 55, y: 48)

                        // Flag on top
                        Image(systemName: "flag.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.crimson)
                            .offset(x: -2, y: -68)

                        // Sparkles
                        Image(systemName: "sparkle")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.yellow)
                            .offset(x: 60, y: -58)

                        Image(systemName: "sparkle")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.yellow)
                            .offset(x: 72, y: -42)

                        // Green decorative clouds
                        Image(systemName: "cloud.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Theme.successGreen.opacity(0.5))
                            .offset(x: -65, y: 30)

                        Image(systemName: "cloud.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.successGreen.opacity(0.4))
                            .offset(x: -50, y: 15)
                    }
                    .padding(.top, 16)

                    // Success heading
                    VStack(spacing: 4) {
                        Text("School Connected")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                        Text("Successfully!")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(Theme.oxfordBlue)
                    .multilineTextAlignment(.center)

                    // Description
                    Text("You are now linked with your school and have\naccess to LabLearn resources.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)

                    // School linked card (green tint)
                    HStack(spacing: 12) {
                        // Graduation cap icon
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Theme.oxfordBlue)
                            .frame(width: 48, height: 48)
                            .background(Color(hex: "E0F2FE"), in: RoundedRectangle(cornerRadius: 13, style: .continuous))

                        VStack(alignment: .leading, spacing: 3) {
                            Text(schoolName ?? "Your School")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.oxfordBlue)
                            Text("School access is now active")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer(minLength: 0)

                        // Linked badge
                        Label("Linked", systemImage: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "166534"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(hex: "DCFCE7"), in: Capsule())
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(hex: "F0FDF4"))
                    )

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

                    // Go to Dashboard button
                    Button(action: onDashboard) {
                        HStack(spacing: 8) {
                            Text("Go to Dashboard")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Theme.redButtonGradient)
                        .clipShape(Capsule())
                        .shadow(color: Theme.crimson.opacity(0.25), radius: 8, y: 4)
                    }
                    .padding(.top, 4)

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 22)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Access Row Component
public struct CarawinAccessRow: View {
    let icon: String
    let title: String
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Theme.oxfordBlue)
                .frame(width: 32, height: 32)
                .background(Color(hex: "EFF6FF"), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.oxfordBlue)
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.primaryBlue)
        }
    }
}

#Preview("School Connected") {
    SchoolConnectedScreen(
        schoolName: "Graphic Era University (GEU)",
        onBack: {},
        onDashboard: {}
    )
}
