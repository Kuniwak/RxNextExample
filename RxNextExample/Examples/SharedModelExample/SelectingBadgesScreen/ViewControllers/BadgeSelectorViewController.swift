import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class BadgeSelectorViewController: UIViewController {
    private let repository: AnyEntityRepository<Void, [Badge], Never>
    private let rootView: BadgeSelectorRootView
    private let doneButton: UIBarButtonItem
    private var viewModel: BadgesSelectorViewModel?
    private let disposeBag = RxSwift.DisposeBag()


    init<Repository: BadgesRepository>(
        dependency repository: Repository
    ) where Repository.P == Void, Repository.V == [Badge], Repository.E == Never {
        self.repository = repository.asAny()

        self.rootView = BadgeSelectorRootView()
        self.doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
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

        self.navigationItem.rightBarButtonItem = self.doneButton

        self.title = "Select Badges"
    }


    override func viewDidLoad() {
        let viewModel = BadgesSelectorViewModel(
            input: (
                doneTap: self.doneButton.rx
                    .tap
                    .asSignal(onErrorSignalWith: .empty()),

                selectedTap: self.rootView.selectedCollectionOutlet.rx
                    .modelSelected(Badge.self)
                    .asSignal(onErrorSignalWith: .empty()),

                selectableTap: self.rootView.selectableCollectionOutlet.rx
                    .modelSelected(Badge.self)
                    .asSignal(onErrorSignalWith: .empty())
            ),
            dependency: (
                repository: self.repository,
                wireframe: DefaultBadgeSelectorWireframe(on: self)
            )
        )
        // NOTE: Prevent removing by ARC.
        self.viewModel = viewModel

        let selectedDataSource = RxCollectionViewSectionedAnimatedDataSource<RxDataSources.AnimatableSectionModel<String, Badge>>(
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

        viewModel.selectableViewModel.badgeDidSelect
            .emit(onNext: { [weak self] badge in
                guard let `self` = self else { return }

                DispatchQueue.main.async {
                    self.scroll(to: badge)
                }
            })
            .disposed(by: self.disposeBag)

        let selectableDataSource = RxCollectionViewSectionedAnimatedDataSource<RxDataSources.AnimatableSectionModel<String, Badge>>(
            configureCell: { dataSource, collectionView, indexPath, badge in
                return SelectableBadgeCell.dequeue(from: collectionView, for: indexPath, badge: badge)
            },
            configureSupplementaryView: { dataSource, collectionView, string, indexPath in
                return UICollectionViewCell()
            }
        )

        viewModel.selectableViewModel.selectableBadges
            .map { badges in [RxDataSources.AnimatableSectionModel(model: "Selectable", items: badges)] }
            .drive(self.rootView.selectableCollectionOutlet.rx.items(dataSource: selectableDataSource))
            .disposed(by: self.disposeBag)

        viewModel.completionViewModel
            .canComplete
            .drive(self.doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }


    private func scroll(to badge: Badge) {
        guard let viewModel = self.viewModel else { return }
        guard let index = viewModel.currentSelectedBadges.index(of: badge),
              self.isAvailableIndex(index) else { return }

        self.rootView.selectedCollectionOutlet.scrollToItem(
            at: IndexPath(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }


    // XXX: This is a workaround for animated cell changes.
    // It is necessary because we cannot detect when the new cell is added.
    private func isAvailableIndex(_ index: Int) -> Bool {
        guard let dataSource = self.rootView.selectedCollectionOutlet.dataSource else {
            return false
        }

        let numberOfItems = dataSource.collectionView(self.rootView.selectedCollectionOutlet, numberOfItemsInSection: 0)
        return index < numberOfItems
    }
}
