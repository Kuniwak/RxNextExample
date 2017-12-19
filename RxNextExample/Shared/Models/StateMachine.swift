import RxSwift
import RxCocoa



class StateMachine<S> {
    fileprivate let stateRelay: RxCocoa.BehaviorRelay<S>
    let stateDidChange: Driver<S>


    var currentState: S {
        get { return self.stateRelay.value }
        set { self.stateRelay.accept(newValue) }
    }


    init(startingWith initialState: S) {
        let stateRelay = RxCocoa.BehaviorRelay(value: initialState)
        self.stateRelay = stateRelay
        self.stateDidChange = stateRelay.asDriver()
    }
}



extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
    func drive(stateMachine: StateMachine<Self.E>) -> RxSwift.Disposable {
        return self.drive(stateMachine.stateRelay)
    }
}
