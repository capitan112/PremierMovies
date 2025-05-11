import Combine
import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var state: ViewState<[Movie], Void> = .initial
    @Published var query: String = ""
    @Published private(set) var debouncedQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let apiManager: APIServiceProtocol

    init(apiManager: APIServiceProtocol = APIService.shared) {
        self.apiManager = apiManager
        query = ""
        setupBindings()
    }

    private func setupBindings() {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.debouncedQuery = value
            }
            .store(in: &cancellables)
    }

    var filteredMovies: [Movie] {
        guard case let .loaded(movies) = state else { return [] }

        let trimmedSearch = debouncedQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else { return movies }

        return movies.filter { movie in
            movie.title.localizedCaseInsensitiveContains(trimmedSearch)
                || movie.overview.localizedCaseInsensitiveContains(trimmedSearch)
                || movie.getGenresString().localizedCaseInsensitiveContains(trimmedSearch)
        }
    }

    func fetchData() {
        switch state {
        case .initial, .error:

            Task { [weak self] in
                guard let self else { return }
                self.state = .loading(nil)

                do {
                    let page = try await self.apiManager.execute(Movie.topRated)
                    self.state = .loaded(page.results)
                    
                } catch {
                    self.state = .error(error)
                }
            }
        default:
            break
        }
    }
}
