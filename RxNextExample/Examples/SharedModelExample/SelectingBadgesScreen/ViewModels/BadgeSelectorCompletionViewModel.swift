import RxSwift
import RxCocoa



class BadgeSelectorCompletionViewModel {
    typealias Dependency = (
        selectedBadgesRelay: RxCocoa.BehaviorRelay<[Badge]>,
        wireframe: BadgeSelectorWireframe
    )

    let canComplete: RxCocoa.Driver<Bool>


    private let dependency: Dependency
    private let disposeBag = DisposeBag()


    init(
        input doneTap: RxCocoa.Signal<Void>,
        dependency: Dependency
    ) {
        self.dependency = dependency

        self.canComplete = dependency.selectedBadgesRelay
            .map { selection in !selection.isEmpty }
            .asDriver(onErrorDriveWith: .empty())

        doneTap
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }

                self.dependency.wireframe.goToResultScreen(
                    with: self.dependency.selectedBadgesRelay.value
                )
            })
            .disposed(by: self.disposeBag)
    }
}