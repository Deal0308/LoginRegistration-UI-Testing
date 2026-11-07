import XCTest

@MainActor
struct DashboardScreen {
    let app: XCUIApplication

    var welcomeLabel: XCUIElement { app.staticTexts["welcome_label"] }
    var logoutButton: XCUIElement { app.buttons["logoutButton"] }

    func waitUntilVisible(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5), "Dashboard should open", file: file, line: line)
        XCTAssertTrue(logoutButton.exists, file: file, line: line)
    }

    @discardableResult
    func logout() -> LoginScreen {
        logoutButton.tap()
        let login = LoginScreen(app: app)
        login.waitUntilVisible()
        return login
    }
}
