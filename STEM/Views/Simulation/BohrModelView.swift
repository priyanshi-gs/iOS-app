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
                let shellCount = max(1, electronConfig.count)
                // Outer orbital radius calibrated so concentric rings fit comfortably in 140x140
                let minRadius: CGFloat = 20.0
                let maxRadius: CGFloat = 62.0
                let radiusStep: CGFloat = shellCount > 1 ? (maxRadius - minRadius) / CGFloat(shellCount - 1) : 0

                // Concentric Orbital Rings (Solid smooth bright blue circles)
                ForEach(0..<electronConfig.count, id: \.self) { ringIndex in
                    let ringRadius = minRadius + CGFloat(ringIndex) * radiusStep
                    let electronsInRing = electronConfig[ringIndex]

                    // Smooth continuous circular orbit line
                    Circle()
                        .stroke(Color(hex: "3B82F6").opacity(0.85), lineWidth: 1.0)
                        .frame(width: ringRadius * 2, height: ringRadius * 2)

                    // Electron dots distributed along the orbit ring
                    ForEach(0..<electronsInRing, id: \.self) { eIndex in
                        let angle = (Double(eIndex) * (360.0 / Double(electronsInRing)) - 90.0) * (.pi / 180.0)
                        let x = CGFloat(cos(angle)) * ringRadius
                        let y = CGFloat(sin(angle)) * ringRadius

                        Circle()
                            .fill(Color(hex: "2563EB"))
                            .frame(width: 5.5, height: 5.5)
                            .shadow(color: Color(hex: "2563EB").opacity(0.35), radius: 1, x: 0, y: 0)
                            .offset(x: x, y: y)
                    }
                }

                // Central Nucleus with vibrant red glow and symbol
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "EF4444"), Color(hex: "DC2626")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .shadow(color: Color(hex: "EF4444").opacity(0.45), radius: 6, x: 0, y: 2)

                    Text(symbol)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 140, height: 140)

            // Caption pill badge matching exact reference design
            Text("Bohr 2D Orbital Model")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "1D4ED8"))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color(hex: "EFF6FF"))
                        .overlay(
                            Capsule()
                                .stroke(Color(hex: "BFDBFE"), lineWidth: 1)
                        )
                )
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(width: 144)
    }
}
