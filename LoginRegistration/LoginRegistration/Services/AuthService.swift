// Based on Andres de la Cruz's LoginKit, commit 048f918.
import Foundation

@MainActor
final class AuthService: AuthServiceProtocol, RegistrationServicing {
    private let validEmail = "test@mail.com"
    private let validPassword = "test1234"
    private var registeredAccounts: [String: (user: User, password: String)] = [:]

    func login(email: String, password: String) async throws -> User {
        let email = ValidationManager.normalizedEmail(email)
        guard ValidationManager.isValidEmail(email), !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        try await Task.sleep(for: .milliseconds(400))

        if email == validEmail, password == validPassword {
            return User(email: email, name: "Example")
        }
        // Personal extension: accounts registered during this app session can also log in.
        if let account = registeredAccounts[email], account.password == password {
            return account.user
        }
        throw AuthError.invalidCredentials
    }

    func register(username: String, email: String, password: String) throws -> User {
        let normalizedEmail = ValidationManager.normalizedEmail(email)
        guard ValidationManager.isValidUsername(username) else { throw RegistrationError.invalidUsername }
        guard ValidationManager.isValidEmail(normalizedEmail) else { throw RegistrationError.invalidEmail }
        guard ValidationManager.isValidPassword(password) else { throw RegistrationError.invalidPassword }
        guard normalizedEmail != validEmail, registeredAccounts[normalizedEmail] == nil else {
            throw RegistrationError.emailAlreadyRegistered
        }
        let user = User(email: normalizedEmail, name: username.trimmingCharacters(in: .whitespacesAndNewlines))
        registeredAccounts[normalizedEmail] = (user, password)
        return user
    }
}
