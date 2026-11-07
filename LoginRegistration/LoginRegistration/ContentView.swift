import SwiftUI

@MainActor
struct ContentView: View {
    private let sessionStore: SessionStoring

    init(sessionStore: SessionStoring? = nil) {
        self.sessionStore = sessionStore ?? SessionStore()
    }

    var body: some View {
        LoginView(sessionStore: sessionStore)
    }
}

#Preview {
    ContentView()
}
