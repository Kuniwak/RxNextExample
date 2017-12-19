import RxSwift
import RxCocoa



protocol AllQuizEntriesModel {
    typealias State = EntityModelState<Void, [QuizEntry.Id: QuizEntry], Never>

    var stateDidChange: RxCocoa.Driver<State> { get }
    var currentState: State { get }
}



class DefaultAllQuizEntriesModel: AllQuizEntriesModel {
    private let entityModel: EntityModel<Void, [QuizEntry.Id: QuizEntry], Never>


    let stateDidChange: RxCocoa.Driver<State>


    var currentState: State {
        return self.entityModel.currentState
    }


    init<Repository: QuizEntriesRepository>(
        gettingQuizEntriesVia repository: Repository
    ) where Repository.P == Void, Repository.V == [QuizEntry.Id: QuizEntry], Repository.E == Never {
        self.entityModel = EntityModel<Void, [QuizEntry.Id: QuizEntry], Never>(
            startingWith: .sleeping,
            gettingEntityBy: repository
        )
        self.stateDidChange = entityModel.stateDidChange

        // NOTE: Kick first fetching.
        self.entityModel.get(by: ())
    }
}