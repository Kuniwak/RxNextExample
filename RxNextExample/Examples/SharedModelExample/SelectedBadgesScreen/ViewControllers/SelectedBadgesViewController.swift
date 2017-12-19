import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class SelectedBadgesViewController: UIViewController {
    private let selectedBadges: [Badge]

    private let rootView: SelectedBadgesRootView
    private let backButton: UIBarButtonItem

    private var viewModel: SelectedBadgesScreenViewModel?
    private let disposeBag = RxSwift.DisposeBag()


    init(dependency selectedBadges: [Badge]) {
        self.selectedBadges = selectedBadges

        self.rootView = SelectedBadgesRootView()
        self.backButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: nil,
            action: nil
        )

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        self.view = self.rootView

        self.title = "Selected Badges"

        self.navigationItem.leftBarButtonItem = self.backButton
    }


    override func viewDidLoad() {
        let viewModel = SelectedBadgesScreenViewModel(
            input: self.backButton.rx
                .tap
                .asSignal(onErrorSignalWith: .empty()),

            dependency: (
                selectedBadges: self.selectedBadges,
                wireframe: DefaultPresentedViewControllerWireframe(willDismiss: self)
            )
        )
        // NOTE: Prevent removing by ARC.
        self.viewModel = viewModel

        let selectedDataSource = RxDataSources.RxCollectionViewSectionedAnimatedDataSource<RxDataSources.AnimatableSectionModel<String, Badge>>(
            configureCell: { dataSource, collectionView, indexPath, badge in
                return SelectedBadgeCell.dequeue(from: collectionView, for: indexPath, badge: badge)
            },
            configureSupplementaryView: { dataSource, collectionView, string, indexPath in
                return UICollectionViewCell()
            }
        )

        viewModel.selectedViewModel.selectedBadges
            .map { badges in [RxDataSources.AnimatableSectionModel(model: "Selected", items: badges)] }
            .drive(self.rootView.selectedCollectionOutlet.rx.items(dataSource: selectedDataSource))
            .disposed(by: self.disposeBag)
    }
}
