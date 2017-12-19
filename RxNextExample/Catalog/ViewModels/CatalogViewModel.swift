import RxSwift
import RxCocoa



class CatalogViewModel {
    typealias Input = RxCocoa.Signal<Int>
    private let disposeBag = RxSwift.DisposeBag()


    let screenRelay: RxCocoa.BehaviorRelay<[ExampleScreen]>
    let screens: RxCocoa.Driver<[ExampleScreen]>


    init(input indexSelected: Input, dependency wireframe: CatalogWireframe) {
        let screenRelay = BehaviorRelay(value: ExampleScreen.all)

        self.screenRelay = screenRelay
        self.screens = screenRelay.asDriver()

        indexSelected
            .emit(onNext: { [weak self] index in
                guard let `self` = self else { return }
                let screens = self.screenRelay.value

                switch screens[index] {
                case .simple:
                    wireframe.goToSimpleExampleScreen()
                case .sharedModel:
                    wireframe.goToSharedModelExampleScreen()
                case .dynamicHierarchalViewModel:
                    wireframe.goToHierarchalViewModelExampleScreen()
                }
            })
            .disposed(by: self.disposeBag)
    }
}