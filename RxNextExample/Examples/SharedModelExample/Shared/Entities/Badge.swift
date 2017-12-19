import UIKit
import RxDataSources



struct Badge {
    let id: Int
    let title: String
    let color: UIColor
}



extension Badge: Hashable {
    var hashValue: Int {
        return self.id
    }


    static func ==(lhs: Badge, rhs: Badge) -> Bool {
        return lhs.id == rhs.id
    }
}



extension Badge: RxDataSources.IdentifiableType {
    typealias Identity = Int

    var identity: Identity {
        return self.id
    }
}
