import UIKit
import Networking

enum CharacterDetailsFactory {
    static func make(title: String, from url: String) -> UIViewController {
        let networking = NetworkService()
        let service = CharacterDetailsService(url: url, networking: networking)
        let router = CharacterDetailsRouter()
        let presenter = CharacterDetailsPresenter(router: router)
        let interactor = CharacterDetailsInteractor(
            service: service,
            presenter: presenter
        )
        let viewController = CharacterDetailsViewController(interactor: interactor, title: title)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
