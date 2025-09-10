import Foundation

public protocol NetworkServicing {
    func fetch<T: Decodable>(
        api: EndpointApi,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, CustomError>) -> Void
    )
}

public extension NetworkServicing {
    func fetch<T: Decodable>(
        api: EndpointApi,
        completion: @escaping (Result<T, CustomError>) -> Void
    ) {
        fetch(
            api: api,
            decoder: JSONDecoder(),
            completion: completion
        )
    }
}
