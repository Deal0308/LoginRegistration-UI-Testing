import XCTest
@testable import LoginRegistration

@MainActor
final class ModernLoginLogicTests: XCTestCase {
    func test_login_whileRequestIsPending_doesNotStartDuplicateRequest() async {
        let started = XCTestExpectation(description: "First login started")
        let service = SuspendedAuthService(started: started)
        let viewModel = makeViewModel(service)
        let first = Task { await viewModel.login() }
        let startResult = await XCTWaiter.fulfillment(of: [started], timeout: 5)
        XCTAssertEqual(startResult, .completed)

        await viewModel.login()

        XCTAssertEqual(service.callCount, 1)
        service.succeed()
        await first.value
    }

    func test_login_whenCancelled_ignoresAServiceThatStillReturnsSuccess() async {
        let started = XCTestExpectation(description: "Login started")
        let service = SuspendedAuthService(started: started)
        let store = MemorySessionStore()
        let viewModel = makeViewModel(service, store: store)
        viewModel.rememberMe = true
        let request = Task { await viewModel.login() }
        let startResult = await XCTWaiter.fulfillment(of: [started], timeout: 5)
        XCTAssertEqual(startResult, .completed)

        request.cancel()
        service.succeed()
        await request.value

        XCTAssertNil(viewModel.loggedInUser)
        XCTAssertNil(store.rememberedEmail)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_login_whenServiceThrowsCancellation_doesNotDisplayAnError() async {
        let started = XCTestExpectation(description: "Login started")
        let service = SuspendedAuthService(started: started)
        let viewModel = makeViewModel(service)
        let request = Task { await viewModel.login() }
        let startResult = await XCTWaiter.fulfillment(of: [started], timeout: 5)
        XCTAssertEqual(startResult, .completed)

        service.cancel()
        await request.value

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.loggedInUser)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_logout_whileLoginIsPending_preventsLateResponseFromSigningIn() async {
        let started = XCTestExpectation(description: "Login started")
        let service = SuspendedAuthService(started: started)
        let viewModel = makeViewModel(service)
        let request = Task { await viewModel.login() }
        let startResult = await XCTWaiter.fulfillment(of: [started], timeout: 5)
        XCTAssertEqual(startResult, .completed)

        viewModel.logout()
        service.succeed()
        await request.value

        XCTAssertNil(viewModel.loggedInUser)
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_login_whenInputChangesDuringRequest_remembersTheAuthenticatedEmail() async {
        let started = XCTestExpectation(description: "Login started")
        let service = SuspendedAuthService(started: started)
        let store = MemorySessionStore()
        let viewModel = makeViewModel(service, store: store)
        viewModel.rememberMe = true
        let request = Task { await viewModel.login() }
        let startResult = await XCTWaiter.fulfillment(of: [started], timeout: 5)
        XCTAssertEqual(startResult, .completed)
        viewModel.email = "different@example.com"

        service.succeed()
        await request.value

        XCTAssertEqual(store.rememberedEmail, "test@mail.com")
        XCTAssertEqual(viewModel.email, "test@mail.com")
    }

    func test_emailValidation_withMalformedDotsOrDomain_rejectsInput() {
        let invalid = ["a..b@example.com", ".a@example.com", "a.@example.com",
                       "a@-example.com", "a@example-.com", "a@example..com"]

        let results = invalid.map(ValidationManager.isValidEmail)

        XCTAssertEqual(results, Array(repeating: false, count: invalid.count))
    }

    func test_login_withWhitespaceAndUppercaseEmail_usesTheSameClassAccount() async throws {
        let service = AuthService()

        let user = try await service.login(email: "  TEST@MAIL.COM \n", password: "test1234")

        XCTAssertEqual(user, User(email: "test@mail.com", name: "Example"))
    }

    func test_register_withInvalidProfile_rejectsItAtTheServiceBoundary() {
        let service = AuthService()

        XCTAssertThrowsError(try service.register(username: " ", email: "bad", password: "short"))
    }

    private func makeViewModel(_ service: AuthServiceProtocol, store: MemorySessionStore? = nil) -> LoginViewModel {
        let viewModel = LoginViewModel(authService: service, sessionStore: store ?? MemorySessionStore())
        viewModel.email = "test@mail.com"
        viewModel.password = "test1234"
        return viewModel
    }
}

@MainActor
private final class SuspendedAuthService: AuthServiceProtocol {
    private let started: XCTestExpectation
    private var continuation: CheckedContinuation<User, Error>?
    private(set) var callCount = 0
    private let user = User(email: "test@mail.com", name: "Example")

    init(started: XCTestExpectation) { self.started = started }

    func login(email: String, password: String) async throws -> User {
        callCount += 1
        // A duplicate returns immediately so the regression fails without hanging.
        if callCount > 1 { return user }
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            started.fulfill()
        }
    }

    func succeed() {
        continuation?.resume(returning: user)
        continuation = nil
    }

    func cancel() {
        continuation?.resume(throwing: CancellationError())
        continuation = nil
    }
}
