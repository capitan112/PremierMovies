import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .bottomLeading) {
                    MoviePosterView(url: movie.posterURL)
                        .clipped()
                        .cornerRadius(10)
                        .frame(width: 100, height: 150)
                }

                TagView(style: .rating(value: movie.voteAverage))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#6A6A72"))
                    .lineLimit(5)
            }

            Spacer()
        }
    }
}

#Preview {
    MovieRowView(movie: Movie(id: 278, title: "The Shawshank Redemption", overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 8.7, genreIds: [18, 80]))
}
