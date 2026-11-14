import SwiftUI

// MARK: - Dashboard Waveform Header (Asymmetric Wave with Integrated Actions)
// Used in high-level dashboard screens (Home tab, Browse Labs tab) as requested in Figma.
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
        subtitleHighlight: String = "Ratnam",
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
        subtitleHighlight: String = "Ratnam",
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
            // 1. Navy Organic Asymmetric Wave Background
            Theme.oxfordBlue
                .clipShape(DashboardWaveShape())
                .ignoresSafeArea(edges: .top)

            // 2. Signature Crimson Ring in the Top-Right Corner
            // Matches reference: thick crimson arc sweeping through the upper right edge
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.crimson, lineWidth: 24)
                        .frame(width: 175, height: 175)
                        .position(x: geo.size.width + 10, y: 15)
                }
                .clipShape(DashboardWaveShape())
            }
            .ignoresSafeArea(edges: .top)

            // 3. Header Foreground Elements
            HStack(alignment: .bottom, spacing: 0) {
                // Left Title & Subtitle inside the Deep Navy section
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: 21, weight: .bold))
                            .foregroundColor(.white)

                        Text(title)
                            .font(.system(size: 25, weight: .heavy))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 4) {
                        Text(subtitlePrefix)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        Text(subtitleHighlight)
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(Theme.yellow)
                    }
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)

                Spacer()

                // Right Action Tiles inside the White Space beneath the High Wave
                HStack(spacing: 12) {
                    if let customRightContent = customRightContent {
                        customRightContent
                    } else {
                        // Bell Notification Tile with Red Dot
                        Button(action: { onNotificationTap?() }) {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)

                                Image(systemName: "bell")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Theme.oxfordBlue)
                                    .frame(width: 44, height: 44)

                                // Red notification badge dot
                                Circle()
                                    .fill(Theme.crimson)
                                    .frame(width: 8, height: 8)
                                    .offset(x: -9, y: 9)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Profile / Person Tile
                        Button(action: { onProfileTap?() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)

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
        // Total height allows comfortable spacing for safe area, text, and wave contour
        .frame(height: 156)
    }
}

// MARK: - Asymmetric Dashboard Wave Shape
// Mathematical cubic Bézier curve fitted precisely to the reference design:
// - Left edge extends deep (95% height) to contain the icon, title, and "Welcome, [Name]".
// - Slopes through a gentle lower crest under the title text.
// - S-curves boldly upward to a high apex (42% height) at 78% width.
// - Gently curves down to 58% height at the right edge, exposing white space for action tiles.
public struct DashboardWaveShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        // 1. Top-left origin
        path.move(to: CGPoint(x: 0, y: 0))

        // 2. Down left margin to deep wave start
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.95))

        // 3. Segment 1: Gentle wave under the title & greeting
        path.addCurve(
            to: CGPoint(x: rect.width * 0.38, y: rect.height * 0.92),
            control1: CGPoint(x: rect.width * 0.12, y: rect.height * 0.84),
            control2: CGPoint(x: rect.width * 0.24, y: rect.height * 0.88)
        )

        // 4. Segment 2: Upward sweep to the high crest at x = 0.78
        path.addCurve(
            to: CGPoint(x: rect.width * 0.78, y: rect.height * 0.42),
            control1: CGPoint(x: rect.width * 0.50, y: rect.height * 0.96),
            control2: CGPoint(x: rect.width * 0.68, y: rect.height * 0.42)
        )

        // 5. Segment 3: Gentle downward roll to the right margin
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.58),
            control1: CGPoint(x: rect.width * 0.86, y: rect.height * 0.42),
            control2: CGPoint(x: rect.width * 0.96, y: rect.height * 0.52)
        )

        // 6. Up right margin to top-right
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
