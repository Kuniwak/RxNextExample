import RxCocoa



class ReadOnlySelectedBadgesViewModel {
    let selectedBadges: RxCocoa.Driver<[Badge]>


    init(dependency selectedBadges: [Badge]) {
        self.selectedBadges = .just(selectedBadges)
    }
}