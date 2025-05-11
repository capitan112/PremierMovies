import SwiftUI

struct ErrorView: View {
    let errorMessage: String?
    let fetchData: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)

            Text(errorMessage ?? "Unknown error occurred.")
                .foregroundColor(.primary)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)

            Button("Retry") {
                fetchData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
