import RxSwift
import RxCocoa



class SelectedBadgesViewModel {
    let selectedBadges: RxCocoa.Driver<[Badge]>
    let badgeDidSelect: RxCocoa.Signal<Badge>
    let badgeDidDeselect: RxCocoa.Signal<Badge>

    private let selectedModel: SelectedBadgesModel
    private let disposeBag = RxSwift.DisposeBag()


    init(
        input selectedTap: RxCocoa.Signal<Badge>,
        dependency selectedModel: SelectedBadgesModel
    ) {
        self.selectedModel = selectedModel
        self.selectedBadges = selectedModel.selectionDidChange
        self.badgeDidSelect = selectedModel.badgeDidSelect
        self.badgeDidDeselect = selectedModel.badgeDidDeselect

        selectedTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                self.selectedModel.deselect(badge: badge)
            })
            .disposed(by: self.disposeBag)
    }
}
