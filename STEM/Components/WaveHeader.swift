import SwiftUI

public struct WaveHeader: View {
    public let title: String
    public var showBackButton: Bool = true
    public var onBack: (() -> Void)? = nil
    public var trailingView: AnyView? = nil
    
    public init(
        title: String,
        showBackButton: Bool = true,
        onBack: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.trailingView = nil
    }
    
    public init<Trailing: View>(
        title: String,
        showBackButton: Bool = true,
        onBack: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.trailingView = AnyView(trailing())
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Soft Smooth Navy Organic Wave Background
            Theme.navyGradient
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
            
            // 3. Navigation Bar Content (Back button, Centered Title, and Trailing Actions)
            ZStack(alignment: .center) {
                // Centered Title
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 68)
                
                HStack(alignment: .center) {
                    if showBackButton {
                        LiquidCircleBackButton(action: { onBack?() })
                    } else {
                        Spacer().frame(width: 36)
                    }
                    
                    Spacer()
                    
                    if let trailingView = trailingView {
                        trailingView
                    } else {
                        Spacer().frame(width: 36)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        // Compact height so top blue area matches Figma precisely
        .frame(height: 54)
    }
}

// MARK: - Native Circular Back Button with Transparent Liquid Glass Effect
// Features a pure transparent liquid glass circle with realistic optical refraction,
// specular top highlight, subtle frosted glass base, and crisp bevel rim (no blue tint).
public struct LiquidCircleBackButton: View {
    public let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                // 1. Soft Ambient Depth Shadow (Natural translucent shadow, zero blue color)
                Circle()
                    .fill(Color.black.opacity(0.18))
                    .frame(width: 36, height: 36)
                    .blur(radius: 4)
                    .offset(y: 2)

                // 2. Translucent Frosted Glass Base (Zero blue tint, pure transparent liquid glass)
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 36, height: 36)

                // 3. Curved Specular Liquid Sheen (Light refraction from top edge)
                Circle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.40), location: 0.0),
                                .init(color: Color.white.opacity(0.12), location: 0.45),
                                .init(color: Color.white.opacity(0.0), location: 0.80)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 36, height: 36)

                // 4. Subtle Inner Specular Rim for 3D liquid curvature
                Circle()
                    .inset(by: 1.0)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        ),
                        lineWidth: 0.8
                    )
                    .frame(width: 36, height: 36)

                // 5. Crisp Outer Glass Bevel / Refraction Rim
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.70), location: 0.0),
                                .init(color: Color.white.opacity(0.20), location: 0.5),
                                .init(color: Color.white.opacity(0.40), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1.2
                    )
                    .frame(width: 36, height: 36)

                // 6. Native White Chevron Back Icon
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.25), radius: 1.5, x: 0, y: 1)
                    .offset(x: -1) // Optical center offset for left-pointing chevron
            }
            .contentShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Soft, smooth organic wave shape with continuous C1 curvature:
// - Left edge starts smoothly at 82% height
// - Curves through a gentle left crest (at 16% width, 76% height)
// - Dips into a smooth, rounded center trough (at 50% width, 92% height) with zero sharp corner / flat horizontal tangent
// - Curves gracefully through the right crest (at 84% width, 76% height)
// - Lands at right edge at 80% height where it meets the crimson ring
public struct OrganicWaveShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Right edge starts at 80% of rect.height
        let rightEdgeY = rect.height * 0.80
        path.addLine(to: CGPoint(x: rect.width, y: rightEdgeY))
        
        // Segment 1 (Right to Center Trough):
        // Starts at right edge, sweeps through the gentle right crest, and dips smoothly into the center trough
        // Horizontal tangent at x = 0.50, y = 0.92h prevents any sharp corner or V-notch
        path.addCurve(
            to: CGPoint(x: rect.width * 0.50, y: rect.height * 0.92),
            control1: CGPoint(x: rect.width * 0.84, y: rect.height * 0.68),
            control2: CGPoint(x: rect.width * 0.64, y: rect.height * 0.92)
        )
        
        // Segment 2 (Center to Left Edge):
        // Continuous horizontal takeoff from the center trough, curves over the soft left crest, and lands gracefully on the left edge
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height * 0.82),
            control1: CGPoint(x: rect.width * 0.36, y: rect.height * 0.92),
            control2: CGPoint(x: rect.width * 0.16, y: rect.height * 0.68)
        )
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack {
        WaveHeader(title: "Join STEM")
        Spacer()
    }
    .background(Theme.screenBackground)
}
