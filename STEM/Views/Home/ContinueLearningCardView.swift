import SwiftUI

public struct ContinueLearningCardView: View {
    public let lab: Lab
    public let action: () -> Void

    public init(lab: Lab, action: @escaping () -> Void) {
        self.lab = lab
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Icon badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(hex: "0B2E59"))
                        .frame(width: 44, height: 44)

                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.yellow)
                }

                // Text info
                VStack(alignment: .leading, spacing: 3) {
                    Text("CONTINUE LEARNING")
                        .font(Theme.eyebrow(10))
                        .foregroundColor(Theme.yellow)
                        .tracking(0.8)

                    Text(lab.title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    let statusText = lab.status == .notStarted ? "In Progress" : lab.status.rawValue
                    Text("\(lab.subject.rawValue) • \(statusText)")
                        .font(Theme.caption(12))
                        .foregroundColor(Color(hex: "94A3B8"))
                }

                Spacer()

                // Launch circle button
                ZStack {
                    Circle()
                        .fill(Theme.yellow)
                        .frame(width: 32, height: 32)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.oxfordBlue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Theme.oxfordBlue)
                    .shadow(color: Theme.oxfordBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

