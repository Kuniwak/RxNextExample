import UIKit



protocol PresentedViewControllerWireframe {
    func goBack()
}



class DefaultPresentedViewControllerWireframe: PresentedViewControllerWireframe {
    private weak var presentedViewController: UIViewController?


    init(willDismiss presentedViewController: UIViewController) {
        self.presentedViewController = presentedViewController
    }


    func goBack() {
        self.presentedViewController?.dismiss(animated: true)
    }
}