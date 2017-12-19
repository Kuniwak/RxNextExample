import UIKit
import RxSwift
import RxCocoa



class QuizCell: UICollectionViewCell {
    @IBOutlet weak var answerOutlet: UITextField!
    @IBOutlet weak var questionOutlet: UILabel!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var resultOutlet: UILabel!


    private var resultShownRelay: RxCocoa.PublishRelay<Void>?
    private var disposeBag: RxSwift.DisposeBag?
    private var viewModel: QuizViewModel?


    private func decorate() {
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false

        self.submitOutlet.isHidden = false
        self.submitOutlet.alpha = 1
        self.resultOutlet.isHidden = true
        self.resultOutlet.alpha = 0
    }


    private static let reuseIdentifier = "QuizCell"
    private static let nibName = "QuizCell"


    static func register(to collectionView: UICollectionView) {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }


    static func dequeue(
        from collectionView: UICollectionView,
        for indexPath: IndexPath,
        parentViewModel: QuizzesViewModel
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as? QuizCell else {
            fatalError("Please register \(self.reuseIdentifier)")
        }

        let resultShownRelay = RxCocoa.PublishRelay<Void>()

        guard let viewModel = cell.swapViewModel(
            input: (
                answerText: cell.answerOutlet.rx
                    .text
                    .asDriver(),

                answerDone: cell.answerOutlet.rx
                    .controlEvent(.editingDidEndOnExit)
                    .asSignal(onErrorSignalWith: .empty()),

                submitTap: cell.submitOutlet.rx
                    .tap
                    .asSignal(onErrorSignalWith: .empty()),

                resultShown: resultShownRelay
                    .asSignal()
            ),
            for: indexPath,
            willAddChildViewModelTo: parentViewModel
        ) else {
            fatalError("Unavailable indexPath: \(indexPath)")
        }

        // NOTE: Prevent removing by ARC.
        cell.viewModel = viewModel

        // NOTE: Unsubscribe all previous ViewModels subscriptions.
        let disposeBag = RxSwift.DisposeBag()
        cell.disposeBag = disposeBag
        cell.resultShownRelay = resultShownRelay
        cell.answerOutlet.text = nil

        viewModel.quiz
            .map { quiz in quiz.question }
            .drive(cell.questionOutlet.rx.text)
            .disposed(by: disposeBag)

        viewModel.canSubmit
            .drive(cell.submitOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.canEdit
            .drive(cell.answerOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.submittedQuizResult
            .emit(onNext: { [weak cell] result in
                guard let cell = cell else {
                    return
                }
                cell.showResult(result)
            })
            .disposed(by: disposeBag)

        cell.decorate()

        return cell
    }


    private func showResult(_ result: QuizResult) {
        self.submitOutlet.alpha = 1

        switch result {
        case .correct:
            self.resultOutlet.textColor = .green
            self.resultOutlet.text = "Correct!"
        case .wrong:
            self.resultOutlet.textColor = .red
            self.resultOutlet.text = "Wrong!"
        }

        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.submitOutlet.alpha = 0
            },
            completion: { _ in
                self.submitOutlet.isHidden = true

                self.resultOutlet.alpha = 0
                self.resultOutlet.isHidden = false

                UIView.animate(
                    withDuration: 0.15,
                    animations: {
                        self.resultOutlet.alpha = 1
                    },
                    completion: { _ in
                        Timer.scheduledTimer(
                            withTimeInterval: 1,
                            repeats: false,
                            block: { _ in
                                self.resultShownRelay?.accept(())
                            }
                        )
                    }
                )
            }
        )
    }


    private func swapViewModel(
        input: QuizViewModel.Input,
        for indexPath: IndexPath,
        willAddChildViewModelTo parentViewModel: QuizzesViewModel
    ) -> QuizViewModel? {
        if let previousViewModel = self.viewModel {
            parentViewModel.removeChildViewModel(previousViewModel)
        }

        return parentViewModel.createChildViewModel(
            input: input,
            at: indexPath.row
        )
    }
}
