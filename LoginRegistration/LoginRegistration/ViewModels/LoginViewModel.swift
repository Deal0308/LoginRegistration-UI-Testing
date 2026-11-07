import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var rememberMe = false {
        didSet {
            if !rememberMe { preferences.clear() }
        }
    }

    private let authenticationService: AuthenticationService
    private let preferences: LoginPreferences

    init(authenticationService: AuthenticationService, preferences: LoginPreferences = LoginPreferences()) {
        self.authenticationService = authenticationService
        self.preferences = preferences
        let rememberedEmail = preferences.rememberedEmail
        email = rememberedEmail ?? ""
        rememberMe = rememberedEmail != nil
    }

    var canAttemptLogin: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func login() {
        errorMessage = ""

        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        guard ValidationManager.isValidEmail(email) else {
            errorMessage = "Enter a valid email address."
            return
        }

        isLoading = true
        defer { isLoading = false }

        guard authenticationService.login(email: email, password: password) else {
            errorMessage = "Incorrect email or password."
            return
        }

        if rememberMe {
            preferences.remember(email: email)
        } else {
            preferences.clear()
        }
    }
}
