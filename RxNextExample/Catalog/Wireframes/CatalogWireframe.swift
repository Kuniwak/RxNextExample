import UIKit



protocol CatalogWireframe {
    func goToCatalogScreen()
    func goToSharedModelExampleScreen()
    func goToHierarchalViewModelExampleScreen()
}



class DefaultCatalogWireframe: CatalogWireframe {
    private weak var navigationController: UINavigationController?


    init(on navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


    func goToCatalogScreen() {
        let catalogViewController = CatalogViewController(dependency: self)
        BackButtonTitleHandler.hideBackButtonTitle(of: catalogViewController)

        self.navigationController?.setViewControllers([
            catalogViewController
        ], animated: false)
    }


    func goToSharedModelExampleScreen() {
        let allBadgesModel = DefaultAllBadgesModel(gettingBadgesVia: BadgesDummyRepository())
        let selectedBadgesModel = DefaultSelectedBadgesModel(selected: [])

        let viewController = BadgeSelectorViewController(
            dependency: (
                selectedBadgesModel: selectedBadgesModel,
                selectableBadgesModel: DefaultSelectableBadgesModel(dependency: (
                    allModel: allBadgesModel,
                    selectedModel: selectedBadgesModel
                ))
            )
        )

        self.navigationController?.pushViewController(viewController, animated: true)
    }


    func goToHierarchalViewModelExampleScreen() {
        let viewController = QuizzesViewController(dependency: (
            allQuizEntriesModel: DefaultAllQuizEntriesModel(
                gettingQuizEntriesVia: QuizEntriesDummyRepository()
            ),
            answerEntriesModel: DefaultAnswerEntriesModel(startingWith: [:]),
            quizIndexModel: DefaultQuizIndexModel(startingWith: 0)
        ))

        self.navigationController?.pushViewController(viewController, animated: true)
    }


    static func bootstrap(on window: UIWindow) -> DefaultCatalogWireframe {
        let navigationController = UINavigationController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return DefaultCatalogWireframe(on: navigationController)
    }
}
