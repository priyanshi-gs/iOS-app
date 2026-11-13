import SwiftUI

public struct DecorativeArcView: View {
    public init() {}

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Large Crimson Arc
            Circle()
                .trim(from: 0.45, to: 0.95)
                .stroke(
                    Theme.crimson,
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .frame(width: 140, height: 140)
                .offset(x: 35, y: -45)

            // Inner Yellow Accent Ring
            Circle()
                .trim(from: 0.50, to: 0.85)
                .stroke(
                    Theme.yellow,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 85, height: 85)
                .offset(x: 10, y: -20)
        }
        .allowsHitTesting(false)
    }
}

