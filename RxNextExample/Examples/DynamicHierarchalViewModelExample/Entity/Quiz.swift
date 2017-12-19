enum Quiz: Equatable {
    case addition(AdditionQuiz)
    case multiplication(MultiplicationQuiz)


    var question: String {
        switch self {
        case let .addition(quiz):
            return quiz.question
        case let .multiplication(quiz):
            return quiz.question
        }
    }


    func answer(value: Int) -> QuizResult {
        switch self {
        case let .addition(quiz):
            return quiz.answer(value: value)
        case let .multiplication(quiz):
            return quiz.answer(value: value)
        }
    }


    static func ==(lhs: Quiz, rhs: Quiz) -> Bool {
        switch (lhs, rhs) {
        case let (.addition(l), .addition(r)):
            return l == r
        case let (.multiplication(l), .multiplication(r)):
            return l == r
        default:
            return false
        }
    }
}



struct AdditionQuiz: Equatable {
    let value1: Int
    let value2: Int


    var question: String {
        return "\(self.value1) + \(self.value2) = ?"
    }


    func answer(value: Int) -> QuizResult {
        return self.value1 + self.value2 == value
            ? .correct
            : .wrong
    }


    static func ==(lhs: AdditionQuiz, rhs: AdditionQuiz) -> Bool {
        return lhs.value1 == rhs.value1
            && lhs.value2 == rhs.value2
    }
}



struct MultiplicationQuiz: Equatable {
    let value1: Int
    let value2: Int


    var question: String {
        return "\(self.value1) × \(self.value2) = ?"
    }


    func answer(value: Int) -> QuizResult {
        return self.value1 * self.value2 == value
            ? .correct
            : .wrong
    }


    static func ==(lhs: MultiplicationQuiz, rhs: MultiplicationQuiz) -> Bool {
        return lhs.value1 == rhs.value1
            && lhs.value2 == rhs.value2
    }
}



enum QuizResult: Equatable {
    case correct
    case wrong
}
