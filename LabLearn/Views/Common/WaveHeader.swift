import SwiftUI

public struct WaveHeader: View {
    public let title: String
    public var showBackButton: Bool = true
    public var onBack: (() -> Void)? = nil
    public var height: CGFloat = 125
    
    public init(
        title: String,
        showBackButton: Bool = true,
        onBack: (() -> Void)? = nil,
        height: CGFloat = 125
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.height = height
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // Navy wave background
            Theme.navyBackground
                .clipShape(OrganicWaveShape())
                .ignoresSafeArea(edges: .top)
            
            // Signature Crimson Curved Arc on top-right
            GeometryReader { geo in
                ZStack {
                    // Thick red arc
                    Circle()
                        .stroke(Theme.primaryRed, lineWidth: 14)
                        .frame(width: 110, height: 110)
                        .offset(x: geo.size.width - 45, y: -25)
                }
            }
            .clipped()
            
            // Header Content: Back Button & Title
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40, alignment: .leading)
                    }
                } else {
                    Spacer().frame(width: 40)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Balance space on trailing side
                Spacer().frame(width: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
        }
        .frame(height: height)
    }
}

// Organic wave shape matching the Figma screen curve
public struct OrganicWaveShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 28))
        
        // Smooth downward dipping wave curve
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height - 24),
            control1: CGPoint(x: rect.width * 0.65, y: rect.height + 14),
            control2: CGPoint(x: rect.width * 0.35, y: rect.height - 48)
        )
        
        path.closeSubpath()
        return path
    }
}
