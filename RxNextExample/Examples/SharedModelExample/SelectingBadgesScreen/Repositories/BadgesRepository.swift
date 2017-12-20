import RxSwift



protocol BadgesRepository {
    func get(count: Int) -> RxSwift.Single<Result<[Badge], BadgesRepositoryFailureReason>>
}



enum BadgesRepositoryFailureReason {
    case unspecified(debugInfo: String)
}
