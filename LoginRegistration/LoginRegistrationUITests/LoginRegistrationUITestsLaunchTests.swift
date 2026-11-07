import XCTest

final class LoginRegistrationUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func test_launchFresh_showsLoginScreen() throws {
        let app = XCUIApplication()
        app.terminate()
        app.launchArguments = ["-UITesting", "-UITesting-Reset"]
        app.launch()
        LoginScreen(app: app).waitUntilVisible()
        XCTAssertFalse(DashboardScreen(app: app).welcomeLabel.exists)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Fresh login screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
