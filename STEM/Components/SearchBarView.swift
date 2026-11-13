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
                .foregroundColor(Theme.textMuted)
                .font(.system(size: 15, weight: .medium))

            TextField(placeholder, text: $text)
                .font(Theme.body(13))
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
        .padding(.vertical, 10)
        .background(Color(hex: "F3F5F9"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

