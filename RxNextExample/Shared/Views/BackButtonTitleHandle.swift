import UIKit



enum BackButtonTitleHandler {
    static func hideBackButtonTitle(of viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}