import SwiftUI

public struct BohrModelView: View {
    public let symbol: String
    public let atomicNumber: Int
    public let electronConfig: [Int] // Orbit shells e.g. [2, 8, 8, 2]

    public init(
        symbol: String,
        atomicNumber: Int,
        electronConfig: [Int]
    ) {
        self.symbol = symbol
        self.atomicNumber = atomicNumber
        self.electronConfig = electronConfig
    }

    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Dynamic Shell Rings
                ForEach(0..<electronConfig.count, id: \.self) { ringIndex in
                    let ringRadius = CGFloat(32 + ringIndex * 18)
                    let electronsInRing = electronConfig[ringIndex]

                    // Orbit Path Ring (Dashed line)
                    Circle()
                        .stroke(
                            Color(hex: "94A3B8").opacity(0.45),
                            style: StrokeStyle(lineWidth: 1.2, lineCap: .round, dash: [4, 4])
                        )
                        .frame(width: ringRadius * 2, height: ringRadius * 2)

                    // Electrons distributed along orbit
                    ForEach(0..<electronsInRing, id: \.self) { eIndex in
                        let angle = (Double(eIndex) * (360.0 / Double(electronsInRing))) * (Double.pi / 180.0)
                        let x = CGFloat(cos(angle)) * ringRadius
                        let y = CGFloat(sin(angle)) * ringRadius

                        ZStack {
                            Circle()
                                .fill(Theme.crimson)
                                .frame(width: 7, height: 7)

                            Circle()
                                .fill(Color.white)
                                .frame(width: 2.5, height: 2.5)
                        }
                        .offset(x: x, y: y)
                    }
                }

                // Central Nucleus
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.crimson, Color(hex: "991B1B")],
                                center: .center,
                                startRadius: 2,
                                endRadius: 18
                            )
                        )
                        .frame(width: 32, height: 32)
                        .shadow(color: Theme.crimson.opacity(0.35), radius: 6, x: 0, y: 2)

                    VStack(spacing: 0) {
                        Text(symbol)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(width: 190, height: 190)

            // Caption
            Text("Bohr 2D Orbital Model")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(8)
    }
}

