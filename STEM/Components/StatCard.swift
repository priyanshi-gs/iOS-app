import SwiftUI

public struct StatCard: View {
    public let icon: String
    public let iconColor: Color
    public let iconBgColor: Color
    public let cardBgColor: Color
    public let cardBorderColor: Color
    public let value: String
    public let label: String
    public let sublabel: String?

    public init(
        icon: String = "flask.fill",
        iconColor: Color = Color(hex: "0284C7"),
        iconBgColor: Color = Color(hex: "E0F2FE"),
        cardBgColor: Color = Color(hex: "F0F7FF"),
        cardBorderColor: Color = Color(hex: "E0EDFB"),
        value: String,
        label: String,
        sublabel: String? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.iconBgColor = iconBgColor
        self.cardBgColor = cardBgColor
        self.cardBorderColor = cardBorderColor
        self.value = value
        self.label = label
        self.sublabel = sublabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Consistent Circular Icon Badge
            ZStack {
                Circle()
                    .fill(iconBgColor)
                    .frame(width: 28, height: 28)

                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(iconColor)
            }

            // Big Metric Value
            Text(value)
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundColor(Theme.oxfordBlue)
                .lineLimit(1)

            // Labels with consistent vertical alignment
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.oxfordBlue.opacity(0.9))
                    .lineLimit(1)

                if let sublabel = sublabel, !sublabel.isEmpty {
                    Text(sublabel)
                        .font(.system(size: 9.5, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                } else {
                    // Empty text spacer maintaining uniform height across all 3 cards
                    Text(" ")
                        .font(.system(size: 9.5, weight: .medium))
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 114)
        .background(cardBgColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(cardBorderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.025), radius: 6, x: 0, y: 2)
    }
}
