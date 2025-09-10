import Foundation

public final class NetworkService: NetworkServicing {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch<T: Decodable>(
        api: EndpointApi,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, CustomError>) -> Void
    ) {
        guard let request = try? URLRequest.with(endpointApi: api) else {
            return completion(.failure(.invalidUrl))
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            if let urlError = error as? URLError {
                if urlError.code == .cancelled { return completion(.failure(.cancelled)) }
                return completion(.failure(.transport(underlying: urlError)))
            } else if let error {
                return completion(.failure(.transport(underlying: error)))
            }
            
            if let httpError = CustomError.error(from: response as? HTTPURLResponse) {
                return completion(.failure(httpError))
            }
            
            guard let jsonData = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let decoded = try decoder.decode(T.self, from: jsonData)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(underlying: error)))
            }
        }
        
        task.resume()
    }
}
