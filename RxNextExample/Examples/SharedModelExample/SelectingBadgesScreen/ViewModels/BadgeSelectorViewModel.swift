import RxSwift
import RxCocoa



class BadgesSelectorViewModel {
    typealias Dependency = (
        repository: AnyEntityRepository<Void, [Badge], Never>,
        wireframe: BadgeSelectorWireframe
    )
    typealias Input = (
        doneTap: RxCocoa.Signal<Void>,
        selectedTap: RxCocoa.Signal<Badge>,
        selectableTap: RxCocoa.Signal<Badge>
    )

    // There are Child ViewModels.
    let selectedViewModel: SelectedBadgesViewModel
    let selectableViewModel: SelectableBadgesViewModel
    let completionViewModel: BadgeSelectorCompletionViewModel

    var currentSelectedBadges: [Badge] {
        return self.selectedBadgesRelay.value
    }

    private let allBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    private let selectableBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    private let disposeBag = RxSwift.DisposeBag()


    init(input: Input, dependency: Dependency) {
        let allBadgesRelay = RxCocoa.BehaviorRelay<[Badge]>(value: [])
        self.allBadgesRelay = allBadgesRelay
        let selectedBadgesRelay = RxCocoa.BehaviorRelay<[Badge]>(value: [])
        self.selectedBadgesRelay = selectedBadgesRelay
        let selectableBadgesRelay = RxCocoa.BehaviorRelay<[Badge]>(value: [])
        self.selectableBadgesRelay = selectableBadgesRelay

        self.selectedViewModel = SelectedBadgesViewModel(
            input: input.selectedTap,
            dependency: selectedBadgesRelay
        )

        self.selectableViewModel = SelectableBadgesViewModel(
            input: input.selectableTap,
            dependency: (
                selectedBadgesRelay: selectedBadgesRelay,
                selectableBadgesRelay: selectableBadgesRelay
            )
        )

        self.completionViewModel = BadgeSelectorCompletionViewModel(
            input: input.doneTap,
            dependency: (
                selectedBadgesRelay: selectedBadgesRelay,
                wireframe: dependency.wireframe
            )
        )

        dependency.repository
            .get(by: ())
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let `self` = self else { return }

                    switch result {
                    case let .success(badges):
                        self.allBadgesRelay.accept(badges)
                    case .failure:
                        break
                    }
                },
                onError: nil
            )
            .disposed(by: self.disposeBag)

        RxCocoa.Driver
            .combineLatest(
                allBadgesRelay.asDriver(),
                selectedBadgesRelay.asDriver(),
                resultSelector: { ($0, $1) }
            )
            .map { tuple -> [Badge] in
                let (allBadges, selectedBadges) = tuple
                return BadgesSelectorViewModel.dropSelected(
                    from: allBadges,
                    without: Set(selectedBadges)
                )
            }
            .drive(selectableBadgesRelay)
            .disposed(by: self.disposeBag)
    }


    private static func dropSelected(from allBadges: [Badge], without selectedBadges: Set<Badge>) -> [Badge] {
        return allBadges
            .filter { !selectedBadges.contains($0) }
    }
}