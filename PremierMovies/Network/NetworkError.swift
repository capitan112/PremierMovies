import Foundation

enum NetworkError: Error {
    case dataLoadingFailed(Error)
    case decodingFailed(Error)
    case emptyResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .dataLoadingFailed(underlying):
            return "Failed to load data: \(underlying.localizedDescription)"
        case .decodingFailed:
            return "Failed to decode server response."
        case .emptyResponse:
            return "Server returned an empty response."
        }
    }
}
