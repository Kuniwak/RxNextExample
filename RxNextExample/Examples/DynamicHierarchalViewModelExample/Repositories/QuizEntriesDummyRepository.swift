import Foundation
import RxSwift



class QuizEntriesDummyRepository: QuizEntriesRepository {
    private let constantRepository: QuizEntriesConstantRepository


    init() {
        self.constantRepository = QuizEntriesConstantRepository(
            returning: QuizEntriesDummyRepository.createRandomQuizEntries()
        )
    }


    func get(by parameters: Void) -> Single<Result<[QuizEntry.Id: QuizEntry], Never>> {
        return self.constantRepository.get(by: parameters)
    }


    private static func createRandomQuizEntries() -> [QuizEntry.Id: QuizEntry] {
        var dictionary = [QuizEntry.Id: QuizEntry]()

        (0..<5).forEach { idNumber in
            let id = QuizEntry.Id(number: idNumber)
            dictionary[id] = QuizEntry(
                id: id,
                quiz: QuizEntriesDummyRepository.createRandomQuiz()
            )
        }

        return dictionary
    }


    private static func createRandomQuiz() -> Quiz {
        if arc4random() % 2 == 0 {
            return .addition(AdditionQuiz(
                value1: Int(arc4random() % 10),
                value2: Int(arc4random() % 10)
            ))
        }
        else {
            return .multiplication(MultiplicationQuiz(
                value1: Int(arc4random() % 10),
                value2: Int(arc4random() % 10)
            ))
        }
    }
}
