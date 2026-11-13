import SwiftUI

public struct LabCardView: View {
    public let lab: Lab
    public let onLaunch: () -> Void

    public init(lab: Lab, onLaunch: @escaping () -> Void) {
        self.lab = lab
        self.onLaunch = onLaunch
    }

    public var body: some View {
        HStack(spacing: 14) {
            // Lab Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: lab.gradientStartHex), Color(hex: lab.gradientEndHex)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: lab.thumbnailSymbol)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
            }

            // Info column
            VStack(alignment: .leading, spacing: 6) {
                // Eyebrow tag
                HStack(spacing: 6) {
                    Text(lab.subject.rawValue)
                        .font(Theme.caption(11))
                        .fontWeight(.bold)
                        .foregroundColor(Theme.crimson)

                    Text("•")
                        .foregroundColor(Theme.textMuted)

                    Text(lab.code)
                        .font(Theme.caption(11))
                        .foregroundColor(Theme.textSecondary)

                    Text("•")
                        .foregroundColor(Theme.textMuted)

                    Text(lab.duration)
                        .font(Theme.caption(11))
                        .foregroundColor(Theme.textSecondary)
                }

                // Title
                Text(lab.title)
                    .font(Theme.subheading(15))
                    .foregroundColor(Theme.oxfordBlue)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Launch Button (Right Aligned)
                HStack {
                    Spacer()
                    Button(action: onLaunch) {
                        HStack(spacing: 6) {
                            Text("Launch")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Theme.oxfordBlue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

