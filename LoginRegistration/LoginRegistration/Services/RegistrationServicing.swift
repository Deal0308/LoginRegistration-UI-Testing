import Foundation

// Personal extension kept separate from the class login protocol.
@MainActor
protocol RegistrationServicing {
    func register(username: String, email: String, password: String) throws -> User
}

nonisolated enum RegistrationError: Error, LocalizedError {
    case emailAlreadyRegistered
    case invalidUsername
    case invalidEmail
    case invalidPassword

    var errorDescription: String? {
        switch self {
        case .emailAlreadyRegistered: return "An account with this email already exists."
        case .invalidUsername: return "Username is required."
        case .invalidEmail: return "Enter a valid email address."
        case .invalidPassword: return "Password must be at least 8 characters and include 1 number."
        }
    }
}
