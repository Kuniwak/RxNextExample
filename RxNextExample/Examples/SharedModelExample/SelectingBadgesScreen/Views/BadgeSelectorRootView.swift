import UIKit


class BadgeSelectorRootView: UIView {
    @IBOutlet weak var selectedCollectionOutlet: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            self.selectedCollectionOutlet.collectionViewLayout = layout
            SelectedBadgeCell.register(to: self.selectedCollectionOutlet)
        }
    }


    @IBOutlet weak var selectableCollectionOutlet: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            self.selectableCollectionOutlet.collectionViewLayout = layout
            self.selectableCollectionOutlet.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
            SelectableBadgeCell.register(to: self.selectableCollectionOutlet)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromXib()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromXib()
    }


    private func loadFromXib() {
        guard let view = BadgeSelectorRootView.loadViewFromXib(owner: self) else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
    }


    private static let nibName = "BadgeSelectorScreen"


    private static func loadViewFromXib(owner: BadgeSelectorRootView) -> UIView? {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        return nib.instantiate(withOwner: owner).first as? UIView
    }
}



@IBDesignable class BadgesSelectorRootViewSelectedAreaView: UIVisualEffectView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
