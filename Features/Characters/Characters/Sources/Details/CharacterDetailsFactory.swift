import UIKit

enum CharacterDetailsFactory {
    static func make() -> UIViewController {
        let container = DependencyContainer()
        let service = CharacterDetailsService(dependencies: container)
        let coordinator = CharacterDetailsCoordinator(dependencies: container)
        let presenter = CharacterDetailsPresenter(coordinator: coordinator, dependencies: container)
        let interactor = CharacterDetailsInteractor(service: service, presenter: presenter, dependencies: container)
        let viewController = CharacterDetailsViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
