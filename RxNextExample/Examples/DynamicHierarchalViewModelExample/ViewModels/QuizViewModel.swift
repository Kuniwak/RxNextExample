import RxSwift
import RxCocoa



class QuizViewModel {
    typealias Input = (
        answerText: RxCocoa.Driver<String?>,
        answerDone: RxCocoa.Signal<Void>,
        submitTap: RxCocoa.Signal<Void>,
        resultShown: RxCocoa.Signal<Void>
    )
    let quiz: RxCocoa.Driver<Quiz>
    let submittedQuizResult: RxCocoa.Signal<QuizResult>
    let canEdit: RxCocoa.Driver<Bool>
    let canSubmit: RxCocoa.Driver<Bool>
    let shownQuizResult: RxCocoa.Signal<QuizResult>

    private let disposeBag = RxSwift.DisposeBag()


    init(
        input: Input,
        dependency quiz: Quiz
    ) {
        self.quiz = RxCocoa.Driver.just(quiz)

        let answerRelay = RxCocoa.BehaviorRelay<Int?>(value: nil)
        let answer = answerRelay.asDriver()
        let quizResultRelay = RxCocoa.BehaviorRelay<QuizResult?>(value: nil)
        let quizResult = quizResultRelay.asDriver()

        self.submittedQuizResult = RxCocoa.Signal
            .merge(
                input.answerDone,
                input.submitTap
            )
            .flatMap { answer -> RxCocoa.Signal<QuizResult> in
                guard let answer = answerRelay.value else { return .empty() }
                return .just(quiz.answer(value: answer))
            }
            .asSignal(onErrorSignalWith: .empty())

        self.shownQuizResult = input.resultShown
            .flatMap { _ -> RxCocoa.Driver<QuizResult> in
                guard let quizResult = quizResultRelay.value else { return .empty() }
                return .just(quizResult)
            }
            .asSignal(onErrorSignalWith: .empty())

        self.canEdit = quizResult
            .map { quizResult in quizResult == nil }
            .asDriver()

        self.canSubmit = answer
            .map { answer in answer != nil }
            .asDriver()

        self.submittedQuizResult
            .emit(onNext: { quizResult in
                quizResultRelay.accept(quizResult)
            })
            .disposed(by: self.disposeBag)

        input.answerText
            .map { answerText -> Int? in
                guard let answerText = answerText else { return nil }
                return Int(answerText)
            }
            .drive(answerRelay)
            .disposed(by: self.disposeBag)
    }
}