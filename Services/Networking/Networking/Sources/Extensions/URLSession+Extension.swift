import Foundation

public protocol URLSessionProtocol {
    func dataTask(
        request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func dataTask(
        request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> any URLSessionDataTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler)
    }
}
