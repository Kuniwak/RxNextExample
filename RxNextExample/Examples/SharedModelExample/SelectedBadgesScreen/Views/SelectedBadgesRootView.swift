import UIKit


class SelectedBadgesRootView: UIView {
     @IBOutlet weak var selectedCollectionOutlet: UICollectionView! {
         didSet {
             let layout = UICollectionViewFlowLayout()
             layout.scrollDirection = .vertical
             layout.itemSize = CGSize(width: 80, height: 80)
             layout.minimumLineSpacing = 10
             layout.minimumInteritemSpacing = 10
             layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
             self.selectedCollectionOutlet.collectionViewLayout = layout
             SelectedBadgeCell.register(to: self.selectedCollectionOutlet)
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
        guard let view = SelectedBadgesRootView.loadViewFromXib(owner: self) else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        FilledLayout.fill(subview: view, into: self)
    }


    private static let nibName = "SelectedBadgesScreen"


    private static func loadViewFromXib(owner: SelectedBadgesRootView) -> UIView? {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        return nib.instantiate(withOwner: owner).first as? UIView
    }
}