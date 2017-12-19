import UIKit



class SelectableBadgeCell: UICollectionViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var backgroundOutlet: SelectableBadgeCellRoundedBackground!


    var badge: Badge? {
        didSet {
            guard let badge = self.badge else {
                self.titleOutlet?.text = nil
                self.backgroundOutlet?.backgroundColor = UIColor.black
                return
            }

            self.titleOutlet?.text = badge.title
            self.backgroundOutlet?.backgroundColor = badge.color
        }
    }


    private static let reuseIdentifier = "SelectableBadgeCell"
    private static let nibName = "SelectableBadgeCell"


    static func register(to collectionView: UICollectionView) {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }


    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath, badge: Badge) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as? SelectableBadgeCell else {
            fatalError("Please register \(self.reuseIdentifier)")
        }

        cell.badge = badge

        return cell
    }
}



@IBDesignable
class SelectableBadgeCellRoundedBackground: UIView {
    override func layoutSubviews() {
    	super.layoutSubviews()
    	self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
    }
}
