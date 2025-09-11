import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

public protocol EndpointApiProtocol {
    var url: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: Data? { get }
    var timeout: TimeInterval? { get }
}
