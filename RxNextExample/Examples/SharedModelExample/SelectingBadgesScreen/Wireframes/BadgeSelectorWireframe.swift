import UIKit



protocol BadgeSelectorWireframe {
    func goToResultScreen(with selectedBadgesModel: SelectedBadgesModel)
}



class DefaultBadgeSelectorWireframe: BadgeSelectorWireframe {
    private weak var viewController: UIViewController?


    init(on viewController: UIViewController) {
        self.viewController = viewController
    }


    func goToResultScreen(with selectedBadgesModel: SelectedBadgesModel) {
        let navigationController = UINavigationController(
            rootViewController: SelectedBadgesViewController(
                dependency: selectedBadgesModel
            )
        )

        self.viewController?.present(navigationController, animated: true)
    }
}
