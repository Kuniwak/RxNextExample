import RxSwift
import RxCocoa



class SelectableBadgesViewModel {
    typealias Dependency = (
        selectedModel: SelectedBadgesModel,
        selectableModel: SelectableBadgesModel
    )
    let selectableBadges: RxCocoa.Driver<[Badge]>

    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(
        input selectableTap: RxCocoa.Signal<Badge>,
        dependency: Dependency
    ) {
        self.dependency = dependency
        self.selectableBadges = dependency.selectableModel
            .selectableBadgesDidChange

        selectableTap
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                self.dependency.selectedModel.select(badge: badge)
            })
            .disposed(by: self.disposeBag)
    }
}
