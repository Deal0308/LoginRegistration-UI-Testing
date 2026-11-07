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
    private var activeLoginID: UUID?

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
        guard !isLoading else { return }
        let loginID = UUID()
        activeLoginID = loginID
        errorMessage = nil
        isLoading = true
        let submittedEmail = ValidationManager.normalizedEmail(email)
        let submittedPassword = password
        defer {
            if activeLoginID == loginID {
                isLoading = false
                activeLoginID = nil
            }
        }

        do {
            let user = try await authService.login(email: submittedEmail, password: submittedPassword)
            try Task.checkCancellation()
            guard activeLoginID == loginID else { return }
            loggedInUser = user
            email = user.email
            if rememberMe {
                sessionStore.rememberedEmail = user.email
            } else {
                sessionStore.clear()
            }
        } catch is CancellationError {
            // Leaving the screen or cancelling a request is not a login failure.
        } catch {
            guard activeLoginID == loginID, !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        activeLoginID = nil
        isLoading = false
        loggedInUser = nil
        password = ""
        errorMessage = nil
        if !rememberMe { email = "" }
    }

    // Personal extension: registration joins the same view-model-owned session.
    func completeRegistration(with user: User) {
        activeLoginID = nil
        isLoading = false
        email = user.email
        password = ""
        errorMessage = nil
        loggedInUser = user
    }
}
