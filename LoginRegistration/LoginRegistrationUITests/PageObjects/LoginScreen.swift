import XCTest

@MainActor
struct LoginScreen {
    let app: XCUIApplication

    var emailField: XCUIElement { app.textFields["emailField"] }
    var passwordField: XCUIElement { app.secureTextFields["passwordField"] }
    var loginButton: XCUIElement { app.buttons["loginButton"] }
    var rememberMeSwitch: XCUIElement { app.switches["rememberMeToggle"] }
    var errorLabel: XCUIElement { app.staticTexts["error_label"] }

    var emailValue: String {
        let value = emailField.value as? String ?? ""
        return value == emailField.placeholderValue ? "" : value
    }

    func waitUntilVisible(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(emailField.waitForExistence(timeout: 5), "Login email field should be visible", file: file, line: line)
        XCTAssertTrue(loginButton.exists, "Login button should exist", file: file, line: line)
    }

    func login(email: String, password: String) {
        waitUntilVisible()
        setEmail(email)
        setPassword(password)
        submit()
    }

    func setEmail(_ email: String) {
        replaceText(in: emailField, with: email)
    }

    func setPassword(_ password: String) {
        replaceText(in: passwordField, with: password)
    }

    func setRememberMe(_ enabled: Bool) {
        XCTAssertTrue(rememberMeSwitch.waitForExistence(timeout: 5))
        if !rememberMeSwitch.isHittable { app.scrollViews.firstMatch.swipeUp() }
        if (rememberMeSwitch.value as? String == "1") != enabled {
            rememberMeSwitch.tap()
        }
    }

    func submit() {
        if !loginButton.isHittable {
            app.scrollViews.firstMatch.swipeUp()
        }
        loginButton.tap()
    }

    private func replaceText(in field: XCUIElement, with text: String) {
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        let existing = field.value as? String ?? ""
        if !existing.isEmpty && existing != field.placeholderValue {
            field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: existing.count))
        }
        field.typeText(text)
    }
}
