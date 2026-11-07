import Combine
import Foundation

@MainActor
final class AuthenticationService: ObservableObject {
    @Published private(set) var currentUser: User?

    private var users: [String: User]

    init() {
        let defaultUser = User(username: "Student", email: "student@test.com", password: "Student123")
        users = [defaultUser.email: defaultUser]
    }

    @discardableResult
    func login(email: String, password: String) -> Bool {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let user = users[normalizedEmail], user.password == password else {
            currentUser = nil
            return false
        }

        currentUser = user
        return true
    }

    @discardableResult
    func register(username: String, email: String, password: String) -> Bool {
        let user = User(username: username.trimmingCharacters(in: .whitespacesAndNewlines), email: email, password: password)
        guard users[user.email] == nil else { return false }

        users[user.email] = user
        currentUser = user
        return true
    }

    func logout() {
        currentUser = nil
    }
}
