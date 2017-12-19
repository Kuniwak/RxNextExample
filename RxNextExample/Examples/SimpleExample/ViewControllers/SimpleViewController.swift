import UIKit
import RxSwift
import RxCocoa



class SimpleViewController: UIViewController {
    private let rootView: SimpleRootView
    private var viewModel: SimpleViewModel?
    private let disposeBag = RxSwift.DisposeBag()


    init() {
        self.rootView = SimpleRootView()
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }


    override func loadView() {
        self.view = self.rootView

        self.title = "Echo"
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = SimpleViewModel(input: rootView.inputOutlet.rx.text.asDriver())

        viewModel.outputText
            .drive(rootView.outputOutlet.rx.text)
            .disposed(by: self.disposeBag)
    }
}
