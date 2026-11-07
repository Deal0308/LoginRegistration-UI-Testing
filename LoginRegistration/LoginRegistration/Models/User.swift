import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let username: String
    let email: String
    let password: String

    init(id: UUID = UUID(), username: String, email: String, password: String) {
        self.id = id
        self.username = username
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.password = password
    }
}
