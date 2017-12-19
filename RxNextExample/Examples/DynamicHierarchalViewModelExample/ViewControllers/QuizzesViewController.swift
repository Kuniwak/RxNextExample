import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class QuizzesViewController: UIViewController {
    typealias Dependency = (
        allQuizEntriesModel: AllQuizEntriesModel,
        answerEntriesModel: AnswerEntriesModel,
        quizIndexModel: QuizIndexModel
    )


    private let rootView: QuizzesRootView
    private var viewModel: QuizzesViewModel?
    private let dependency: Dependency
    private let disposeBag = RxSwift.DisposeBag()


    init(dependency: Dependency) {
        self.dependency = dependency

        self.rootView = QuizzesRootView()

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        self.view = self.rootView

        self.title = "Quiz"
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = QuizzesViewModel(
            dependency: (
                allQuizEntriesModel: self.dependency.allQuizEntriesModel,
                answerEntriesModel: self.dependency.answerEntriesModel,
                quizIndexModel: self.dependency.quizIndexModel
            )
        )
        // NOTE: Prevent removing by ARC.
        self.viewModel = viewModel

        let dataSource = RxDataSources.RxCollectionViewSectionedReloadDataSource<RxDataSources.SectionModel<String, QuizEntry>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                return QuizCell.dequeue(from: collectionView, for: indexPath, parentViewModel: viewModel)
            },
            configureSupplementaryView: { dataSource, collectionView, string, indexPath in
                return UICollectionViewCell()
            }
        )

        viewModel.quizEntries
            .map { quizzes in [RxDataSources.SectionModel(model: "Quiz", items: quizzes)] }
            .drive(self.rootView.collectionOutlet.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }


    override func viewDidAppear(_ animated: Bool) {
        self.viewModel?.currentQuizIndex
            .drive(onNext: { [weak self] index in
                guard let `self` = self else { return }
                guard index < self.rootView.collectionOutlet.numberOfItems(inSection: 0) else { return }
                let indexPath = IndexPath(row: index, section: 0)

                self.rootView.collectionOutlet.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: true
                )

                Timer.scheduledTimer(
                    withTimeInterval: 0.8,
                    repeats: false,
                    block: { _ in
                        if let cell = self.rootView.collectionOutlet.cellForItem(at: indexPath) as? QuizCell {
                            cell.answerOutlet.becomeFirstResponder()
                        }
                    }
                )
            })
            .disposed(by: self.disposeBag)
    }
}



extension QuizEntry: RxDataSources.IdentifiableType {
    typealias Identity = QuizEntry.Id


    var identity: Identity {
        return self.id
    }
}
