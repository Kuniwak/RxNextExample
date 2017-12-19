import UIKit



protocol BadgeSelectorWireframe {
    func goToResultScreen(with selectedBadges: [Badge])
}



class DefaultBadgeSelectorWireframe: BadgeSelectorWireframe {
    private weak var viewController: UIViewController?


    init(on viewController: UIViewController) {
        self.viewController = viewController
    }


    func goToResultScreen(with selectedBadges: [Badge]) {
        let navigationController = UINavigationController(
            rootViewController: SelectedBadgesViewController(
                dependency: selectedBadges
            )
        )

        self.viewController?.present(navigationController, animated: true)
    }
}
