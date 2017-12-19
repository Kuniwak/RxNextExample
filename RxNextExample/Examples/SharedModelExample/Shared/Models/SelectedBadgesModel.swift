import RxSwift
import RxCocoa



protocol SelectedBadgesModel {
    var selectionDidChange: RxCocoa.Driver<[Badge]> { get }
    var currentSelection: [Badge] { get }
    var badgeDidSelect: RxCocoa.Signal<Badge> { get }
    var badgeDidDeselect: RxCocoa.Signal<Badge> { get }

    func select(badge: Badge)
    func deselect(badge: Badge)
}



class DefaultSelectedBadgesModel: SelectedBadgesModel {
    private let stateMachine: StateMachine<[Badge]>
    private let badgeDidSelectRelay: RxCocoa.PublishRelay<Badge>
    private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>

    let badgeDidSelect: RxCocoa.Signal<Badge>
    let badgeDidDeselect: RxCocoa.Signal<Badge>
    let selectionDidChange: RxCocoa.Driver<[Badge]>


    var currentSelection: [Badge] {
        get { return self.stateMachine.currentState }
        set { self.stateMachine.currentState = newValue }
    }


    init(selected initialSelection: [Badge]) {
        self.stateMachine = StateMachine(
            startingWith: initialSelection
        )

        let badgeDidSelectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidSelectRelay = badgeDidSelectRelay
        self.badgeDidSelect = badgeDidSelectRelay.asSignal()

        let badgeDidDeselectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidDeselectRelay = badgeDidDeselectRelay
        self.badgeDidDeselect = badgeDidDeselectRelay.asSignal()

        self.selectionDidChange = stateMachine.stateDidChange
    }


    func select(badge: Badge) {
        guard !self.currentSelection.contains(badge) else { return }

        var newSelection = self.currentSelection
        newSelection.append(badge)

        self.currentSelection = newSelection

        self.badgeDidSelectRelay.accept(badge)
    }


    func deselect(badge: Badge) {
        var newSelection = self.currentSelection

        guard let index = newSelection.index(of: badge) else { return }

        newSelection.remove(at: index)

        self.currentSelection = newSelection

        self.badgeDidDeselectRelay.accept(badge)
    }
}