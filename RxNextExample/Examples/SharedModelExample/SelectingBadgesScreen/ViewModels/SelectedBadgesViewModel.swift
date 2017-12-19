import RxSwift
import RxCocoa



class SelectedBadgesViewModel {
    let selectedBadges: RxCocoa.Driver<[Badge]>
    let badgeDidDeselect: RxCocoa.Signal<Badge>

    private let selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    private let badgeDidDeselectRelay: RxCocoa.PublishRelay<Badge>

    private let disposeBag = RxSwift.DisposeBag()


    init(
        input selectedTap: RxCocoa.Signal<Badge>,
        dependency selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>
    ) {
        self.selectedBadgesRelay = selectedBadgesRelay
        self.selectedBadges = selectedBadgesRelay.asDriver()

        let badgeDidDeselectRelay = RxCocoa.PublishRelay<Badge>()
        self.badgeDidDeselectRelay = badgeDidDeselectRelay
        self.badgeDidDeselect = badgeDidDeselectRelay.asSignal()

        selectedTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self,
                      let index = self.selectedBadgesRelay.value.index(of: badge) else { return }

                var newSelectedBadges = self.selectedBadgesRelay.value
                newSelectedBadges.remove(at: index)
                self.selectedBadgesRelay.accept(newSelectedBadges)

                self.badgeDidDeselectRelay.accept(badge)
            })
            .disposed(by: self.disposeBag)
    }
}
