import RxSwift
import RxCocoa



protocol SelectableBadgesModel {
    var selectableBadgesDidChange: RxCocoa.Driver<[Badge]> { get }
    var currentSelectableBadges: [Badge] { get }
}



class DefaultSelectableBadgesModel: SelectableBadgesModel {
    typealias Dependency = (
        allModel: AllBadgesModel,
        selectedModel: SelectedBadgesModel
    )
    private let disposeBag = RxSwift.DisposeBag()
    private let dependency: Dependency
    private let selectableBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>


    let selectableBadgesDidChange: RxCocoa.Driver<[Badge]>


    var currentSelectableBadges: [Badge] {
        return selectableBadgesRelay.value
    }


    init(dependency: Dependency) {
        self.dependency = dependency

        // NOTE: Use a BehaviorRelay because this model has a synchronous getter for
        // selected badges.
        let selectableBadgesRelay = RxCocoa.BehaviorRelay(
            value: DefaultSelectableBadgesModel.dropSelected(
                from: dependency.allModel.currentState.badges,
                without: Set(dependency.selectedModel.currentSelection)
            )
        )
        self.selectableBadgesRelay = selectableBadgesRelay
        self.selectableBadgesDidChange = selectableBadgesRelay.asDriver()

        RxCocoa.Driver
            .combineLatest(
                dependency.allModel.stateDidChange,
                dependency.selectedModel.selectionDidChange,
                resultSelector: { ($0, $1) }
            )
            .map { tuple -> [Badge] in
                let (allBadgesModelState, selectedBadges) = tuple
                return DefaultSelectableBadgesModel.dropSelected(
                    from: allBadgesModelState.badges,
                    without: Set(selectedBadges)
                )
            }
            .drive(self.selectableBadgesRelay)
            .disposed(by: self.disposeBag)
    }


    private static func dropSelected(from allBadges: [Badge], without selectedBadges: Set<Badge>) -> [Badge] {
        return allBadges
            .filter { !selectedBadges.contains($0) }
    }
}