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

    let badgeDidSelect: RxCocoa.Signal<Badge>
    let badgeDidDeselect: RxCocoa.Signal<Badge>
    let canComplete: RxCocoa.Driver<Bool>
    let selectedBadges: RxCocoa.Driver<[Badge]>
    let selectableBadges: RxCocoa.Driver<[Badge]>

    var currentSelectedBadges: [Badge] {
        return self.selectedBadgesRelay.value
    }

    private let badgeDidSelectRelay: RxCocoa.PublishRelay<Badge>
    private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>
    private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(input: Input, dependency: Dependency) {
        self.dependency = dependency

        let badgeDidSelectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidSelectRelay = badgeDidSelectRelay
        self.badgeDidSelect = badgeDidSelectRelay.asSignal()

        let badgeDidDeselectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidDeselectRelay = badgeDidDeselectRelay
        self.badgeDidDeselect = badgeDidDeselectRelay.asSignal()

        let selectedBadgesRelay = RxCocoa.BehaviorRelay<[Badge]>(value: [])
        self.selectedBadgesRelay = selectedBadgesRelay
        let selectedBadges = selectedBadgesRelay.asDriver()
        self.selectedBadges = selectedBadges

        let allBadgesRelay = RxCocoa.BehaviorRelay<[Badge]>(value: [])
        let allBadges = allBadgesRelay.asDriver()

        dependency.repository
            .get(by: ())
            .subscribe(
                onSuccess: { result in
                    switch result {
                    case let .success(badges):
                        allBadgesRelay.accept(badges)
                    case .failure:
                        break
                    }
                },
                onError: nil
            )
            .disposed(by: self.disposeBag)

        self.selectableBadges = RxCocoa.Driver
            .combineLatest(
                allBadges,
                selectedBadges,
                resultSelector: { ($0, $1) }
            )
            .map { tuple -> [Badge] in
                let (allBadges, selectedBadges) = tuple
                return BadgesSelectorViewModel.dropSelected(
                    from: allBadges,
                    without: Set(selectedBadges)
                )
            }

        self.canComplete = selectedBadges
            .map { selection in !selection.isEmpty }
            .asDriver()

        input.doneTap
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }

                self.dependency.wireframe.goToResultScreen(
                    with: selectedBadgesRelay.value
                )
            })
            .disposed(by: self.disposeBag)

        input.selectedTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                self.deselect(badge: badge)
            })
            .disposed(by: self.disposeBag)

        input.selectableTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                self.select(badge: badge)
            })
            .disposed(by: self.disposeBag)
    }


    private func select(badge: Badge) {
        let currentSelection = self.selectedBadgesRelay.value
        guard !currentSelection.contains(badge) else { return }

        var newSelection = currentSelection
        newSelection.append(badge)

        self.selectedBadgesRelay.accept(newSelection)
        self.badgeDidSelectRelay.accept(badge)
    }


    private func deselect(badge: Badge) {
        let currentSelection = self.selectedBadgesRelay.value
        var newSelection = currentSelection

        guard let index = newSelection.index(of: badge) else { return }

        newSelection.remove(at: index)

        self.selectedBadgesRelay.accept(newSelection)
        self.badgeDidDeselectRelay.accept(badge)
    }


    private static func dropSelected(from allBadges: [Badge], without selectedBadges: Set<Badge>) -> [Badge] {
        return allBadges
            .filter { !selectedBadges.contains($0) }
    }
}