import SwiftUI

@main
struct PremierMoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MoviesView()
            }
        }
    }
}
