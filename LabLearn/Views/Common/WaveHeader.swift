import SwiftUI

public struct WaveHeader<TrailingContent: View>: View {
    public let title: String
    public var subtitle: String? = nil
    public var showBackButton: Bool = false
    public var onBack: (() -> Void)? = nil
    public var height: CGFloat = 110
    public var trailing: TrailingContent
    
    public init(
        title: String,
        subtitle: String? = nil,
        showBackButton: Bool = false,
        onBack: (() -> Void)? = nil,
        height: CGFloat = 110,
        @ViewBuilder trailing: () -> TrailingContent = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.height = height
        self.trailing = trailing()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // Navy curved background
            Theme.navyBackground
                .clipShape(CurvedHeaderShape())
                .ignoresSafeArea(edges: .top)
            
            // Red accent arc on top right (signature Figma aesthetic)
            GeometryReader { geo in
                Circle()
                    .fill(Theme.primaryRed)
                    .frame(width: 90, height: 90)
                    .offset(x: geo.size.width - 50, y: -30)
                    .opacity(0.95)
            }
            .clipped()
            
            // Header Content
            VStack(spacing: 4) {
                HStack(alignment: .center) {
                    if showBackButton {
                        Button(action: { onBack?() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }
                    } else {
                        Spacer().frame(width: 36)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if TrailingContent.self != EmptyView.self {
                        trailing
                            .frame(width: 36, height: 36)
                    } else {
                        Spacer().frame(width: 36)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding(.top, 2)
                }
            }
        }
        .frame(height: height)
    }
}

public struct CurvedHeaderShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 24))
        
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - 24),
            control: CGPoint(x: rect.width / 2, y: rect.height + 12)
        )
        
        path.closeSubpath()
        return path
    }
}
