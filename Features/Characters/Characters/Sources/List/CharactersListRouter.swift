import UIKit

protocol CharactersListRouting: AnyObject {
    func openCharacterDetail(with url: String)
}

final class CharactersListRouter: CharactersListRouting {
    weak var viewController: UIViewController?
    
    func openCharacterDetail(with url: String) {
        // TODO: adicionar abertura para a tela de detalhes
    }
}
