import RxSwift



class QuizEntriesConstantRepository: QuizEntriesRepository {
    private let quizEntries: [QuizEntry.Id: QuizEntry]


    init(returning quizEntries: [QuizEntry.Id: QuizEntry]) {
        self.quizEntries = quizEntries
    }


    func get(by parameters: Void) -> RxSwift.Single<Result<[QuizEntry.Id: QuizEntry], Never>> {
        return .just(.success(self.quizEntries))
    }
}
