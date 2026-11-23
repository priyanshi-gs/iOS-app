import SwiftUI

// MARK: - Simulation Step Progression
public enum SimulationStep: Int, CaseIterable, Identifiable {
    case study = 1
    case experiment = 2
    case test = 3
    case result = 4

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .study: return "Study"
        case .experiment: return "Experiment"
        case .test: return "Test"
        case .result: return "Result"
        }
    }

    public var icon: String {
        switch self {
        case .study: return "book.closed.fill"
        case .experiment: return "flask.fill"
        case .test: return "doc.text.fill"
        case .result: return "medal.fill"
        }
    }
}

// MARK: - Unified Simulation Step Tracker Component
// Replaces disjointed floating text with a clean, elevated iOS segmented stepper card:
// - Completed steps: soft emerald badge with a bold checkmark (✓).
// - Active step: deep Oxford Navy pill with bright amber indicator dot and subtle elevation.
// - Upcoming steps: clean numbered circular badge with muted typography.
// - Connecting directional chevrons showing clear sequential progression (1 → 4).
public struct SimulationStepTracker: View {
    public let currentStep: SimulationStep
    public var onSelectStep: ((SimulationStep) -> Void)? = nil

    public init(currentStep: SimulationStep, onSelectStep: ((SimulationStep) -> Void)? = nil) {
        self.currentStep = currentStep
        self.onSelectStep = onSelectStep
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(SimulationStep.allCases.enumerated()), id: \.element) { index, step in
                stepItemView(for: step)

                if index < SimulationStep.allCases.count - 1 {
                    Spacer(minLength: 4)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(
                            step.rawValue < currentStep.rawValue
                                ? Theme.successGreen.opacity(0.65)
                                : Color(hex: "CBD5E1")
                        )

                    Spacer(minLength: 4)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(hex: "E8ECF2"), lineWidth: 1)
        )
    }

    // MARK: - Step Item View (Names only, no 1, 2, 3, 4 numbers, never clipped)
    @ViewBuilder
    private func stepItemView(for step: SimulationStep) -> some View {
        Button(action: {
            if step.rawValue <= currentStep.rawValue {
                onSelectStep?(step)
            }
        }) {
            if step == currentStep {
                // Active Step: High-contrast Oxford Navy capsule with glowing gold dot
                HStack(spacing: 5) {
                    Circle()
                        .fill(Theme.yellow)
                        .frame(width: 5, height: 5)

                    Text(step.title)
                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Theme.oxfordBlue, in: Capsule())
                .shadow(color: Theme.oxfordBlue.opacity(0.22), radius: 4, x: 0, y: 2)
            } else if step.rawValue < currentStep.rawValue {
                // Completed Step: Emerald checkmark + bold step title
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8.5, weight: .heavy))
                        .foregroundColor(Theme.successGreen)

                    Text(step.title)
                        .font(.system(size: 11.5, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.oxfordBlue)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            } else {
                // Upcoming Step: Clean step name only (No numbers 1, 2, 3, 4)
                Text(step.title)
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(step.rawValue > currentStep.rawValue)
        .fixedSize(horizontal: true, vertical: false) // Guarantee text never cuts off
    }
}

#if DEBUG
struct SimulationStepTracker_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SimulationStepTracker(currentStep: .study)
            SimulationStepTracker(currentStep: .experiment)
            SimulationStepTracker(currentStep: .test)
            SimulationStepTracker(currentStep: .result)
        }
        .padding()
        .background(Color(hex: "F8FAFC"))
    }
}
#endif
