import Foundation

struct MovieDetails: Decodable {
    let title: String
    let overview: String
    let backdropPath: String
    let tagline: String?

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case backdropPath = "backdrop_path"
        case tagline
    }

    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w1280/\(backdropPath)")
    }
}

extension MovieDetails {
    static func details(for movie: Movie) -> Request<MovieDetails> {
        return Request(method: .get, path: "/movie/\(movie.id)")
    }
}
