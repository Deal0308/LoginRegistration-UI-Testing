import XCTest
@testable import LoginRegistration

@MainActor
final class LoginPreferencesTests: XCTestCase {
    func test_init_withRememberedEmail_prefillsEmailAndRememberMe() {
        withPreferences { preferences, _ in
            preferences.remember(email: "  Student@TEST.com  ")

            let viewModel = LoginViewModel(authenticationService: AuthenticationService(), preferences: preferences)

            XCTAssertEqual(viewModel.email, "student@test.com")
            XCTAssertTrue(viewModel.rememberMe)
            XCTAssertEqual(viewModel.password, "")
        }
    }

    func test_login_withRememberMe_savesEmailWithoutPassword() {
        withPreferences { preferences, defaults in
            let viewModel = LoginViewModel(authenticationService: AuthenticationService(), preferences: preferences)
            viewModel.email = "student@test.com"
            viewModel.password = "Student123"
            viewModel.rememberMe = true

            viewModel.login()

            XCTAssertEqual(preferences.rememberedEmail, "student@test.com")
            XCTAssertNil(defaults.string(forKey: "password"))
        }
    }

    func test_rememberMe_whenTurnedOff_clearsSavedEmailWithoutLogin() {
        withPreferences { preferences, _ in
            preferences.remember(email: "student@test.com")
            let viewModel = LoginViewModel(authenticationService: AuthenticationService(), preferences: preferences)

            viewModel.rememberMe = false

            XCTAssertNil(preferences.rememberedEmail)
            XCTAssertEqual(viewModel.email, "student@test.com")
        }
    }

    func test_login_withWrongPassword_doesNotRememberEmail() {
        withPreferences { preferences, _ in
            let viewModel = LoginViewModel(authenticationService: AuthenticationService(), preferences: preferences)
            viewModel.email = "student@test.com"
            viewModel.password = "Wrong123"
            viewModel.rememberMe = true

            viewModel.login()

            XCTAssertNil(preferences.rememberedEmail)
            XCTAssertEqual(viewModel.errorMessage, "Incorrect email or password.")
        }
    }

    private func withPreferences(_ body: (LoginPreferences, UserDefaults) -> Void) {
        let suite = "LoginPreferencesTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        body(LoginPreferences(defaults: defaults), defaults)
    }
}
