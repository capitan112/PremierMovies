import Foundation

@MainActor
final class MoviesDisplayViewModel: ObservableObject {
    let initialMovie: Movie
    @Published var state: ViewState<MovieDetails, Movie> = .initial
    @Published var similarMoviesState: ViewState<[Movie], Void> = .initial

    private let apiManager: APIServiceProtocol

    init(apiManager: APIServiceProtocol = APIService.shared, initialMovie: Movie) {
        self.apiManager = apiManager
        self.initialMovie = initialMovie
    }

    func fetchDetails() {
        state = .loading(initialMovie)
        similarMoviesState = .loading(nil)

        Task { [weak self] in
            guard let self else { return }

            async let detailsTask = apiManager.execute(MovieDetails.details(for: self.initialMovie))
            async let genresTask = self.fetchGenres()
            async let similarTask = apiManager.execute(Movie.similar(for: self.initialMovie))

            do {
                let (details, genres, similarPage) = try await (detailsTask, genresTask, similarTask)
                GenreMapping.update(with: genres.genres)

                self.state = .loaded(details)
                self.similarMoviesState = .loaded(similarPage.results)
                
            } catch {
                self.state = .error(error)
                self.similarMoviesState = .error(error)
            }
        }
    }

    private func fetchGenres() async throws -> Genres {
        try await apiManager.execute(Genres.genresRequest(), cachePolicy: .useCacheIfAvailable, ttl: 3600)
    }
}
