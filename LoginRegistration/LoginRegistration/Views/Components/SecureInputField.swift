import SwiftUI

struct SecureInputField: View {
    let title: String
    @Binding var text: String
    var accessibilityIdentifier: String
    var visibilityAccessibilityIdentifier: String?
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)
                .frame(width: 22)

            Group {
                if isVisible {
                    TextField(title, text: $text)
                } else {
                    SecureField(title, text: $text)
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .accessibilityIdentifier(accessibilityIdentifier)

            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    isVisible.toggle()
                }
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(isVisible ? "Hide password" : "Show password")
            .accessibilityIdentifier(visibilityAccessibilityIdentifier ?? "\(accessibilityIdentifier)VisibilityButton")
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
