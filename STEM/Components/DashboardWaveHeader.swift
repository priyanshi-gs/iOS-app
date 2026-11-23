import SwiftUI

// MARK: - Dashboard Waveform Header (Asymmetric Wave with Integrated Actions)
// Mathematically fitted to the reference design (Home & Browse Labs screens):
// - Expansive deep navy bed under the title & greeting to eliminate text clipping.
// - Gentle, organic upward S-curve to a high crest at x = 0.82, leaving white space for action cards.
// - Prominent crimson ring arc in the top-right corner.
// - Floating white action cards (notification bell with red dot + person profile) with subtle elevation.
public struct DashboardWaveHeader<RightContent: View>: View {
    public let icon: String
    public let title: String
    public let subtitlePrefix: String
    public let subtitleHighlight: String
    public var onNotificationTap: (() -> Void)? = nil
    public var onProfileTap: (() -> Void)? = nil
    public var customRightContent: RightContent? = nil

    // Standard initializer with built-in notification bell + profile tiles
    public init(
        icon: String = "house",
        title: String,
        subtitlePrefix: String = "Welcome, ",
        subtitleHighlight: String = "Student",
        onNotificationTap: (() -> Void)? = nil,
        onProfileTap: (() -> Void)? = nil
    ) where RightContent == EmptyView {
        self.icon = icon
        self.title = title
        self.subtitlePrefix = subtitlePrefix
        self.subtitleHighlight = subtitleHighlight
        self.onNotificationTap = onNotificationTap
        self.onProfileTap = onProfileTap
        self.customRightContent = nil
    }

    // Custom right content initializer
    public init(
        icon: String = "house",
        title: String,
        subtitlePrefix: String = "Welcome, ",
        subtitleHighlight: String = "Student",
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.icon = icon
        self.title = title
        self.subtitlePrefix = subtitlePrefix
        self.subtitleHighlight = subtitleHighlight
        self.onNotificationTap = nil
        self.onProfileTap = nil
        self.customRightContent = rightContent()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Soft Smooth Navy Organic Asymmetric Wave Background
            Theme.navyGradient
                .clipShape(DashboardWaveShape())
                .ignoresSafeArea(edges: .top)

            // 2. Signature Crimson Ring in the Top-Right Corner
            // Matches reference: sweeps down from top margin into the right edge
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.crimson, lineWidth: 22)
                        .frame(width: 165, height: 165)
                        .position(x: geo.size.width - 8, y: 18)
                }
                .clipShape(DashboardWaveShape())
            }
            .ignoresSafeArea(edges: .top)

            // 3. Header Foreground Elements
            HStack(alignment: .bottom, spacing: 0) {
                // Left Title & Subtitle inside the Deep Navy bed
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(title)
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 4) {
                        Text(subtitlePrefix)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)

                        Text(subtitleHighlight)
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(Theme.yellow)
                    }
                }
                .padding(.leading, 22)
                .padding(.bottom, 48) // Lifted title & greeting further above the wave line

                Spacer()

                // Right Action Tiles inside the Soft Wave contour
                HStack(spacing: 12) {
                    if let customRightContent = customRightContent {
                        customRightContent
                    } else {
                        // Bell Notification Tile with Red Dot
                        Button(action: { onNotificationTap?() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 42, height: 42)
                                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

                                ZStack(alignment: .topTrailing) {
                                    Image(systemName: "bell")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Theme.oxfordBlue)

                                    // Small red notification dot at top-right corner of bell
                                    Circle()
                                        .fill(Theme.crimson)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 4, y: -4)
                                }
                                .frame(width: 42, height: 42)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Profile / Person Tile
                        Button(action: { onProfileTap?() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 42, height: 42)
                                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

                                Image(systemName: "person")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Theme.oxfordBlue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 16)
            }
        }
        // Balanced compact height to leave generous screen real estate for home content
        .frame(height: 140)
    }
}

// MARK: - Asymmetric Dashboard Wave Shape
// Mathematical C1-continuous Bézier curve creating a soft, smooth, organic wave:
// - Left section cradles the title and welcome text smoothly (y: 0.88h -> 0.90h).
// - Transitions with collinear tangents through (0.52w, 0.76h) into a soft crest at (0.81w, 0.63h).
// - Gently curves down to 0.70h at the right margin, eliminating all sharp corners or kinks.
public struct DashboardWaveShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        // 1. Top-left origin
        path.move(to: CGPoint(x: 0, y: 0))

        // 2. Down left margin to deep wave start (y = 0.88h)
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.88))

        // 3. Segment 1: Soft, gentle curve cradling the title & welcome text (x: 0 -> 0.52)
        path.addCurve(
            to: CGPoint(x: rect.width * 0.52, y: rect.height * 0.76),
            control1: CGPoint(x: rect.width * 0.18, y: rect.height * 0.94),
            control2: CGPoint(x: rect.width * 0.36, y: rect.height * 0.88)
        )

        // 4. Segment 2: C1 smooth continuous sweep to the crest and right margin (x: 0.52 -> 1.0)
        // Collinear control1 gives silky continuity without any corner or kink
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.70),
            control1: CGPoint(x: rect.width * 0.68, y: rect.height * 0.64),
            control2: CGPoint(x: rect.width * 0.84, y: rect.height * 0.58)
        )

        // 5. Up right margin to top-right
        path.addLine(to: CGPoint(x: rect.width, y: 0))

        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack {
        DashboardWaveHeader(
            icon: "house",
            title: "Home",
            subtitlePrefix: "Welcome, ",
            subtitleHighlight: "Ratnam"
        )
        Spacer()
    }
    .background(Theme.screenBackground)
}
