import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window

        let catalogWireframe = DefaultCatalogWireframe.bootstrap(on: window)
        catalogWireframe.goToCatalogScreen()

        return true
    }
}