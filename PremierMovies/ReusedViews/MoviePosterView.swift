import SwiftUI

struct MoviePosterView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.3)
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Color.red.opacity(0.3)
            @unknown default:
                EmptyView()
            }
        }
    }
}
