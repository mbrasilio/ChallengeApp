import Foundation

public enum CustomError: Error, LocalizedError {
    case invalidUrl
    case noData
    case encoding(underlying: Error)
    case decoding(underlying: Error)
    case transport(underlying: Error)
    case cancelled
    case invalidHttpResponse
    case http(status: Int, data: Data?)
    case notFound

    public var errorDescription: String? {
        let description: String
        switch self {
        case .invalidUrl:               
            description = "URL inválida."
        case .noData:
            description = "Resposta vazia do servidor."
        case .encoding(let error):
            description = "Falha ao montar o corpo da requisição: \(error.localizedDescription)"
        case .decoding(let error):
            description = "Falha ao interpretar a resposta: \(error.localizedDescription)"
        case .transport(let error):
            description = "Falha de conexão: \(error.localizedDescription)"
        case .cancelled:
            description = "Operação cancelada."
        case .invalidHttpResponse:
            description = "Falha ao interpretar o HTTP"
        case .http(let status, _):
            description = CustomError.defaultMessage(for: status)
        case .notFound:
            description = "Recurso não encontrado (404)."
        }
        return description
    }

    private static func defaultMessage(for status: Int) -> String {
        switch status {
        case 400: return "Requisição inválida (400)."
        case 401: return "Não autorizado (401)."
        case 403: return "Acesso negado (403)."
        case 404: return "Recurso não encontrado (404)."
        case 409: return "Conflito (409)."
        case 422: return "Entidade não processável (422)."
        case 429: return "Muitas requisições (429)."
        case 500: return "Erro interno do servidor (500)."
        case 502: return "Gateway inválido (502)."
        case 503: return "Serviço indisponível (503)."
        case 504: return "Tempo de resposta excedido (504)."
        case 300..<400: return "Redirecionamento (\(status))."
        case 400..<500: return "Erro do cliente (\(status))."
        case 500..<600: return "Erro do servidor (\(status))."
        default: return "Erro HTTP (\(status))."
        }
    }

    public static func error(from response: HTTPURLResponse?, data: Data?) -> CustomError? {
        guard let response = response else { return .invalidHttpResponse }
        switch response.statusCode {
        case 200...299: return nil
        case 404:       return .notFound
        default:        return .http(status: response.statusCode, data: data)
        }
    }
}
