import SwiftUI

public struct BohrModelView: View {
    public let element: PeriodicElement
    public let rotationAngle: Double
    
    public init(element: PeriodicElement, rotationAngle: Double) {
        self.element = element
        self.rotationAngle = rotationAngle
    }
    
    public var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let maxRadius = min(size.width, size.height) / 2 - 16
            let shells = element.shellElectrons
            let shellCount = max(1, shells.count)
            let radiusStep = maxRadius / CGFloat(shellCount + 1)
            
            // 1. Draw Concentric Shell Paths
            for (index, _) in shells.enumerated() {
                let radius = radiusStep * CGFloat(index + 1)
                let rect = CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )
                
                context.stroke(
                    Path(ellipseIn: rect),
                    with: .color(Color.blue.opacity(0.25)),
                    style: StrokeStyle(lineWidth: 1.2, dash: [4, 4])
                )
            }
            
            // 2. Draw Nucleus
            let nucleusRadius: CGFloat = 22
            let nucleusRect = CGRect(
                x: center.x - nucleusRadius,
                y: center.y - nucleusRadius,
                width: nucleusRadius * 2,
                height: nucleusRadius * 2
            )
            
            context.fill(
                Path(ellipseIn: nucleusRect),
                with: .color(Theme.primaryRed)
            )
            
            // 3. Draw Orbiting Electrons on each Shell
            for (shellIndex, electronCount) in shells.enumerated() {
                let radius = radiusStep * CGFloat(shellIndex + 1)
                // Alternate rotation speed and direction per shell
                let direction: Double = (shellIndex % 2 == 0) ? 1.0 : -0.8
                let speedMultiplier = 1.0 + Double(shellIndex) * 0.25
                let currentAngle = (rotationAngle * speedMultiplier * direction) * (.pi / 180.0)
                
                let angleStep = (2.0 * .pi) / Double(max(1, electronCount))
                
                for electronIdx in 0..<electronCount {
                    let electronAngle = currentAngle + Double(electronIdx) * angleStep
                    let ex = center.x + radius * CGFloat(cos(electronAngle))
                    let ey = center.y + radius * CGFloat(sin(electronAngle))
                    
                    let electronRadius: CGFloat = 4.5
                    let eRect = CGRect(
                        x: ex - electronRadius,
                        y: ey - electronRadius,
                        width: electronRadius * 2,
                        height: electronRadius * 2
                    )
                    
                    // Electron Glow
                    context.fill(
                        Path(ellipseIn: eRect.insetBy(dx: -2, dy: -2)),
                        with: .color(Theme.primaryBlue.opacity(0.35))
                    )
                    // Core Electron Dot
                    context.fill(
                        Path(ellipseIn: eRect),
                        with: .color(Color.white)
                    )
                    context.stroke(
                        Path(ellipseIn: eRect),
                        with: .color(Theme.primaryBlue),
                        lineWidth: 1.2
                    )
                }
            }
        }
        .frame(height: 220)
        .background(
            RadialGradient(
                colors: [Color.blue.opacity(0.08), Color.clear],
                center: .center,
                startRadius: 20,
                endRadius: 120
            )
        )
        .overlay(
            // Center Symbol Tag
            Text(element.symbol)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
        )
    }
}
