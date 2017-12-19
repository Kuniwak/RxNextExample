import RxSwift
import RxCocoa



class BadgesSelectorViewModel {
    typealias Dependency = (
        selectedModel: SelectedBadgesModel,
        selectableModel: SelectableBadgesModel,
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

    private let disposeBag = RxSwift.DisposeBag()


    init(input: Input, dependency: Dependency) {
        // This is a Model shared between 2 ViewModels.
        let selectedModel = dependency.selectedModel

        self.selectedViewModel = SelectedBadgesViewModel(
            input: input.selectedTap,
            dependency: selectedModel // Sharing the Model.
        )

        self.selectableViewModel = SelectableBadgesViewModel(
            input: input.selectableTap,
            dependency: (
                selectedModel: selectedModel, // Sharing the Model.
                selectableModel: dependency.selectableModel
            )
        )

        self.completionViewModel = BadgeSelectorCompletionViewModel(
            input: input.doneTap,
            dependency: (
                selectedModel: selectedModel, // Sharing the Model.
                wireframe: dependency.wireframe
            )
        )
    }
}