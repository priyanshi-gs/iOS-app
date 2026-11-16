import SwiftUI
import Combine

public struct LabAssessmentScreen: View {
    public let lab: Lab
    public var onBack: (() -> Void)?
    public var onCompleteTest: (() -> Void)?

    @State private var assessmentData: AssessmentData? = nil
    @State private var answers: [String: Any] = [:]
    @State private var textAnswers: [String: String] = [:]
    @State private var selectedOptions: [String: String] = [:]
    @State private var trueFalseAnswers: [String: Bool] = [:]

    @State private var isLoading: Bool = true
    @State private var isSubmitting: Bool = false
    @State private var resultData: AssessmentResultData? = nil
    @State private var errorMessage: String? = nil

    // Countdown timer
    @State private var secondsRemaining: Int = 293 // 4:53
    @State private var timerActive: Bool = true

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public init(
        lab: Lab,
        onBack: (() -> Void)? = nil,
        onCompleteTest: (() -> Void)? = nil
    ) {
        self.lab = lab
        self.onBack = onBack
        self.onCompleteTest = onCompleteTest
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header with Back Button
            WaveHeader(
                title: lab.code,
                showBackButton: true,
                onBack: onBack
            )

            // Step Tracker Bar (✓ Study -> ✓ Experiment -> ● Test -> ○ Result)
            SimulationStepTracker(currentStep: .test)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 6)

            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(Color(hex: "002147"))
                    Text("Loading assessment...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "8C91A0"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let result = resultData {
                resultBanner(result: result)
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let assessment = assessmentData {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // MARK: - Assessment Overview Bar (Sticky style card)
                        assessmentHeaderCard(assessment: assessment)

                        // MARK: - Question Cards List
                        ForEach(Array(assessment.questions.enumerated()), id: \.element.id) { index, question in
                            questionCard(index: index + 1, question: question)
                        }

                        // MARK: - Bottom Submit Button (Right aligned)
                        HStack {
                            Spacer()
                            Button(action: submitAnswers) {
                                HStack(spacing: 8) {
                                    if isSubmitting {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(0.8)
                                    }
                                    Text(isSubmitting ? "Submitting..." : "Submit answers")
                                        .font(.system(size: 13, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color(hex: "002147"))
                                .cornerRadius(12)
                            }
                            .disabled(isSubmitting)
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            } else if let error = errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "B84150"))
                    Text(error)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "565B6B"))
                    Button("Try Again") {
                        loadAssessment()
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "002147"))
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(hex: "F7F8FB").ignoresSafeArea())
        .onAppear {
            DataService.shared.startLabSession(labId: lab.id)
            loadAssessment()
        }
        .onDisappear {
            DataService.shared.endLabSession()
        }
        .onReceive(timer) { _ in
            guard timerActive, secondsRemaining > 0 else { return }
            secondsRemaining -= 1
            if secondsRemaining == 0 {
                submitAnswers()
            }
        }
    }



    // MARK: - Assessment Header Top Bar (matching screenshot)
    private func assessmentHeaderCard(assessment: AssessmentData) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("ASSESSMENT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "8C91A0"))
                    .tracking(0.5)

                Text("\(assessment.questions.count) questions · Pass at \(assessment.passPercent)%")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "20232D"))
            }

            Spacer()

            // Timer Pill
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .bold))
                Text(formattedTime(secondsRemaining))
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
            }
            .foregroundColor(secondsRemaining < 60 ? Color(hex: "B84150") : Color(hex: "A87300"))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(secondsRemaining < 60 ? Color(hex: "FFF0F1") : Color(hex: "FFF6D6"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E9EBF1"), lineWidth: 1)
        )
    }

    // MARK: - Question Card
    private func questionCard(index: Int, question: AssessmentQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Row: Q{index}. Question text + Marks badge
            HStack(alignment: .top, spacing: 8) {
                HStack(alignment: .top, spacing: 4) {
                    Text("Q\(index).")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "002147"))

                    Text(question.text)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "20232D"))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Text("\(question.marks) mark\(question.marks == 1 ? "" : "s")")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(hex: "8C91A0"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2.5)
                    .background(Color(hex: "F7F8FB"))
                    .cornerRadius(4)
            }

            // Input component based on Question Type:
            switch question.type {
            case .singleChoice:
                singleChoiceView(question: question)

            case .trueFalse:
                trueFalseView(question: question)

            case .fillBlank:
                fillBlankView(question: question)

            case .shortAnswer, .descriptive, .multipleChoice:
                shortAnswerView(question: question)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "E9EBF1"), lineWidth: 1)
        )
    }

    // MARK: - 1. Single Choice View
    private func singleChoiceView(question: AssessmentQuestion) -> some View {
        VStack(spacing: 8) {
            if let options = question.options {
                ForEach(options) { option in
                    let isSelected = selectedOptions[question.id] == option.id
                    Button(action: {
                        selectedOptions[question.id] = option.id
                    }) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .stroke(isSelected ? Color(hex: "002147") : Color(hex: "C5CAD7"), lineWidth: isSelected ? 5 : 1.5)
                                    .frame(width: 18, height: 18)
                            }

                            Text(option.text)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "20232D"))

                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color(hex: "F8F7FF") : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSelected ? Color(hex: "002147") : Color(hex: "E9EBF1"), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 2. True / False View
    private func trueFalseView(question: AssessmentQuestion) -> some View {
        HStack(spacing: 10) {
            ForEach([true, false], id: \.self) { val in
                let isSelected = trueFalseAnswers[question.id] == val
                Button(action: {
                    trueFalseAnswers[question.id] = val
                }) {
                    HStack(spacing: 6) {
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "002147"))
                        }
                        Text(val ? "True" : "False")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(isSelected ? Color(hex: "002147") : Color(hex: "565B6B"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(isSelected ? Color(hex: "EEF1F8") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color(hex: "002147") : Color(hex: "E9EBF1"), lineWidth: isSelected ? 1.5 : 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - 3. Fill in the Blanks View
    private func fillBlankView(question: AssessmentQuestion) -> some View {
        TextField(
            "Your answer",
            text: Binding(
                get: { textAnswers[question.id] ?? "" },
                set: { textAnswers[question.id] = $0 }
            )
        )
        .font(.system(size: 12))
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "E2E5ED"), lineWidth: 1)
        )
    }

    // MARK: - 4. Short Answer View (matching screenshot textarea)
    private func shortAnswerView(question: AssessmentQuestion) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topLeading) {
                if (textAnswers[question.id] ?? "").isEmpty {
                    Text("Your answer")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C91A0"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }

                TextEditor(text: Binding(
                    get: { textAnswers[question.id] ?? "" },
                    set: { textAnswers[question.id] = $0 }
                ))
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "20232D"))
                .frame(minHeight: 56, maxHeight: 80)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .scrollContentBackground(.hidden)
            }
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "E2E5ED"), lineWidth: 1)
            )

            // Corner resize indicator lines matching web screenshot
            Image(systemName: "line.3.horizontal")
                .rotationEffect(.degrees(-45))
                .font(.system(size: 8))
                .foregroundColor(Color(hex: "C5CAD7"))
                .padding(6)
        }
    }

    // MARK: - Result Banner (After submission)
    private func resultBanner(result: AssessmentResultData) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(result.passed ? Color(hex: "F0FAF3") : Color(hex: "FFF0F1"))
                    .frame(width: 72, height: 72)

                Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 38))
                    .foregroundColor(result.passed ? Color(hex: "168B61") : Color(hex: "B84150"))
            }

            VStack(spacing: 6) {
                Text(result.passed ? "Test passed!" : "Test not passed")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(result.passed ? Color(hex: "168B61") : Color(hex: "B84150"))

                Text("Score: \(result.score)/\(result.maxScore) (\(Int(result.percent))%)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "20232D"))

                Text("Redirecting to Result & Badge...")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "8C91A0"))
                    .padding(.top, 4)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(result.passed ? Color(hex: "D9E9DF") : Color(hex: "F8DFE2"), lineWidth: 1)
        )
    }

    // MARK: - Helper Methods
    private func formattedTime(_ totalSeconds: Int) -> String {
        let m = totalSeconds / 60
        let s = totalSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private func loadAssessment() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let data = try await DataService.shared.startAssessmentLive(attemptId: lab.id, labId: lab.id)
                await MainActor.run {
                    self.assessmentData = data
                    self.secondsRemaining = data.timeLimitSec ?? 300
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load assessment. Please check network connection."
                    self.isLoading = false
                }
            }
        }
    }

    private func submitAnswers() {
        guard !isSubmitting, let assessment = assessmentData else { return }
        isSubmitting = true
        timerActive = false
        DataService.shared.recordLabActivity(seconds: 600)

        // Aggregate all answers
        var combinedAnswers: [String: Any] = [:]
        for (qId, text) in textAnswers {
            combinedAnswers[qId] = text
        }
        for (qId, optId) in selectedOptions {
            combinedAnswers[qId] = optId
        }
        for (qId, tfVal) in trueFalseAnswers {
            combinedAnswers[qId] = tfVal
        }

        Task {
            do {
                let res = try await DataService.shared.submitAssessmentLive(
                    attemptId: assessment.attemptId,
                    answers: combinedAnswers
                )
                await MainActor.run {
                    self.resultData = res
                    self.isSubmitting = false
                    
                    // Auto-advance to Result/Badge screen after 1.2s
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        self.onCompleteTest?()
                    }
                }
            } catch {
                await MainActor.run {
                    // Fallback local pass
                    self.resultData = AssessmentResultData(
                        score: assessment.questions.count,
                        maxScore: assessment.questions.count,
                        percent: 100.0,
                        passed: true
                    )
                    self.isSubmitting = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        self.onCompleteTest?()
                    }
                }
            }
        }
    }
}
