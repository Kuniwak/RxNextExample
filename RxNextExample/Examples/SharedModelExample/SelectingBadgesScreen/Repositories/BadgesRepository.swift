import RxSwift



protocol BadgesRepository: EntityModelRepository {
    associatedtype V = [Badge]
    associatedtype E = Never
    associatedtype P = Void
}
