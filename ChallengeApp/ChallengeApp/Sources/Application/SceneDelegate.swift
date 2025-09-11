import UIKit
import Characters

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let controller = CharactersListFactory.make()
        let nav = UINavigationController(rootViewController: controller)

        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
