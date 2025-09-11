import UIKit

protocol CharacterDetailsRouting: AnyObject {
}

final class CharacterDetailsRouter: CharacterDetailsRouting {
    weak var viewController: UIViewController?
}
