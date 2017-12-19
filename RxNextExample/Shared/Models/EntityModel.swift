import RxSwift
import RxCocoa



class EntityModel<Parameters, Value, Reason> {
    typealias P = Parameters
    typealias V = Value
    typealias E = Reason

    let stateDidChange: RxCocoa.Driver<EntityModelState<P, V, E>>

    private let stateMachine: StateMachine<EntityModelState<P, V, E>>
    private let repository: AnyEntityRepository<P, V, E>
    private let disposeBag = RxSwift.DisposeBag()


    var currentState: EntityModelState<P, V, E> {
        get { return self.stateMachine.currentState }
        set { self.stateMachine.currentState = newValue }
    }


    init<Repository: EntityModelRepository>(
        startingWith initialState: EntityModelState<P, V, E>,
        gettingEntityBy repository: Repository
    ) where Repository.P == Parameters, Repository.V == Value, Repository.E == Reason {
        self.stateMachine = StateMachine(startingWith: initialState)
        self.stateDidChange = stateMachine.stateDidChange
        self.repository = repository.asAny()
    }


    func get(by parameters: P) {
        self.repository
            .get(by: parameters)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }

                    switch response {
                    case let .success(value):
                        self.currentState = .fulfilled(by: value)
                    case let .failure(error):
                        self.currentState = .rejected(because: .causedByRepository(error: error))
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }

                    self.currentState = .rejected(because: .causedBySingle(error: error))
                }
            )
            .disposed(by: self.disposeBag)
    }
}



indirect enum EntityModelState<P, V, E> {
    case sleeping
    case triggered(by: P)
    case fulfilled(by: V)
    case rejected(because: Reason<E>)


    var isPending: Bool {
        switch self {
        case .sleeping, .triggered:
            return true
        case .fulfilled, .rejected:
            return false
        }
    }


    var isCompleted: Bool {
        return !self.isPending
    }


    var parameters: P? {
        switch self {
        case let .triggered(by: parameters):
            return parameters
        case .sleeping, .fulfilled, .rejected:
            return nil
        }
    }


    var value: V? {
        switch self {
        case let .fulfilled(by: value):
            return value
        case .sleeping, .triggered, .rejected:
            return nil
        }
    }


    var reason: Reason<E>? {
        switch self {
        case let .rejected(because: reason):
            return reason
        case .sleeping, .triggered, .fulfilled:
            return nil
        }
    }


    enum Reason<E> {
        case causedBySingle(error: Error)
        case causedByRepository(error: E)
    }
}
