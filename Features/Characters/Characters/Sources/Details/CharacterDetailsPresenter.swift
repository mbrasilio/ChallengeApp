protocol CharacterDetailsPresenting: AnyObject {
}

final class CharacterDetailsPresenter {
    private let router: CharacterDetailsRouting
    weak var viewController: CharacterDetailsDisplaying?

    init(router: CharacterDetailsRouting) {
        self.coordinator = coordinator
    }
}

// MARK: - CharacterDetailsPresenting
extension CharacterDetailsPresenter: CharacterDetailsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep() {
        coordinator.openSomething()
    }
}
