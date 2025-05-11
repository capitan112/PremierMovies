import SwiftUI

struct TagView: View {
    let style: Style

    var body: some View {
        HStack(spacing: 4) {
            if let iconName = style.iconName {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(style.tintColor)
            }

            Text(style.text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(style.tintColor)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(style.backgroundColor)
        .cornerRadius(4)
    }

    struct Style {
        let backgroundColor: Color
        let tintColor: Color
        let iconName: String?
        let text: String

        static func rating(value: Double) -> Style {
            Style(
                backgroundColor: .black.opacity(0.85),
                tintColor: .white,
                iconName: "star",
                text: String(format: "%.1f", value)
            )
        }
    }
}
