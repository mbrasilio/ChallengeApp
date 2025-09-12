import UIKit

final class NavigationControllerSpy: UINavigationController {
    private(set) var pushedViewController: UIViewController?
    private(set) var pushCallsCount = 0
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        pushCallsCount += 1
        super.pushViewController(viewController, animated: animated)
    }
}
