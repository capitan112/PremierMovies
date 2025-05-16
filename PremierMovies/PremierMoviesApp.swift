import SwiftUI

@main
struct PremierMoviesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MoviesView()
                    .background(KeyboardWarmUpView().frame(width: 0, height: 0))
            }
        }
    }
}
