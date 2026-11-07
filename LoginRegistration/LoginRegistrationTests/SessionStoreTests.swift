import XCTest
@testable import LoginRegistration

@MainActor
final class SessionStoreTests: XCTestCase {
    func test_init_withRememberedEmail_prefillsEmailAndRememberMe() async {
        await withStore { store, _ in
            store.rememberedEmail = "test@mail.com"

            let viewModel = LoginViewModel(authService: AuthService(), sessionStore: store)

            XCTAssertEqual(viewModel.email, "test@mail.com")
            XCTAssertTrue(viewModel.rememberMe)
            XCTAssertEqual(viewModel.password, "")
        }
    }

    func test_login_withRememberMe_savesEmailWithoutPassword() async {
        await withStore { store, defaults in
            let viewModel = LoginViewModel(authService: AuthService(), sessionStore: store)
            viewModel.email = "test@mail.com"
            viewModel.password = "test1234"
            viewModel.rememberMe = true

            await viewModel.login()

            XCTAssertEqual(store.rememberedEmail, "test@mail.com")
            XCTAssertEqual(defaults.string(forKey: "rememberedEmail"), "test@mail.com")
            XCTAssertNil(defaults.string(forKey: "password"))
        }
    }

    func test_rememberMe_whenTurnedOff_clearsSavedEmailWithoutLogin() async {
        await withStore { store, _ in
            store.rememberedEmail = "test@mail.com"
            let viewModel = LoginViewModel(authService: AuthService(), sessionStore: store)

            viewModel.rememberMe = false

            XCTAssertNil(store.rememberedEmail)
            XCTAssertEqual(viewModel.email, "test@mail.com")
        }
    }

    func test_login_withWrongPassword_doesNotRememberEmail() async {
        await withStore { store, _ in
            let viewModel = LoginViewModel(authService: AuthService(), sessionStore: store)
            viewModel.email = "test@mail.com"
            viewModel.password = "Wrong123"
            viewModel.rememberMe = true

            await viewModel.login()

            XCTAssertNil(store.rememberedEmail)
            XCTAssertEqual(viewModel.errorMessage, "Invalid email or password")
        }
    }

    private func withStore(_ body: (SessionStore, UserDefaults) async -> Void) async {
        let suite = "SessionStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        await body(SessionStore(defaults: defaults), defaults)
    }
}
