import SwiftUI

struct KeyboardWarmUpView: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocorrectionType = .no
        textField.text = ""
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
            textField.resignFirstResponder()
        }
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {}
}
