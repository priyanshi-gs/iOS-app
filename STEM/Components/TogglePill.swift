import SwiftUI

public struct TogglePill: View {
    public let title: String
    public let systemIcon: String?
    public let isOn: Bool
    public let activeColor: Color
    public let inactiveColor: Color
    public let action: () -> Void

    public init(
        title: String,
        systemIcon: String? = nil,
        isOn: Bool,
        activeColor: Color = Theme.yellow,
        inactiveColor: Color = Color(hex: "F1F5F9"),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.isOn = isOn
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let systemIcon = systemIcon {
                    Image(systemName: systemIcon)
                        .font(.system(size: 11, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isOn ? activeColor : inactiveColor)
            .foregroundColor(isOn ? (activeColor == Theme.yellow ? Theme.oxfordBlue : .white) : Theme.oxfordBlue.opacity(0.8))
            .clipShape(Capsule())
            .shadow(color: isOn ? activeColor.opacity(0.25) : Color.clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

