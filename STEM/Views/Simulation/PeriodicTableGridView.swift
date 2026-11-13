import SwiftUI

public struct PeriodicTableGridView: View {
    public let elements: [Element]
    public let selectedElement: Element
    public let onSelectElement: (Element) -> Void

    public init(
        elements: [Element],
        selectedElement: Element,
        onSelectElement: @escaping (Element) -> Void
    ) {
        self.elements = elements
        self.selectedElement = selectedElement
        self.onSelectElement = onSelectElement
    }

    private let columnsCount = 18
    private let tileSize: CGFloat = 34

    // Map elements by period (row 1 to 4) and group (column 1 to 18)
    private func elementAt(period: Int, group: Int) -> Element? {
        elements.first { $0.period == period && $0.group == group }
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 4) {
                // Group numbers header (1 to 18)
                HStack(spacing: 4) {
                    ForEach(1...columnsCount, id: \.self) { col in
                        Text("\(col)")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                            .frame(width: tileSize, height: 14)
                    }
                }

                // Periods 1 to 4 grid
                ForEach(1...4, id: \.self) { period in
                    HStack(spacing: 4) {
                        ForEach(1...columnsCount, id: \.self) { group in
                            if let element = elementAt(period: period, group: group) {
                                ElementCellView(
                                    element: element,
                                    isSelected: element.id == selectedElement.id,
                                    size: tileSize
                                ) {
                                    onSelectElement(element)
                                }
                            } else {
                                // Empty grid cell placeholder
                                Color.clear
                                    .frame(width: tileSize, height: tileSize)
                            }
                        }
                    }
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
        }
    }
}

