import SwiftUI

struct MovieDetailsView: View {
    let movieDetails: MovieDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MoviePosterView(url: movieDetails.posterURL)
                .frame(maxWidth: .infinity, idealHeight: 232)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 0) {
                Text(movieDetails.title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)

                Text(movieDetails.overview)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#515153"))
            }
        }
        .padding()
    }
}

#Preview {
    MovieDetailsView(movieDetails: MovieDetails(title: "The Shawshank Redemption", overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", backdropPath: "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg", tagline: "Fear can hold you prisoner. Hope can set you free."))
}
