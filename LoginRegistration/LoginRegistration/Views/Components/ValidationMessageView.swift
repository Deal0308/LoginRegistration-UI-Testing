import SwiftUI

struct ValidationMessageView: View {
    let message: String
    let accessibilityIdentifier: String

    var body: some View {
        if !message.isEmpty {
            Label(message, systemImage: "exclamationmark.circle.fill")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier(accessibilityIdentifier)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}
