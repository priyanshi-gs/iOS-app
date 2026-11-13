import SwiftUI

public struct RecentLabRowView: View {
    public let lab: Lab
    public let action: () -> Void

    public init(lab: Lab, action: @escaping () -> Void) {
        self.lab = lab
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Lab Visual Thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: lab.gradientStartHex), Color(hex: lab.gradientEndHex)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: lab.thumbnailSymbol)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }

                // Lab Info
                VStack(alignment: .leading, spacing: 3) {
                    Text(lab.title)
                        .font(Theme.subheading(14))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)

                    Text("\(lab.subject.rawValue) • \(lab.status.rawValue)")
                        .font(Theme.caption(12))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                // Status Indicator
                if lab.status == .completed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.successGreen)
                } else {
                    ZStack {
                        Circle()
                            .fill(Theme.crimson.opacity(0.12))
                            .frame(width: 24, height: 24)

                        Image(systemName: "play.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.crimson)
                    }
                }
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

