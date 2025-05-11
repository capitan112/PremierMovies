import SwiftUI

struct MovieDisplayView: View {
    @StateObject private var viewModel: MoviesDisplayViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDetails = false

    private let movie: Movie

    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MoviesDisplayViewModel(initialMovie: movie))
        self.movie = movie
    }

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding()
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .initial, .loading:
                loadingView

            case let .loaded(movieDetails):
                VStack(alignment: .leading) {
                    ScrollView {
                        MovieDetailsView(movieDetails: movieDetails)
                            .opacity(showDetails ? 1 : 0)
                            .animation(.easeIn(duration: 0.3), value: showDetails)
                            .onAppear {
                                showDetails = true
                            }
                        withAnimation {
                            similarMoviesSection()
                        }
                    }
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.4), value: viewModel.state.isLoading)
            case .error:
                ErrorView(errorMessage: viewModel.state.errorMessage, fetchData: { viewModel.fetchDetails() })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchDetails()
        }
    }

    @ViewBuilder
    private func similarMoviesSection() -> some View {
        switch viewModel.similarMoviesState {
        case let .loaded(similarMovies):
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Similar movies")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        print("View all tapped")
                    }) {
                        HStack(spacing: 4) {
                            Text("View all")
                                .font(.system(size: 14))
                                .foregroundColor(.purple)

                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.purple)
                        }
                    }
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 12) {
                        ForEach(similarMovies) { movie in
                            SimilarMovieCard(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
                .coordinateSpace(name: "scroll")
            }

        case .loading:
            ProgressView()
                .padding()

        case .error:
            Text(viewModel.similarMoviesState.errorMessage ?? "Failed to load similar movies")
                .foregroundColor(.red)
                .padding()

        default:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        MovieDisplayView(movie: Movie(id: 278, title: "The Shawshank Redemption", overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", voteAverage: 8.7, genreIds: [18, 80]))
    }
}
