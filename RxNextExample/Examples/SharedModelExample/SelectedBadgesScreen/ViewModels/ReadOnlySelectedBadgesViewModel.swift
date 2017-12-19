import RxCocoa



class ReadOnlySelectedBadgesViewModel {
    let selectedBadges: RxCocoa.Driver<[Badge]>

    private let selectedModel: SelectedBadgesModel


    init(dependency selectedModel: SelectedBadgesModel) {
        self.selectedModel = selectedModel
        self.selectedBadges = selectedModel.selectionDidChange
    }
}