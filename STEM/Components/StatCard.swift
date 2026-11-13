import SwiftUI

public struct StatCard: View {
    public let icon: String
    public let iconColor: Color
    public let value: String
    public let label: String
    public let sublabel: String?

    public init(
        icon: String,
        iconColor: Color = Theme.oxfordBlue,
        value: String,
        label: String,
        sublabel: String? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.value = value
        self.label = label
        self.sublabel = sublabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconColor)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.oxfordBlue.opacity(0.85))
                    .lineLimit(1)

                if let sublabel = sublabel {
                    Text(sublabel)
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "F8FAFC"))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "E2E8F0").opacity(0.6), lineWidth: 1)
        )
    }
}

