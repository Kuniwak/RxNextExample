import RxSwift
import RxCocoa



class QuizzesViewModel {
    typealias Dependency = (
        allQuizEntriesModel: AllQuizEntriesModel,
        answerEntriesModel: AnswerEntriesModel,
        quizIndexModel: QuizIndexModel
    )

    let quizEntries: RxCocoa.Driver<[QuizEntry]>
    let currentQuizIndex: RxCocoa.Driver<Int>

    private var childViewModels: [ObjectIdentifier: (viewModel: QuizViewModel, disposeBag: RxSwift.DisposeBag)] = [:]
    private let quizResultAggregateRelay = RxCocoa.PublishRelay<(quizId: QuizEntry.Id, result: QuizResult)>()

    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(dependency: Dependency) {
        self.dependency = dependency

        self.currentQuizIndex = dependency.quizIndexModel
            .indexDidChange

        self.quizEntries = dependency.allQuizEntriesModel
            .stateDidChange
            .map { state -> [QuizEntry] in QuizzesViewModel.createQuizEntrySequence(from: state.value ?? [:]) }
            .asDriver()

        self.quizResultAggregateRelay
            .asSignal()
            .emit(onNext: { [weak self] quizIdAndQuizResult in
                guard let `self` = self else { return }

                self.dependency.answerEntriesModel.submit(
                    quizId: quizIdAndQuizResult.quizId,
                    result: quizIdAndQuizResult.result
                )
                self.dependency.quizIndexModel.next()
            })
            .disposed(by: self.disposeBag)
    }


    static func createQuizEntrySequence(from quizEntriesSet: [QuizEntry.Id: QuizEntry]) -> [QuizEntry] {
        return quizEntriesSet
            .sorted { $0.key.number > $1.key.number }
            .map { entry in entry.value }
    }
}



// These methods is for dynamic hierarchal ViewModels.
extension QuizzesViewModel {
    /// Create a new child ViewModel and start subscribing events from the child ViewModel.
    func createChildViewModel(input: QuizViewModel.Input, at index: Int) -> QuizViewModel? {
        let quizEntriesSet = self.dependency.allQuizEntriesModel.currentState.value ?? [:]
        let quizEntries = QuizzesViewModel.createQuizEntrySequence(from: quizEntriesSet)
        guard index < quizEntries.count else { return nil }

        let quizEntry = quizEntries[index]

        let childViewModel = QuizViewModel(
            input: input,
            dependency: quizEntry.quiz
        )

        self.addChildViewModel(childViewModel, for: quizEntry.id)

        return childViewModel
    }


    /// Start subscribing events from the child ViewModel.
    func addChildViewModel(_ childViewModel: QuizViewModel, for quizId: QuizEntry.Id) {
        let disposeBag = RxSwift.DisposeBag()

        childViewModel
            .shownQuizResult
            .map { result in (quizId: quizId, result: result) }
            .emit(to: self.quizResultAggregateRelay)
            .disposed(by: disposeBag)

        self.childViewModels[ObjectIdentifier(childViewModel)] = (
            viewModel: childViewModel,
            disposeBag: disposeBag
        )
    }


    /// Remove the specified child ViewModel and unsubscribe events from the child ViewModel.
    func removeChildViewModel(_ childViewModel: QuizViewModel) {
        // NOTE: It will trigger DisposeBag removal, so subscriptions of
        // child ViewModels will be removed together.
        self.childViewModels[ObjectIdentifier(childViewModel)] = nil
    }
}