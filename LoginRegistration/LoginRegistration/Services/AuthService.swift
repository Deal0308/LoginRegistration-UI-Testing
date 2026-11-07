// Based on Andres de la Cruz's LoginKit, commit 048f918.
import Foundation

@MainActor
final class AuthService: AuthServiceProtocol, RegistrationServicing {
    private let validEmail = "test@mail.com"
    private let validPassword = "test1234"
    private var registeredAccounts: [String: (user: User, password: String)] = [:]

    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 400_000_000)

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
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard normalizedEmail != validEmail, registeredAccounts[normalizedEmail] == nil else {
            throw RegistrationError.emailAlreadyRegistered
        }
        let user = User(email: normalizedEmail, name: username.trimmingCharacters(in: .whitespacesAndNewlines))
        registeredAccounts[normalizedEmail] = (user, password)
        return user
    }
}
