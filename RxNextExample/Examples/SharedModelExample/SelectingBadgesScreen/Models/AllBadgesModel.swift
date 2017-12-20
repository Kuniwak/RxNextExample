import RxSwift
import RxCocoa



protocol AllBadgesModel: class {
    var stateDidChange: RxCocoa.Driver<AllBadgesModelState> { get }
    var currentState: AllBadgesModelState { get }
}



enum AllBadgesModelState {
    case notFetchedYet
    case fetching
    case fetched(result: Result<[Badge], FailureReason>)


    var badges: [Badge] {
        switch self {
        case let .fetched(result: .success(badges)):
            return badges
        case .notFetchedYet, .fetching, .fetched(result: .failure):
            return []
        }
    }


    var isFetching: Bool {
        switch self {
        case .fetching:
            return true
        case .notFetchedYet, .fetched:
            return false
        }
    }


    enum FailureReason {
        case unspecified(debugInfo: String)
    }
}



class DefaultAllBadgesModel: AllBadgesModel {
    let stateDidChange: RxCocoa.Driver<AllBadgesModelState>


    var currentState: AllBadgesModelState {
        get { return self.stateRelay.value }
        set { self.stateRelay.accept(newValue) }
    }


    private let stateRelay: RxCocoa.BehaviorRelay<AllBadgesModelState>
    private let repository: BadgesRepository
    private let disposeBag = RxSwift.DisposeBag()


    init(gettingBadgesVia repository: BadgesRepository) {
        self.repository = repository
        self.stateRelay = RxCocoa.BehaviorRelay<AllBadgesModelState>(value: .notFetchedYet)
        self.stateDidChange = stateRelay.asDriver()

        self.fetch()
    }


    private func fetch() {
        guard !self.currentState.isFetching else { return }
        self.currentState = .fetching

        self.repository
            .get(count: 100)
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let `self` = self else { return }

                    switch result {
                    case let .success(badges):
                        self.currentState = .fetched(result: .success(badges))

                    case let .failure(reason):
                        self.currentState = .fetched(result: .failure(.unspecified(debugInfo: "\(reason)")))
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }

                    self.currentState = .fetched(result: .failure(.unspecified(debugInfo: "\(error)")))
                }
            )
            .disposed(by: self.disposeBag)
    }
}
