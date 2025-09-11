import UIKit
import Networking

public enum CharactersListFactory {
    public static func make() -> UIViewController {
        let networking = NetworkService()
        let service = CharactersListService(networking: networking)
        let router = CharactersListRouter()
        let presenter = CharactersListPresenter(router: router)
        let interactor = CharactersListInteractor(service: service, presenter: presenter)
        let viewController = CharactersListViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
