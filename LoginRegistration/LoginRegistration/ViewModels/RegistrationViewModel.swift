import Combine
import Foundation

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var registeredUser: User?

    private let registrationService: RegistrationServicing

    init(registrationService: RegistrationServicing) {
        self.registrationService = registrationService
    }

    func register() {
        errorMessage = ""

        guard ValidationManager.isValidUsername(username) else {
            errorMessage = "Username is required."
            return
        }

        guard ValidationManager.isValidEmail(email) else {
            errorMessage = "Enter a valid email address."
            return
        }

        guard ValidationManager.isValidPassword(password) else {
            errorMessage = "Password must be at least 8 characters and include 1 number."
            return
        }

        guard ValidationManager.passwordsMatch(password, confirmPassword) else {
            errorMessage = "Passwords must match."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            registeredUser = try registrationService.register(username: username, email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
