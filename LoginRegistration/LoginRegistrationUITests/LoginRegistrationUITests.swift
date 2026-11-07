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
        XCTAssertEqual(loginScreen.errorLabel.label, "Invalid email or password")
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
        attachScreenshot(named: "Invalid credentials error", app: app)
    }

    @MainActor
    func test_successfulLogin_opensDashboard() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)

        loginScreen.login(email: "test@mail.com", password: "test1234")

        dashboardScreen.waitUntilVisible()
        XCTAssertFalse(loginScreen.errorLabel.exists)
        XCTAssertEqual(dashboardScreen.welcomeLabel.label, "Welcome, Example")
        attachScreenshot(named: "Successful login dashboard", app: app)
    }

    @MainActor
    func test_logout_returnsToLoginScreen() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        let dashboardScreen = DashboardScreen(app: app)

        XCTContext.runActivity(named: "Sign in with the demo account") { _ in
            loginScreen.login(email: "test@mail.com", password: "test1234")
            dashboardScreen.waitUntilVisible()
        }

        XCTContext.runActivity(named: "Log out from the dashboard") { _ in
            _ = dashboardScreen.logout()
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
        loginScreen.login(email: "test@mail.com", password: "test1234")
        DashboardScreen(app: app).waitUntilVisible()

        relaunchPreservingData(app)

        let relaunchedLogin = LoginScreen(app: app)
        relaunchedLogin.waitUntilVisible()
        XCTAssertEqual(relaunchedLogin.emailValue, "test@mail.com")
        XCTAssertEqual(relaunchedLogin.rememberMeSwitch.value as? String, "1")
        XCTAssertFalse(DashboardScreen(app: app).welcomeLabel.exists)
    }

    @MainActor
    func test_rememberMeOff_removesSavedEmail() throws {
        let app = launchFreshApp()
        let loginScreen = LoginScreen(app: app)
        loginScreen.setRememberMe(true)
        loginScreen.login(email: "test@mail.com", password: "test1234")
        let dashboardScreen = DashboardScreen(app: app)
        dashboardScreen.waitUntilVisible()
        let returnedLogin = dashboardScreen.logout()
        XCTAssertEqual(returnedLogin.emailValue, "test@mail.com")

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
        loginScreen.login(email: "test@mail.com", password: "Wrong123")
        XCTAssertTrue(loginScreen.errorLabel.waitForExistence(timeout: 5))
        XCTAssertFalse(dashboardScreen.welcomeLabel.exists)
        XCTAssertEqual(loginScreen.emailValue, "test@mail.com")

        // Correct only the password; the email field is never edited again.
        loginScreen.setPassword("test1234")
        XCTAssertEqual(loginScreen.emailValue, "test@mail.com")
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
        XCTAssertEqual(dashboard.welcomeLabel.label, "Welcome, Alex")
        dashboard.logout().waitUntilVisible()
    }

    @MainActor
    private func attachScreenshot(named name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
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
