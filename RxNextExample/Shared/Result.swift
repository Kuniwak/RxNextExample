enum Result<V, E> {
    case success(V)
    case failure(E)


    var value: V? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }


    var error: E? {
        switch self {
        case let .failure(error):
            return error
        case .success:
            return nil
        }
    }
}
