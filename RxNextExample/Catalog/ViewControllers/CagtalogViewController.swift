import UIKit
import RxSwift
import RxCocoa



class CatalogViewController: UIViewController {
    typealias Dependency = CatalogWireframe

    private let dependency: Dependency
    private let tableView: UITableView
    private let disposeBag = RxSwift.DisposeBag()

    private var viewModel: CatalogViewModel?


    init(dependency: Dependency) {
        self.dependency = dependency
        self.tableView = UITableView()

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        self.view = self.tableView

        self.title = "Examples"
    }


    override func viewDidLoad() {
        ExampleScreenCell.register(to: self.tableView)

        let viewModel = CatalogViewModel(
            input: self.tableView.rx.itemSelected
                .do(onNext: { [weak self] indexPath in
                    guard let `self` = self else { return }
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
                .map { indexPath in indexPath.row }
                .asSignal(onErrorSignalWith: .empty()),
            dependency: self.dependency
        )
        self.viewModel = viewModel

        viewModel
            .screens
            .drive(self.tableView.rx.items(
                cellIdentifier: ExampleScreenCell.reuseIdentifier,
                cellType: ExampleScreenCell.self
            )) { _, screen, cell in
                cell.screen = screen
            }
            .disposed(by: self.disposeBag)
    }
}
