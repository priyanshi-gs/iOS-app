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
            
            // 2. Signature Crimson Ring in the Top-Right (anchored in the top-right safe area corner)
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.primaryRed, lineWidth: 15)
                        .frame(width: 110, height: 110)
                        // Positioned so the inner curve sweeps across the top right of the blue area
                        .position(x: geo.size.width - 15, y: -5)
                }
            }
            .clipped()
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
        // Compact height so top blue area is not overly tall and matches Figma
        .frame(height: 54)
    }
}

// Organic wave shape matching the Figma screen curve exactly
public struct OrganicWaveShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Right side starts slightly higher (around y = rect.height - 18)
        let rightEdgeY = rect.height - 18
        path.addLine(to: CGPoint(x: rect.width, y: rightEdgeY))
        
        // Exact curve from Figma:
        // Swoops gently down under the centered title and slopes smoothly to the left
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height - 10),
            control1: CGPoint(x: rect.width * 0.70, y: rect.height - 24),
            control2: CGPoint(x: rect.width * 0.38, y: rect.height + 8)
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
