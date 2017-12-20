import UIKit
import RxSwift



class BadgesDummyRepository: BadgesRepository {
    func get(count: Int) -> Single<Result<[Badge], BadgesRepositoryFailureReason>> {
        let badges = (0..<count).map { (id: Int) -> Badge in
            let color = BadgesDummyRepository.generateRandomBadgeColor()
            return Badge(
                id: id,
                title: color.hex,
                color: color.value
            )
        }

        return .just(.success(badges))
    }


    private static func generateBadgeColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> (hex: String, value: UIColor) {
        return (
            hex: String(
                format: "#%02X%02X%02X",
                arguments: [
                    Int(red * 256),
                    Int(green * 256),
                    Int(blue * 256),
                ]
            ),
            value: UIColor(
                red: red,
                green: green,
                blue: blue,
                alpha: 1
            )
        )
    }


    private static func generateRandomBadgeColor() -> (hex: String, value: UIColor) {
        return self.generateBadgeColor(
            red: CGFloat(arc4random() % 100) / 100,
            green: CGFloat(arc4random() % 100) / 100,
            blue: CGFloat(arc4random() % 100) / 100
        )
    }
}
