import UIKit



class SimpleRootView: UIView {
    @IBOutlet weak var outputOutlet: UILabel!
    @IBOutlet weak var inputOutlet: UITextField!


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }


    private func setUp() {
        guard let view = SimpleRootView.loadViewFromXib(owner: self) else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
    }


    private static let nibName = "SimpleScreen"


    private static func loadViewFromXib(owner: SimpleRootView) -> UIView? {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        return nib.instantiate(withOwner: owner).first as? UIView
    }
}
