import XCTest
@testable import LoginRegistration

@MainActor
final class LoginKitContractTests: XCTestCase {
    func test_login_withClassCredentials_returnsExampleUser() async throws {
        let service = AuthService()

        let user = try await service.login(email: "test@mail.com", password: "test1234")

        XCTAssertEqual(user, User(email: "test@mail.com", name: "Example"))
    }

    func test_login_withWrongPassword_throwsClassCredentialsError() async {
        let service = AuthService()

        do {
            _ = try await service.login(email: "test@mail.com", password: "wrong123")
            XCTFail("Invalid credentials must throw.")
        } catch AuthError.invalidCredentials {
            XCTAssertEqual(AuthError.invalidCredentials.localizedDescription, "Invalid email or password")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_login_withInjectedService_usesItsUserAndRemembersEmail() async {
        let user = User(email: "injected@example.com", name: "Injected")
        let service = StubAuthService(user: user)
        let store = MemorySessionStore()
        let viewModel = LoginViewModel(authService: service, sessionStore: store)
        viewModel.email = user.email
        viewModel.password = "mock-password"
        viewModel.rememberMe = true

        await viewModel.login()

        XCTAssertEqual(viewModel.loggedInUser, user)
        XCTAssertEqual(service.receivedEmail, user.email)
        XCTAssertEqual(service.receivedPassword, "mock-password")
        XCTAssertEqual(store.rememberedEmail, user.email)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_logout_withoutRememberMe_clearsUserEmailAndPassword() {
        let viewModel = LoginViewModel(authService: AuthService(), sessionStore: MemorySessionStore())
        viewModel.loggedInUser = User(email: "test@mail.com", name: "Example")
        viewModel.email = "test@mail.com"
        viewModel.password = "test1234"

        viewModel.logout()

        XCTAssertNil(viewModel.loggedInUser)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
    }

    func test_logout_withRememberMe_keepsEmailAndClearsPassword() {
        let viewModel = LoginViewModel(authService: AuthService(), sessionStore: MemorySessionStore())
        viewModel.loggedInUser = User(email: "test@mail.com", name: "Example")
        viewModel.email = "test@mail.com"
        viewModel.password = "test1234"
        viewModel.rememberMe = true

        viewModel.logout()

        XCTAssertNil(viewModel.loggedInUser)
        XCTAssertEqual(viewModel.email, "test@mail.com")
        XCTAssertEqual(viewModel.password, "")
    }

    func test_login_withRegisteredAccount_keepsRegistrationExtensionWorking() async throws {
        let service = AuthService()
        let registered = try service.register(username: "Alex", email: "alex@test.com", password: "Alex1234")

        let loggedIn = try await service.login(email: "alex@test.com", password: "Alex1234")

        XCTAssertEqual(loggedIn, registered)
    }
}
