// Based on Andres de la Cruz's LoginKit, commit 048f918.
import Foundation

@MainActor
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
}

nonisolated enum AuthError: Error, LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        }
    }
}
