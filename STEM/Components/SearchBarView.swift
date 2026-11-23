import SwiftUI

public struct SearchBarView: View {
    @Binding public var text: String
    public let placeholder: String
    public var onFilterTap: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: String = "Search labs, topics or experiments",
        onFilterTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onFilterTap = onFilterTap
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.oxfordBlue.opacity(0.75))
                .font(.system(size: 15, weight: .semibold))

            TextField(placeholder, text: $text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textPrimary)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textMuted)
                        .font(.system(size: 14))
                }
            }

            if let onFilterTap = onFilterTap {
                Button(action: onFilterTap) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(Theme.oxfordBlue)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

