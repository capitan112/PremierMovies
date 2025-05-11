import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding()
            .transition(.opacity.combined(with: .scale))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .initial, .loading:
                loadingView
            case .loaded:
                VStack(spacing: 0) {
                    SearchBar(text: $viewModel.query)
                        .padding(.vertical, 8)
                    ScrollView {
                        if viewModel.filteredMovies.isEmpty {
                            Text("No results found")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(viewModel.filteredMovies.prefix(20)) { movie in
                                    NavigationLink(destination: MovieDisplayView(movie: movie)) {
                                        MovieRowView(movie: movie)
                                            .padding(.vertical, 8)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    if movie.id != viewModel.filteredMovies.last?.id {
                                        Divider()
                                            .background(Color.gray.opacity(0.4))
                                            .padding(.leading, 124)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.filteredMovies)
            case .error:
                ErrorView(
                    errorMessage: viewModel.state.errorMessage,
                    fetchData: { viewModel.fetchData() }
                )
                .transition(.opacity)
            }
        }
        .navigationTitle("Top Movies")
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    NavigationStack {
        MoviesView()
    }
}
