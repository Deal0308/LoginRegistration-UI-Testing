import Foundation

// Personal extension kept separate from the class login protocol.
@MainActor
protocol RegistrationServicing {
    func register(username: String, email: String, password: String) throws -> User
}

enum RegistrationError: Error, LocalizedError {
    case emailAlreadyRegistered

    var errorDescription: String? {
        "An account with this email already exists."
    }
}
