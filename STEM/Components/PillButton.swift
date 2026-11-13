import SwiftUI

public struct PillButton: View {
    public let title: String
    public let systemIcon: String?
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let borderColor: Color?
    public let height: CGFloat
    public let action: () -> Void

    public init(
        title: String,
        systemIcon: String? = nil,
        backgroundColor: Color = Theme.oxfordBlue,
        foregroundColor: Color = .white,
        borderColor: Color? = nil,
        height: CGFloat = 36,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.height = height
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemIcon = systemIcon {
                    Image(systemName: systemIcon)
                        .font(.system(size: 13, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 14)
            .frame(height: height)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1.5 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

