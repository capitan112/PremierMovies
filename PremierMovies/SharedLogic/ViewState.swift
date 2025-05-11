import Foundation

enum ViewState<Content, LoadingContext> {
    case initial
    case loading(LoadingContext?)
    case loaded(Content)
    case error(Error)
}

extension ViewState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var errorMessage: String? {
        if case let .error(error) = self {
            return (error as? LocalizedError)?.errorDescription ?? "Unknown error occurred."
        }
        return nil
    }

    var value: Content? {
        if case let .loaded(value) = self {
            return value
        }
        return nil
    }

    var loadingContext: LoadingContext? {
        if case let .loading(ctx) = self {
            return ctx
        }
        return nil
    }
}
