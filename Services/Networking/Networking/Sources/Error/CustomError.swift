import Foundation

public enum CustomError: Error, LocalizedError {
    private typealias Localizable = Strings.CustomError
    
    case invalidUrl
    case noData
    case encoding(underlying: Error)
    case decoding(underlying: Error)
    case transport(underlying: Error)
    case cancelled
    case invalidHttpResponse
    case http(status: Int)
    case notFound

    public var errorDescription: String {
        let description: String
        switch self {
        case .invalidUrl:               
            description = Localizable.Description.invalidUrl
        case .noData:
            description = Localizable.Description.noData
        case .encoding(let error):
            description = Localizable.Description.encoding(error.localizedDescription)
        case .decoding(let error):
            description = Localizable.Description.decoding(error.localizedDescription)
        case .transport(let error):
            description = Localizable.Description.transport(error.localizedDescription)
        case .cancelled:
            description = Localizable.Description.cancelled
        case .invalidHttpResponse:
            description = Localizable.Description.invalidHttpResponse
        case .http(let status):
            description = CustomError.defaultMessage(for: status)
        case .notFound:
            description = Localizable.Description.notFound
        }
        return description
    }

    private static func defaultMessage(for status: Int) -> String {
        let message: String
        switch status {
        case 400:
            message = Localizable.Default.Message.invalidRequisition
        case 401:
            message = Localizable.Default.Message.notAuthorized
        case 403:
            message = Localizable.Default.Message.accessDenied
        case 404:
            message = Localizable.Description.notFound
        case 409:
            message = Localizable.Default.Message.conflict
        case 422:
            message = Localizable.Default.Message.nonProsecutableEntity
        case 429:
            message = Localizable.Default.Message.manyRequisitions
        case 500:
            message = Localizable.Default.Message.internalError
        case 502:
            message = Localizable.Default.Message.invalidGateway
        case 503:
            message = Localizable.Default.Message.unavailableService
        case 504:
            message = Localizable.Default.Message.timeout
        case 300..<400:
            message = Localizable.Default.Message.redirection(status)
        case 400..<500:
            message = Localizable.Default.Message.client(status)
        case 500..<600:
            message = Localizable.Default.Message.server(status)
        default:
            message = Localizable.Default.Message.http(status)
        }
        return message
    }

    public static func error(from response: HTTPURLResponse?) -> CustomError? {
        guard let response = response else { return .invalidHttpResponse }
        switch response.statusCode {
        case 200...299: return nil
        case 404:       return .notFound
        default:        return .http(status: response.statusCode)
        }
    }
}
