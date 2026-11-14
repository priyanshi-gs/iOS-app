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
            // Matches reference: sweeps down from top margin into the right edge
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(Theme.crimson, lineWidth: 26)
                        .frame(width: 190, height: 190)
                        .position(x: geo.size.width - 15, y: 25)
                }
                .clipShape(DashboardWaveShape())
            }
            .ignoresSafeArea(edges: .top)

            // 3. Header Foreground Elements
            HStack(alignment: .bottom, spacing: 0) {
                // Left Title & Subtitle inside the Deep Navy bed
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Text(title)
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
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
                .padding(.leading, 24)
                .padding(.bottom, 24) // Generous clearance so text is well above the wave!

                Spacer()

                // Right Action Tiles inside the White Space beneath the High Wave
                HStack(spacing: 12) {
                    if let customRightContent = customRightContent {
                        customRightContent
                    } else {
                        // Bell Notification Tile with Red Dot
                        Button(action: { onNotificationTap?() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)

                                ZStack(alignment: .topTrailing) {
                                    Image(systemName: "bell")
                                        .font(.system(size: 19, weight: .semibold))
                                        .foregroundColor(Theme.oxfordBlue)

                                    // Small red notification dot at top-right corner of bell
                                    Circle()
                                        .fill(Theme.crimson)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 4, y: -4)
                                }
                                .frame(width: 44, height: 44)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Profile / Person Tile
                        Button(action: { onProfileTap?() }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)

                                Image(systemName: "person")
                                    .font(.system(size: 19, weight: .semibold))
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
        // Total frame height below safe area, giving generous room for text and the wave contour
        .frame(height: 135)
    }
}

// MARK: - Asymmetric Dashboard Wave Shape
// Mathematical cubic Bézier curve fitted precisely to the reference design (Photo 2):
// - Left section stays deep (94% - 98% height) across the entire text area (x = 0 to 0.44),
//   providing a solid, un-clipped navy background behind the title and greeting.
// - Sweeps smoothly upward via an S-curve to a high crest at x = 0.82, y = 0.42h.
// - Rolls down softly to y = 0.56h at the right margin, creating ample white space for action cards.
public struct DashboardWaveShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        // 1. Top-left origin
        path.move(to: CGPoint(x: 0, y: 0))

        // 2. Down left margin to deep wave start (y = 0.98h)
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.98))

        // 3. Segment 1: Stays deep across the entire text section (x: 0 -> 0.44)
        path.addCurve(
            to: CGPoint(x: rect.width * 0.44, y: rect.height * 0.94),
            control1: CGPoint(x: rect.width * 0.16, y: rect.height * 0.91),
            control2: CGPoint(x: rect.width * 0.30, y: rect.height * 0.95)
        )

        // 4. Segment 2: Smooth upward S-curve sweep to the apex crest (x: 0.44 -> 0.82)
        // Arrives with horizontal tangency at x = 0.82, y = 0.42h
        path.addCurve(
            to: CGPoint(x: rect.width * 0.82, y: rect.height * 0.42),
            control1: CGPoint(x: rect.width * 0.58, y: rect.height * 0.92),
            control2: CGPoint(x: rect.width * 0.70, y: rect.height * 0.42)
        )

        // 5. Segment 3: Gentle downward roll to the right margin (x: 0.82 -> 1.0)
        // Leaves horizontally and curves down to y = 0.56h
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.56),
            control1: CGPoint(x: rect.width * 0.90, y: rect.height * 0.42),
            control2: CGPoint(x: rect.width * 0.96, y: rect.height * 0.50)
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
