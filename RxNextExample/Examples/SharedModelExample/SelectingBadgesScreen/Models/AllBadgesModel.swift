import RxSwift
import RxCocoa



protocol AllBadgesModel: class {
    typealias State = EntityModelState<Void, [Badge], Never>

    var stateDidChange: RxCocoa.Driver<State> { get }
    var currentState: State { get }
}



class DefaultAllBadgesModel: AllBadgesModel {
    private let entityModel: EntityModel<Void, [Badge], Never>
    private let disposeBag = RxSwift.DisposeBag()


    let stateDidChange: RxCocoa.Driver<State>


    var currentState: State {
        return self.entityModel.currentState
    }


    init<Repository: BadgesRepository>(
        gettingBadgesVia repository: Repository
    ) where Repository.P == Void, Repository.V == [Badge], Repository.E == Never {
        self.entityModel = EntityModel<Void, [Badge], Never>(
            startingWith: .sleeping,
            gettingEntityBy: repository
        )
        self.stateDidChange = entityModel.stateDidChange

        self.entityModel.get(by: ())
    }
}
