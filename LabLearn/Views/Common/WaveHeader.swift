import SwiftUI

public struct WaveHeader: View {
    public let title: String
    public var showBackButton: Bool = true
    public var onBack: (() -> Void)? = nil
    
    public init(
        title: String,
        showBackButton: Bool = true,
        onBack: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Navy Organic Wave Background (covers safe area + compact nav bar height)
            Theme.navyBackground
                .clipShape(OrganicWaveShape())
                .ignoresSafeArea(edges: .top)
            
            // 2. Signature Crimson Ring in the Top-Right
            // Positioned deeper and lower so the bold red crescent sweeps into the right side
            // of the header beside the title and down towards the wave boundary, matching Figma.
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.primaryRed, lineWidth: 24)
                        .frame(width: 170, height: 170)
                        .position(x: geo.size.width + 10, y: 15)
                }
                .clipShape(OrganicWaveShape())
            }
            .ignoresSafeArea(edges: .top)
            
            // 3. Navigation Bar Content (Back button & Centered Title)
            HStack(alignment: .center) {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                } else {
                    Spacer().frame(width: 36)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Balance space on trailing side
                Spacer().frame(width: 36)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        // Compact height so top blue area matches Figma precisely
        .frame(height: 54)
    }
}

// Organic wave shape matching the Figma screen curve exactly
public struct OrganicWaveShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Right edge starts at ~75% of rect.height
        let rightEdgeY = rect.height * 0.75
        path.addLine(to: CGPoint(x: rect.width, y: rightEdgeY))
        
        // Exact organic wave from Figma:
        // Curves from right edge through center scoop to left edge
        path.addCurve(
            to: CGPoint(x: rect.width * 0.44, y: rect.height),
            control1: CGPoint(x: rect.width * 0.85, y: rect.height * 0.60),
            control2: CGPoint(x: rect.width * 0.65, y: rect.height * 1.02)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height * 0.88),
            control1: CGPoint(x: rect.width * 0.26, y: rect.height * 0.98),
            control2: CGPoint(x: rect.width * 0.12, y: rect.height * 0.72)
        )
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack {
        WaveHeader(title: "Join LabLearn")
        Spacer()
    }
    .background(Theme.screenBackground)
}
