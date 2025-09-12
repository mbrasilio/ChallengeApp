import Testing
import UIKit

@testable import Characters

@Suite
struct CharactersListRouterTests {
    @Test @MainActor
    func openCharacterDetail_WhenCalled_ShouldPushCharacterDetailsViewController() {
        let sut = CharactersListRouter()
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: UIViewController())
        sut.viewController = navigationControllerSpy.topViewController
        
        sut.openCharacterDetail(title: "", from: "")
        
        #expect(navigationControllerSpy.pushedViewController is CharacterDetailsViewController)
        #expect(navigationControllerSpy.pushCallsCount == 2)
    }
}
