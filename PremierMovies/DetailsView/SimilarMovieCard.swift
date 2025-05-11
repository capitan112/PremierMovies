import SwiftUI

struct SimilarMovieCard: View {
    let movie: Movie
    let cellWidth: CGFloat = 144
    let cellHeight: CGFloat = 300
    let posterHeight: CGFloat = 212

    var body: some View {
        GeometryReader { geo in
            let frame = geo.frame(in: .named("scroll"))
            let screenMidX = UIScreen.main.bounds.width / 2
            let distance = abs(frame.midX - screenMidX)
            let scale = max(1.0, 1.25 - (distance / screenMidX) * 0.25)

            VStack(alignment: .leading, spacing: 8) {
                MoviePosterView(url: movie.posterURL)
                    .frame(width: 144, height: 212)
                    .clipped()
                    .cornerRadius(16)

                Text(movie.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(height: 10, alignment: .topLeading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(movie.getGenresString())
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(height: 10, alignment: .topLeading)
                    .padding(.bottom, 8)

                TagView(style: .rating(value: movie.voteAverage))
                    .scaleEffect(scale)
                    .animation(abs(scale - 1.0) > 0.01 ? .easeInOut(duration: 0.2) : nil, value: scale)
            }
            .frame(width: cellWidth)
        }
        .frame(width: cellWidth, height: cellHeight)
    }
}

#Preview {
    SimilarMovieCard(movie: Movie(
        id: 1,
        title: "The Shawshank Redemption",
        overview: "Drama, TV Movie",
        posterPath: "/path.jpg",
        voteAverage: 7.5,
        genreIds: [18, 80]
    ))
}
