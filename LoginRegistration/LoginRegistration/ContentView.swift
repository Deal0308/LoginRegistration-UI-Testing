import SwiftUI

struct ContentView: View {
    @StateObject private var authenticationService = AuthenticationService()
    private let preferences: LoginPreferences

    init(preferences: LoginPreferences = LoginPreferences()) {
        self.preferences = preferences
    }

    var body: some View {
        Group {
            if let user = authenticationService.currentUser {
                HomeView(user: user) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        authenticationService.logout()
                    }
                }
            } else {
                LoginView(authenticationService: authenticationService, preferences: preferences)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: authenticationService.currentUser)
    }
}

#Preview {
    ContentView()
}
