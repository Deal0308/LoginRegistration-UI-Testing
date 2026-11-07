// Based on Andres de la Cruz's LoginKit, commit 048f918.
import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var rememberMe = false {
        didSet {
            // Exercise 5: turning Remember Me off also clears the stored email immediately.
            if !rememberMe { sessionStore.clear() }
        }
    }
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loggedInUser: User?

    private let authService: AuthServiceProtocol
    private var sessionStore: SessionStoring

    init(authService: AuthServiceProtocol, sessionStore: SessionStoring? = nil) {
        let sessionStore = sessionStore ?? SessionStore()
        self.authService = authService
        self.sessionStore = sessionStore
        if let rememberedEmail = sessionStore.rememberedEmail {
            email = rememberedEmail
            rememberMe = true
        }
    }

    func login() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await authService.login(email: email, password: password)
            loggedInUser = user
            if rememberMe {
                sessionStore.rememberedEmail = email
            } else {
                sessionStore.clear()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        loggedInUser = nil
        password = ""
        if !rememberMe { email = "" }
    }

    // Personal extension: registration joins the same view-model-owned session.
    func completeRegistration(with user: User) {
        email = user.email
        password = ""
        errorMessage = nil
        loggedInUser = user
    }
}
