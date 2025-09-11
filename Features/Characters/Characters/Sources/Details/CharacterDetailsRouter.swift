import UIKit

protocol CharacterDetailsRouting: AnyObject {
    func openSomething()
}

final class CharacterDetailsRouter: CharacterDetailsRouting {
    weak var viewController: UIViewController?
}
