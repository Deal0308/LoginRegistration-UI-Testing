import XCTest

final class LoginRegistrationUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_invalidLogin_showsErrorMessage() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)

        loginScreen.login(email: "testerror@mail.com", password: "1234test")

        XCTAssertTrue(loginScreen.errorLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(loginScreen.errorLabel.label, "Incorrect email or password.")
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
    }

    @MainActor
    func test_successfulLogin_opensDashboard() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)

        loginScreen.login(email: "student@test.com", password: "Student123")

        dashboardScreen.waitUntilVisible()
        XCTAssertFalse(loginScreen.errorLabel.exists)
    }

    @MainActor
    func test_logout_returnsToLoginScreen() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)

        XCTContext.runActivity(named: "Sign in with the demo account") { _ in
            loginScreen.login(email: "student@test.com", password: "Student123")
            dashboardScreen.waitUntilVisible()
        }

        XCTContext.runActivity(named: "Log out from the dashboard") { _ in
            dashboardScreen.logout()
        }

        XCTContext.runActivity(named: "Verify the login screen and attach evidence") { activity in
            loginScreen.waitUntilVisible()
            XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "Login screen after logout"
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }

    @MainActor
    func test_rememberedEmail_persistsAfterRelaunch() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        loginScreen.setRememberMe(true)
        loginScreen.login(email: "student@test.com", password: "Student123")
        DashboardScreen(app: app).waitUntilVisible()

        relaunchPreservingData(app)

        let relaunchedLogin = LoginScreen(app: app)
        relaunchedLogin.waitUntilVisible()
        XCTAssertEqual(relaunchedLogin.emailValue, "student@test.com")
        XCTAssertEqual(relaunchedLogin.rememberMeSwitch.value as? String, "1")
        XCTAssertFalse(DashboardScreen(app: app).welcomeLabel.exists)
    }

    @MainActor
    func test_rememberMeOff_removesSavedEmail() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        loginScreen.setRememberMe(true)
        loginScreen.login(email: "student@test.com", password: "Student123")
        let dashboardScreen = DashboardScreen(app: app)
        dashboardScreen.waitUntilVisible()
        let returnedLogin = dashboardScreen.logout()
        XCTAssertEqual(returnedLogin.emailValue, "student@test.com")

        returnedLogin.setRememberMe(false)
        relaunchPreservingData(app)

        let relaunchedLogin = LoginScreen(app: app)
        relaunchedLogin.waitUntilVisible()
        XCTAssertEqual(relaunchedLogin.emailValue, "")
        XCTAssertEqual(relaunchedLogin.rememberMeSwitch.value as? String, "0")
    }

    @MainActor
    func test_correctingOnlyPassword_afterWrongPassword_logsIn() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)
        loginScreen.login(email: "student@test.com", password: "Wrong123")
        XCTAssertTrue(loginScreen.errorLabel.waitForExistence(timeout: 5))
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
        XCTAssertEqual(loginScreen.emailValue, "student@test.com")

        // Correct only the password; the email field is never edited again.
        loginScreen.setPassword("Student123")
        XCTAssertEqual(loginScreen.emailValue, "student@test.com")
        loginScreen.submit()

        dashboardScreen.waitUntilVisible()
    }

    @MainActor
    func test_registration_opensDashboardAndCanLogOut() throws {
        let app = launchFreshApp()
        let registration = RegistrationScreen(app: app)

        registration.open()
        registration.register(username: "Alex", email: "alex@test.com", password: "Alex1234")

        let dashboard = DashboardScreen(app: app)
        dashboard.waitUntilVisible()
        XCTAssertEqual(dashboard.welcomeLabel.label, "Welcome, Alex!")
        dashboard.logout().waitUntilVisible()
    }

    @MainActor
    private func launchFreshApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.terminate()
        app.launchArguments = ["-UITesting", "-UITesting-Reset"]
        app.launch()
        LoginScreen(app: app).waitUntilVisible()
        return app
    }

    @MainActor
    private func relaunchPreservingData(_ app: XCUIApplication) {
        app.terminate()
        // Reset only at the beginning of a test, never during a persistence check.
        app.launchArguments.removeAll { $0 == "-UITesting-Reset" }
        app.launch()
    }
}
