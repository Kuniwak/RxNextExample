import RxSwift
import RxCocoa


class SelectedBadgesScreenViewModel {
    typealias Dependency = (
        selectedModel: SelectedBadgesModel,
        wireframe: PresentedViewControllerWireframe
    )
    let selectedViewModel: ReadOnlySelectedBadgesViewModel

    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(
        input backTap: RxCocoa.Signal<Void>,
        dependency: Dependency
    ) {
        self.dependency = dependency
        self.selectedViewModel = ReadOnlySelectedBadgesViewModel(
            dependency: dependency.selectedModel
        )

        backTap
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dependency.wireframe.goBack()
            })
            .disposed(by: self.disposeBag)
    }
}
