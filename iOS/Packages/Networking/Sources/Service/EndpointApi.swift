import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

public struct EndpointApi {
    public let url: String
    public let method: HTTPMethod
    public let header: [String: String]?
    public let body: Data?
    public let timeout: TimeInterval?
    
    init(
        url: String,
        method: HTTPMethod = .GET,
        header: [String : String]? = nil,
        body: Data? = nil,
        timeout: TimeInterval? = nil
    ) {
        self.url = url
        self.method = method
        self.header = header
        self.body = body
        self.timeout = timeout
    }
}
