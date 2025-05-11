import Foundation

extension Request {
    func makeURLRequest(host: String, apiKey: String) -> URLRequest {
        guard let baseURL = URL(string: host) else {
            preconditionFailure("Invalid host URL: \(host)")
        }

        let normalizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let fullURL = baseURL.appendingPathComponent(normalizedPath)

        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            preconditionFailure("Invalid URL components from: \(fullURL)")
        }

        var queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = queryItems

        guard let finalURL = components.url else {
            preconditionFailure("Failed to build final URL from components: \(components)")
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }
}
