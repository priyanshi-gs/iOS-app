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
            // Positioned to precisely match the Figma mockup:
            // Sweeps down from the top edge, past the title level, and meets the wave edge at the trailing margin.
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.primaryRed, lineWidth: 24)
                        .frame(width: 175, height: 175)
                        .position(x: geo.size.width - 3, y: 4)
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

// Organic wave shape matching the Figma screen curve with mathematical precision:
// - Left edge starts at 89.5% height
// - Curves up to the left crest (at 15% width, 75.7% height) under the back chevron
// - Dips down into the center trough (at 47% width, 100% height) directly under the title
// - Curves up into the right crest (at 86% width, 71.0% height)
// - Descends to meet the right edge at 80% height where it meets the red ring
public struct OrganicWaveShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Right edge starts at 80% of rect.height
        let rightEdgeY = rect.height * 0.80
        path.addLine(to: CGPoint(x: rect.width, y: rightEdgeY))
        
        // Segment 1 (Right to Center):
        // Starts at right edge, sweeps through the right crest, and dips smoothly into the center trough
        path.addCurve(
            to: CGPoint(x: rect.width * 0.47, y: rect.height),
            control1: CGPoint(x: rect.width * 0.82, y: rect.height * 0.56),
            control2: CGPoint(x: rect.width * 0.65, y: rect.height * 0.96)
        )
        
        // Segment 2 (Center to Left):
        // Slopes up from the center trough, curves over the left crest, and lands gracefully on the left edge
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height * 0.895),
            control1: CGPoint(x: rect.width * 0.31, y: rect.height * 0.98),
            control2: CGPoint(x: rect.width * 0.16, y: rect.height * 0.55)
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
