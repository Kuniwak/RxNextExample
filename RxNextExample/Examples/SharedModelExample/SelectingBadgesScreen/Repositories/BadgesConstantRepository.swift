import RxSwift



class BadgesConstantRepository: BadgesRepository {
    private let badges: [Badge]


    init(returning badges: [Badge]) {
        self.badges = badges
    }


    func get(count: Int) -> Single<Result<[Badge], BadgesRepositoryFailureReason>> {
        return .just(.success(self.badges))
    }
}
