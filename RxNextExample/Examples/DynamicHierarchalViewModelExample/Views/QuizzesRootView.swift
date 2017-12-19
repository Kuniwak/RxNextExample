import UIKit


class QuizzesRootView: UIView {
    @IBOutlet weak var collectionOutlet: UICollectionView! {
        didSet {
            let margin: CGFloat = 20
            let navigationHeight: CGFloat = 44

            let itemWidth = UIScreen.main.bounds.width
                - margin * 2

            let itemHeight = UIScreen.main.bounds.height
                - UIApplication.shared.statusBarFrame.height
                - navigationHeight
                - margin * 2

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = margin / 2
            layout.sectionInset = UIEdgeInsets(
                top: margin,
                left: margin,
                bottom: margin,
                right: margin
            )
            self.collectionOutlet.collectionViewLayout = layout
            QuizCell.register(to: self.collectionOutlet)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }


    private func setUp() {
        guard let view = QuizzesRootView.loadViewFromXib(owner: self) else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
    }


    private static let nibName = "QuizzesScreen"


    private static func loadViewFromXib(owner: QuizzesRootView) -> UIView? {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        return nib.instantiate(withOwner: owner).first as? UIView
    }
}
