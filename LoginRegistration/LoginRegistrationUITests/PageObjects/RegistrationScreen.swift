import XCTest

@MainActor
struct RegistrationScreen {
    let app: XCUIApplication

    func open() {
        let link = app.buttons["registrationNavigationButton"]
        XCTAssertTrue(link.waitForExistence(timeout: 5))
        if !link.isHittable { app.scrollViews.firstMatch.swipeUp() }
        link.tap()
        XCTAssertTrue(app.textFields["usernameField"].waitForExistence(timeout: 5))
    }

    func register(username: String, email: String, password: String) {
        enter(username, into: app.textFields["usernameField"])
        enter(email, into: app.textFields["registrationEmailField"])
        enter(password, into: app.secureTextFields["registrationPasswordField"])
        enter(password, into: app.secureTextFields["confirmPasswordField"])
        let button = app.buttons["registerButton"]
        if !button.isHittable { app.scrollViews.firstMatch.swipeUp() }
        button.tap()
    }

    private func enter(_ text: String, into field: XCUIElement) {
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        if !field.isHittable { app.scrollViews.firstMatch.swipeUp() }
        field.tap()
        field.typeText(text)
    }
}
