import UIKit
import Characters

protocol AppCoordinating {
    func start()
}

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(
        window: UIWindow,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let viewController = CharactersListFactory.make()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
