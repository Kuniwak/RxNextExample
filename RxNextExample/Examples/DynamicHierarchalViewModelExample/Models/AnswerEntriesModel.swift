import RxSwift
import RxCocoa



protocol AnswerEntriesModel {
    var answersDidChange: RxCocoa.Driver<[QuizEntry.Id: AnswerEntry]> { get }
    var currentAnswers: [QuizEntry.Id: AnswerEntry] { get }

    func submit(quizId: QuizEntry.Id, result: QuizResult)
}



class DefaultAnswerEntriesModel: AnswerEntriesModel {
    private let stateMachine: StateMachine<[QuizEntry.Id: AnswerEntry]>


    let answersDidChange: Driver<[QuizEntry.Id: AnswerEntry]>


    var currentAnswers: [QuizEntry.Id: AnswerEntry] {
        get { return self.stateMachine.currentState }
        set { self.stateMachine.currentState = newValue }
    }


    init(
        startingWith initialAnswerEntries: [QuizEntry.Id: AnswerEntry]
    ) {
        self.stateMachine = StateMachine(startingWith: initialAnswerEntries)
        self.answersDidChange = stateMachine.stateDidChange
    }


    func submit(quizId: QuizEntry.Id, result: QuizResult) {
        let answerEntry = AnswerEntry(
            quizId: quizId,
            result: result
        )

        var newAnswers = self.currentAnswers
        newAnswers[quizId] = answerEntry
        self.currentAnswers = newAnswers
    }
}