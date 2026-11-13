import SwiftUI

public struct ElementCellView: View {
    public let element: Element
    public let isSelected: Bool
    public let size: CGFloat
    public let action: () -> Void

    public init(
        element: Element,
        isSelected: Bool = false,
        size: CGFloat = 34,
        action: @escaping () -> Void
    ) {
        self.element = element
        self.isSelected = isSelected
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                // Background tile color
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(element.category.tileColor)

                // Atomic Number & Symbol
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Text(element.atomicNumberFormatted)
                            .font(.system(size: max(size * 0.22, 7), weight: .medium, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue.opacity(0.75))
                            .padding(.leading, 3)
                            .padding(.top, 2)
                        Spacer()
                    }

                    Spacer()

                    Text(element.symbol)
                        .font(.system(size: max(size * 0.40, 11), weight: .bold, design: .rounded))
                        .foregroundColor(Theme.oxfordBlue)

                    Spacer()
                }

                // Selection Border Indicator
                if isSelected {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Theme.oxfordBlue, lineWidth: 2)
                        .shadow(color: Theme.oxfordBlue.opacity(0.35), radius: 3)
                }
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

