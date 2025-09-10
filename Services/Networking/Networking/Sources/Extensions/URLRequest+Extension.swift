import Foundation

extension URLRequest {
    static func with(endpointApi api: EndpointApi) throws -> Self {
        guard let url = URL(string: api.url) else {
            throw CustomError.invalidUrl
        }
        let defaultRequest = URLRequest(url: url)
        var request = URLRequest(
            url: url,
            timeoutInterval: api.timeout ?? defaultRequest.timeoutInterval
        )
        request.httpMethod = api.method.rawValue
        if let header = api.header { request.allHTTPHeaderFields = header }
        request.httpBody = api.body
        
        return request
    }
}
