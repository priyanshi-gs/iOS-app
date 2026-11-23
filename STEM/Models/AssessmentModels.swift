import Foundation

public enum QuestionType: String, Codable {
    case singleChoice = "SINGLE_CHOICE"
    case multipleChoice = "MULTIPLE_CHOICE"
    case trueFalse = "TRUE_FALSE"
    case fillBlank = "FILL_BLANK"
    case shortAnswer = "SHORT_ANSWER"
    case descriptive = "DESCRIPTIVE"
}

public struct QuestionOption: Identifiable, Codable {
    public let id: String
    public let text: String

    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}

public struct AssessmentQuestion: Identifiable, Codable {
    public let id: String
    public let type: QuestionType
    public let text: String
    public let options: [QuestionOption]?
    public let marks: Int
    public let order: Int

    public init(
        id: String = UUID().uuidString,
        type: QuestionType,
        text: String,
        options: [QuestionOption]? = nil,
        marks: Int = 1,
        order: Int = 1
    ) {
        self.id = id
        self.type = type
        self.text = text
        self.options = options
        self.marks = marks
        self.order = order
    }
}

public struct AssessmentData: Codable {
    public let attemptId: String
    public let timeLimitSec: Int?
    public let passPercent: Int
    public let questions: [AssessmentQuestion]

    public init(
        attemptId: String,
        timeLimitSec: Int? = 300,
        passPercent: Int = 50,
        questions: [AssessmentQuestion]
    ) {
        self.attemptId = attemptId
        self.timeLimitSec = timeLimitSec
        self.passPercent = passPercent
        self.questions = questions
    }
}

public struct AssessmentResultData: Codable {
    public let score: Int
    public let maxScore: Int
    public let percent: Double
    public let passed: Bool
    public let message: String?

    public init(
        score: Int,
        maxScore: Int,
        percent: Double,
        passed: Bool,
        message: String? = nil
    ) {
        self.score = score
        self.maxScore = maxScore
        self.percent = percent
        self.passed = passed
        self.message = message
    }
}
