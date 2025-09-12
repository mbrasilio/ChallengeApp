import Testing
import Networking

@testable import Characters

// MARK: - Helpers
private final class CharactersListServicingMock: CharactersListServicing {
    var fetchInitialCharactersExpectedResult: Result<CharactersList, CustomError> = .failure(.cancelled)
    func fetchInitialCharacters(completion: @escaping (Result<CharactersList, CustomError>) -> Void) {
        completion(fetchInitialCharactersExpectedResult)
    }

    var fetchNextCharactersExpectedResult: Result<CharactersList, CustomError> = .failure(.cancelled)
    func fetchNextCharacters(url: String, completion: @escaping (Result<CharactersList, CustomError>) -> Void) {
        completion(fetchNextCharactersExpectedResult)
    }
}

private final class CharactersListPresentingSpy: CharactersListPresenting {
    private(set) var presentLoadingCallsCount = 0
    func presentLoading() {
        presentLoadingCallsCount += 1
    }
    
    private(set) var stopLoadingCallsCount = 0
    func stopLoading() {
        stopLoadingCallsCount += 1
    }
    
    private(set) var presentInitialListInvocations = [CharactersListItem]()
    func presentInitialList(_ list: [CharactersListItem]) {
        presentInitialListInvocations.append(contentsOf: list)
    }
    
    private(set) var presentNextCharactersInvocations = [CharactersListItem]()
    func presentNextCharacters(_ list: [CharactersListItem]) {
        presentNextCharactersInvocations.append(contentsOf: list)
    }
    
    private(set) var presentCanLoadMoreInvocations = [Bool]()
    func presentCanLoadMore(_ canLoadMore: Bool) {
        presentCanLoadMoreInvocations.append(canLoadMore)
    }
    
    private(set) var presentCharacterDetailInvocations = [(title: String, url: String)]()
    func presentCharacterDetail(title: String, from url: String) {
        presentCharacterDetailInvocations.append((title, url))
    }
    
    private(set) var presentErrorInvocations = [String]()
    func presentError(message: String) {
        presentErrorInvocations.append(message)
    }
}

private extension CharactersListInteractorTests {
    typealias Doubles = (
        serviceMock: CharactersListServicingMock,
        presenterSpy: CharactersListPresentingSpy
    )
    
    func makeSUT() -> (CharactersListInteractor, Doubles) {
        let doubles: Doubles = (
            CharactersListServicingMock(),
            CharactersListPresentingSpy()
        )
        
        let sut = CharactersListInteractor(
            service: doubles.serviceMock,
            presenter: doubles.presenterSpy
        )
        
        return (sut, doubles)
    }
}

// MARK: - Suite
@Suite
struct CharactersListInteractorTests {
    @Test
    func fetchInitialCharacters_whenSuccess_shouldCallPresenterFunctions() async {
        let (sut, doubles) = makeSUT()
        let expectedResult = CharactersList(
            count: 2,
            paginationUrl: "",
            results: [
                .init(id: UUID(), name: "name", detailUrl: "detail")
            ]
        )
        doubles.serviceMock.fetchInitialCharactersExpectedResult = .success(expectedResult)

        sut.loadInitialCharacters()

        #expect(doubles.presenterSpy.presentLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.stopLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.presentInitialListInvocations == expectedResult.results)
        #expect(doubles.presenterSpy.presentCanLoadMoreInvocations == [true])
        #expect(doubles.presenterSpy.presentNextCharactersInvocations == [])
        #expect(doubles.presenterSpy.presentErrorInvocations == [])
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.count == 0)
    }
    
    @Test
    func fetchInitialCharacters_whenFailure_shouldCallPresenterFunctions() async {
        let (sut, doubles) = makeSUT()
        let expectedError = CustomError.invalidUrl
        doubles.serviceMock.fetchInitialCharactersExpectedResult = .failure(expectedError)

        sut.loadInitialCharacters()

        #expect(doubles.presenterSpy.presentLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.stopLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.presentInitialListInvocations == [])
        #expect(doubles.presenterSpy.presentCanLoadMoreInvocations == [])
        #expect(doubles.presenterSpy.presentNextCharactersInvocations == [])
        #expect(doubles.presenterSpy.presentErrorInvocations == [expectedError.errorDescription])
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.count == 0)
    }
    
    @Test
    func fetchNextCharacters_whenSuccessAndUpdatesCannotLoadMore_shouldCallPresenterFunctions() async {
        let (sut, doubles) = makeSUT()
        let expectedResult = CharactersList(
            count: 1,
            paginationUrl: "",
            results: [
                .init(id: UUID(), name: "name", detailUrl: "detail")
            ]
        )
        doubles.serviceMock.fetchNextCharactersExpectedResult = .success(expectedResult)

        sut.loadNextCharacters()

        #expect(doubles.presenterSpy.presentLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.stopLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.presentInitialListInvocations == [])
        #expect(doubles.presenterSpy.presentCanLoadMoreInvocations == [false])
        #expect(doubles.presenterSpy.presentNextCharactersInvocations == expectedResult.results)
        #expect(doubles.presenterSpy.presentErrorInvocations == [])
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.count == 0)
    }
    
    @Test
    func fetchNextCharacters_whenFailure_shouldCallPresenterFunctions() async {
        let (sut, doubles) = makeSUT()
        let expectedError = CustomError.invalidUrl
        doubles.serviceMock.fetchNextCharactersExpectedResult = .failure(expectedError)

        sut.loadNextCharacters()

        #expect(doubles.presenterSpy.presentLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.stopLoadingCallsCount == 1)
        #expect(doubles.presenterSpy.presentInitialListInvocations == [])
        #expect(doubles.presenterSpy.presentCanLoadMoreInvocations == [])
        #expect(doubles.presenterSpy.presentNextCharactersInvocations == [])
        #expect(doubles.presenterSpy.presentErrorInvocations == [expectedError.errorDescription])
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.count == 0)
    }
    
    @Test
    func openCharacterDetails_whenFounds_shouldCallPresenterFunctions() async {
        let (sut, doubles) = makeSUT()
        let item = CharactersListItem(id: UUID(), name: "name", detailUrl: "detail-lalala")
        let expectedResult = CharactersList(
            count: 1,
            paginationUrl: "",
            results: [item]
        )
        doubles.serviceMock.fetchInitialCharactersExpectedResult = .success(expectedResult)

        sut.loadInitialCharacters()
        sut.openCharacterDetails(id: item.id)

        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.first?.title == item.name)
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.first?.url == item.detailUrl)
    }

    @Test
    func openCharacterDetails_whenNotFounds_shouldDoesNothing() async {
        let (sut, doubles) = makeSUT()
        let item = CharactersListItem(id: UUID(), name: "name", detailUrl: "detail-lalala")
        let expectedResult = CharactersList(
            count: 1,
            paginationUrl: "",
            results: [item]
        )
        doubles.serviceMock.fetchInitialCharactersExpectedResult = .success(expectedResult)

        sut.loadInitialCharacters()
        sut.openCharacterDetails(id: UUID())

        #expect(doubles.presenterSpy.presentNextCharactersInvocations == [])
        #expect(doubles.presenterSpy.presentErrorInvocations == [])
        #expect(doubles.presenterSpy.presentCharacterDetailInvocations.count == 0)
    }
}
