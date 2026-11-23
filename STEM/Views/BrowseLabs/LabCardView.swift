import SwiftUI

public struct LabCardView: View {
    public let lab: Lab
    public let onLaunch: () -> Void

    public init(lab: Lab, onLaunch: @escaping () -> Void) {
        self.lab = lab
        self.onLaunch = onLaunch
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // MARK: - Compact Thumbnail Box (Fixed 74x74)
            ZStack {
                if let urlStr = lab.thumbnailUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            gradientFallback
                        }
                    }
                } else {
                    gradientFallback
                }

                if lab.isLocked {
                    // Dark semi-transparent lock overlay strictly bounded to thumbnail
                    Color.black.opacity(0.42)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 74, height: 74)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)

            // MARK: - Info Column
            VStack(alignment: .leading, spacing: 5) {
                // Top Metadata Row: Subject • Class • Duration ... [PRO]
                HStack(spacing: 5) {
                    Text(lab.subject.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.crimson)
                        .lineLimit(1)

                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)

                    Text(lab.code)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)

                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)

                    Text(lab.duration)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    if lab.isLocked {
                        Text("PRO")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Theme.yellow)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.oxfordBlue, in: Capsule())
                    }
                }

                // Lab Title (flexible lines, never truncated)
                Text(lab.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)
                    .lineLimit(nil)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                // Bottom Action Row
                HStack {
                    Spacer()
                    Button(action: onLaunch) {
                        HStack(spacing: 5) {
                            if lab.isLocked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 10, weight: .bold))
                                Text("Unlock")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                            } else {
                                Text("Launch")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 9, weight: .bold))
                            }
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 6)
                        .background(lab.isLocked ? Color(hex: "64748B") : Theme.oxfordBlue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }

    // Gradient fallback view
    @ViewBuilder
    private var gradientFallback: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: lab.gradientStartHex), Color(hex: lab.gradientEndHex)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: lab.thumbnailSymbol)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

