struct QuizEntry: Hashable {
    let id: Id
    let quiz: Quiz


    var hashValue: Int {
        return self.id.number
    }


    static func ==(lhs: QuizEntry, rhs: QuizEntry) -> Bool {
        return lhs.id == rhs.id
            && lhs.quiz == rhs.quiz
    }


    struct Id: Hashable {
        let number: Int


        var hashValue: Int {
            return self.number
        }


        static func ==(lhs: Id, rhs: Id) -> Bool {
            return lhs.number == rhs.number
        }
    }
}
