protocol CharacterDetailsInteracting: AnyObject {
}

final class CharacterDetailsInteractor {
    private let service: CharacterDetailsServicing
    private let presenter: CharacterDetailsPresenting
    
    init(
        service: CharacterDetailsServicing,
        presenter: CharacterDetailsPresenting
    ) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - CharacterDetailsInteracting
extension CharacterDetailsInteractor: CharacterDetailsInteracting {
}
