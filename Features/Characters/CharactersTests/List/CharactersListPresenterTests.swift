import Testing

@testable import Characters

// MARK: - Helpers
private final class CharactersListRoutingSpy: CharactersListRouting {
    private(set) var openCharacterDetailTitleInvocations = [String]()
    private(set) var openCharacterDetailUrlInvocations = [String]()
    func openCharacterDetail(title: String, from url: String) {
        openCharacterDetailTitleInvocations.append(title)
        openCharacterDetailUrlInvocations.append(url)
    }
}

private final class CharactersListDisplayingSpy: CharactersListDisplaying {
    private(set) var displayInitialListInvocations = [CharactersListDTO]()
    func displayInitialList(_ list: [CharactersListDTO]) {
        displayInitialListInvocations.append(contentsOf: list)
    }
    
    private(set) var displayNewItemsInvocations = [CharactersListDTO]()
    func displayNewItems(_ list: [CharactersListDTO]) {
        displayNewItemsInvocations.append(contentsOf: list)
    }
    
    private(set) var displayLoadingCallsCount = 0
    func displayLoading() {
        displayLoadingCallsCount += 1
    }
    
    private(set) var displayFinishedLoadingCallsCount = 0
    func displayFinishedLoading() {
        displayFinishedLoadingCallsCount += 1
    }
    
    private(set) var displayCanLoadMoreInvocations = [Bool]()
    func displayCanLoadMore(_ canLoadMore: Bool) {
        displayCanLoadMoreInvocations.append(canLoadMore)
    }
    
    private(set) var displayErrorInvocations = [String]()
    func displayError(message: String) {
        displayErrorInvocations.append(message)
    }
}

private extension CharactersListPresenterTests {
    typealias Doubles = (
        routerSpy: CharactersListRoutingSpy,
        displaySpy: CharactersListDisplayingSpy
    )
    
    func makeSUT() -> (CharactersListPresenter, Doubles) {
        let doubles: Doubles = (
            CharactersListRoutingSpy(),
            CharactersListDisplayingSpy()
        )
        
        let sut = CharactersListPresenter(router: doubles.routerSpy)
        sut.viewController = doubles.displaySpy
        
        return (sut, doubles)
    }
}

// MARK: - Suite
@Suite
struct CharactersListPresenterTests {
    @Test
    func presentLoading_WhenCalled_ShouldCallDisplayLoading() {
        let (sut, doubles) = makeSUT()
        
        sut.presentLoading()
        
        #expect(doubles.displaySpy.displayLoadingCallsCount == 1)
    }
    
    @Test
    func stopLoading_WhenCalled_ShouldCallDisplayFinishedLoading() {
        let (sut, doubles) = makeSUT()
        
        sut.stopLoading()
        
        #expect(doubles.displaySpy.displayFinishedLoadingCallsCount == 1)
    }
    
    @Test
    func presentInitialList_WhenCalled_ShouldCallDisplayInitialListCorrectly() {
        let (sut, doubles) = makeSUT()
        let listItemFake = CharactersListItem(id: UUID(), name: "name", detailUrl: "detail")
        let expectedDTOItem = CharactersListDTO(id: listItemFake.id, name: listItemFake.name)
        
        sut.presentInitialList([listItemFake])
        
        #expect(doubles.displaySpy.displayInitialListInvocations == [expectedDTOItem])
    }
    
    @Test
    func presentNextCharacters_WhenCalled_ShouldCallDisplayInitialListCorrectly() {
        let (sut, doubles) = makeSUT()
        let listItemFake = CharactersListItem(id: UUID(), name: "name", detailUrl: "detail")
        let expectedDTOItem = CharactersListDTO(id: listItemFake.id, name: listItemFake.name)
        
        sut.presentNextCharacters([listItemFake])
        
        #expect(doubles.displaySpy.displayNewItemsInvocations == [expectedDTOItem])
    }
    
    @Test
    func presentCanLoadMore_WhenCalled_ShouldCallDisplayCanLoadMoreCorrectly() {
        let (sut, doubles) = makeSUT()
        
        sut.presentCanLoadMore(true)
        
        #expect(doubles.displaySpy.displayCanLoadMoreInvocations == [true])
    }
    
    @Test
    func presentCharacterDetail_WhenCalled_ShouldCallRouterSpyCorrectly() {
        let (sut, doubles) = makeSUT()
        
        sut.presentCharacterDetail(title: "abobora", from: "terra")
        
        #expect(doubles.routerSpy.openCharacterDetailTitleInvocations == ["abobora"])
        #expect(doubles.routerSpy.openCharacterDetailUrlInvocations == ["terra"])
    }
    
    @Test
    func presentError_WhenCalled_ShouldCallDisplayError() {
        let (sut, doubles) = makeSUT()
        
        sut.presentError(message: "opa")
        
        #expect(doubles.displaySpy.displayErrorInvocations == ["opa"])
    }
}
