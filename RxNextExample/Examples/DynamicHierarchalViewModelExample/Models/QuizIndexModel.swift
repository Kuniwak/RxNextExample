import RxCocoa



protocol QuizIndexModel {
    var indexDidChange: RxCocoa.Driver<Int> { get }
    var currentIndex: Int { get }

    func next()
}



class DefaultQuizIndexModel: QuizIndexModel {
    private let stateMachine: StateMachine<Int>


    let indexDidChange: RxCocoa.Driver<Int>


    var currentIndex: Int {
        return self.stateMachine.currentState
    }


    init(startingWith initialIndex: Int) {
        self.stateMachine = StateMachine(startingWith: initialIndex)
        self.indexDidChange = stateMachine.stateDidChange
    }


    func next() {
        self.stateMachine.currentState = self.stateMachine.currentState + 1
    }
}