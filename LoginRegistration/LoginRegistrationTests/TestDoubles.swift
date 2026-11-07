import Foundation
@testable import LoginRegistration

@MainActor
final class MemorySessionStore: SessionStoring {
    var rememberedEmail: String?

    init(rememberedEmail: String? = nil) {
        self.rememberedEmail = rememberedEmail
    }

    func clear() { rememberedEmail = nil }
}

@MainActor
final class StubAuthService: AuthServiceProtocol {
    let user: User
    private(set) var receivedEmail: String?
    private(set) var receivedPassword: String?

    init(user: User) { self.user = user }

    func login(email: String, password: String) async throws -> User {
        receivedEmail = email
        receivedPassword = password
        return user
    }
}
