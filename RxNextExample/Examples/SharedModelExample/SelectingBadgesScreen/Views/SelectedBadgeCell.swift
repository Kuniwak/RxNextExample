import UIKit



class SelectedBadgeCell: UICollectionViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var backgroundOutlet: SelectedBadgeCellRoundedBackground!


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


    static let reuseIdentifier = "SelectedBadgeCell"
    static let nibName = "SelectedBadgeCell"


    static func register(to collectionView: UICollectionView) {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }


    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath, badge: Badge) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as? SelectedBadgeCell else {
            fatalError("Please register \(self.reuseIdentifier)")
        }

        cell.badge = badge

        return cell
    }
}



@IBDesignable class SelectedBadgeCellRoundedBackground: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
    }
}
