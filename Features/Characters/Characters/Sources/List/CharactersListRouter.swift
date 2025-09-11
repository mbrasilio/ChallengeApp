import UIKit

protocol CharactersListRouting: AnyObject {
    func openCharacterDetail(title: String, from url: String)
}

final class CharactersListRouter: CharactersListRouting {
    weak var viewController: UIViewController?
    
    func openCharacterDetail(title: String, from url: String) {
        let factory = CharacterDetailsFactory.make(title: title, from: url)
        viewController?.navigationController?.pushViewController(factory, animated: true)
    }
}
