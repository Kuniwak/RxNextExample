import RxSwift



class BadgesConstantRepository: BadgesRepository {
    private let badges: [Badge]


    init(returning badges: [Badge]) {
        self.badges = badges
    }


    func get(by parameters: Void) -> RxSwift.Single<Result<[Badge], Never>> {
        return .just(.success(self.badges))
    }
}
