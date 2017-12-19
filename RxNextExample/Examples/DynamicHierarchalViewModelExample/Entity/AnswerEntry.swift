struct AnswerEntry: Hashable {
    let quizId: QuizEntry.Id
    let result: QuizResult


    var hashValue: Int {
        return self.quizId.number
    }


    static func ==(lhs: AnswerEntry, rhs: AnswerEntry) -> Bool {
        return lhs.quizId == rhs.quizId
            && lhs.result == rhs.result
    }
}