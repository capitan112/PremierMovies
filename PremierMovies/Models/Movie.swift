import Foundation

struct Movie: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }

    func getGenresString() -> String {
        return GenreMapping.convertGenreIdsToString(genreIds)
    }
}

extension Movie {
    static var topRated: Request<Page<Movie>> {
        Request(method: .get, path: "/movie/top_rated")
    }

    static func similar(for movie: Movie) -> Request<Page<Movie>> {
        Request(method: .get, path: "/movie/\(movie.id)/similar")
    }
}
