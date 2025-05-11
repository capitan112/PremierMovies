import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol APIServiceProtocol {
    func execute<Value: Decodable>(_ request: Request<Value>, cachePolicy: CachePolicy, ttl: TimeInterval?) async throws -> Value
}

extension APIServiceProtocol {
    func execute<Value: Decodable>(_ request: Request<Value>, cachePolicy: CachePolicy = .useCacheIfAvailable, ttl: TimeInterval? = nil) async throws -> Value {
        try await execute(request, cachePolicy: cachePolicy, ttl: ttl)
    }
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let host = "https://api.themoviedb.org/3"
    private let apiKey = "e4f9e61f6ffd66639d33d3dde7e3159b"
    private let session: URLSessionProtocol
    private let cache: CacheProtocol

    init(session: URLSessionProtocol = URLSession.shared, cache: CacheProtocol = Cache()) {
        self.session = session
        self.cache = cache
    }

    func execute<Value: Decodable>(_ request: Request<Value>, cachePolicy: CachePolicy, ttl: TimeInterval? = nil) async throws -> Value {
        let urlRequest = request.makeURLRequest(host: host, apiKey: apiKey)

        switch cachePolicy {
        case .useCacheIfAvailable:
            if let cachedData = cache.get(for: urlRequest) {
                return try JSONDecoder().decode(Value.self, from: cachedData)
            }

        case .returnCacheThenLoad:
            if let cachedData = cache.get(for: urlRequest) {
                Task {
                    _ = try? await self.execute(request, cachePolicy: .reloadIgnoringCache)
                }
                return try JSONDecoder().decode(Value.self, from: cachedData)
            }

        case .reloadIgnoringCache:
            break
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw NetworkError.dataLoadingFailed(URLError(.badServerResponse))
        }

        if data.isEmpty && Value.self != EmptyResponse.self {
            throw NetworkError.emptyResponse
        } else if Value.self == EmptyResponse.self {
            return EmptyResponse() as! Value
        }

        cache.set(data, for: urlRequest, ttl: ttl)
        return try JSONDecoder().decode(Value.self, from: data)
    }
}
