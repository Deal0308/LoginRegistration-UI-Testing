import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.25), Color.indigo.opacity(0.18), Color(.systemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea(.container)
    }
}
