protocol CharacterDetailsInteracting: AnyObject {
    func loadDetails()
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
    func loadDetails() {
        service.fetchDetails { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let details):
                presenter.presentDetails(details)
            case .failure(let failure):
                // TODO: - Adicionar chamada de erro
                break
            }
        }
    }
}
