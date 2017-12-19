import RxSwift
import RxCocoa



class SelectableBadgesViewModel {
    typealias Dependency = (
        selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>,
        selectableBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    )
    let badgeDidSelect: RxCocoa.Signal<Badge>
    let selectableBadges: RxCocoa.Driver<[Badge]>

    private let badgeDidSelectRelay: RxCocoa.PublishRelay<Badge>
    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(
        input selectableTap: RxCocoa.Signal<Badge>,
        dependency: Dependency
    ) {
        self.dependency = dependency

        let badgeDidSelectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidSelectRelay = badgeDidSelectRelay
        self.badgeDidSelect = badgeDidSelectRelay.asSignal()

        self.selectableBadges = dependency.selectableBadgesRelay.asDriver()

        selectableTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                var newSelectedBadges = self.dependency.selectedBadgesRelay.value
                newSelectedBadges.append(badge)
                self.dependency.selectedBadgesRelay.accept(newSelectedBadges)

                self.badgeDidSelectRelay.accept(badge)
            })
            .disposed(by: self.disposeBag)
    }
}
