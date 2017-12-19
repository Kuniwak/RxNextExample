import Foundation
import RxSwift



protocol QuizEntriesRepository: EntityModelRepository {
    associatedtype V = [QuizEntry.Id: QuizEntry]
    associatedtype E = Never
    associatedtype P = Void
}
