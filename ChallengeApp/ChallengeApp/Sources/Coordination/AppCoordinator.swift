import UIKit

final class AppCoordinator {
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }

    func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = "Home"
        nav.setViewControllers([vc], animated: false)
    }
}
