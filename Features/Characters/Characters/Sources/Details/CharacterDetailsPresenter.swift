protocol CharacterDetailsPresenting: AnyObject {
    func presentDetails(_ details: CharacterDetailsDTO)
}

final class CharacterDetailsPresenter {
    private let router: CharacterDetailsRouting
    weak var viewController: CharacterDetailsDisplaying?

    init(router: CharacterDetailsRouting) {
        self.router = router
    }
}

// MARK: - CharacterDetailsPresenting
extension CharacterDetailsPresenter: CharacterDetailsPresenting {
    func presentDetails(_ details: CharacterDetailsDTO) {
        viewController?.displayDetails(details)
    }
}
