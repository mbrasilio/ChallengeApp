import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()

        let coordinator = AppCoordinator(nav: nav)
        self.coordinator = coordinator
        coordinator.start()

        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
