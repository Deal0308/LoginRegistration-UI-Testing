import XCTest
@testable import LoginRegistration

@MainActor
final class LoginRegistrationTests: XCTestCase {

    func testInvalidEmailReturnsFalse() {
        // Arrange
        let email = "student-test.com"

        // Act
        let result = ValidationManager.isValidEmail(email)

        // Assert
        XCTAssertFalse(result)
    }

    func testValidEmailReturnsTrue() {
        // Arrange
        let email = "test@mail.com"

        // Act
        let result = ValidationManager.isValidEmail(email)

        // Assert
        XCTAssertTrue(result)
    }

    func testPasswordWithoutNumberReturnsFalse() {
        // Arrange
        let password = "StudentOnly"

        // Act
        let result = ValidationManager.isValidPassword(password)

        // Assert
        XCTAssertFalse(result)
    }

    func testValidPasswordReturnsTrue() {
        // Arrange
        let password = "test1234"

        // Act
        let result = ValidationManager.isValidPassword(password)

        // Assert
        XCTAssertTrue(result)
    }

    func testEmptyLoginShowsError() async {
        // Arrange
        let service = AuthService()
        let viewModel = LoginViewModel(authService: service, sessionStore: MemorySessionStore())

        // Act
        await viewModel.login()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password")
        XCTAssertNil(viewModel.loggedInUser)
    }

    func testPasswordMismatchReturnsError() {
        // Arrange
        let service = AuthService()
        let viewModel = RegistrationViewModel(registrationService: service)
        viewModel.username = "Taylor"
        viewModel.email = "taylor@test.com"
        viewModel.password = "test1234"
        viewModel.confirmPassword = "Student456"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Passwords must match.")
        XCTAssertNil(viewModel.registeredUser)
    }

    func testSuccessfulLogin() async {
        // Arrange
        let service = AuthService()
        let viewModel = LoginViewModel(authService: service, sessionStore: MemorySessionStore())
        viewModel.email = "test@mail.com"
        viewModel.password = "test1234"

        // Act
        await viewModel.login()

        // Assert
        XCTAssertEqual(viewModel.loggedInUser?.name, "Example")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testIncorrectPasswordFailsLogin() async {
        // Arrange
        let service = AuthService()
        let viewModel = LoginViewModel(authService: service, sessionStore: MemorySessionStore())
        viewModel.email = "test@mail.com"
        viewModel.password = "Wrong123"

        // Act
        await viewModel.login()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password")
        XCTAssertNil(viewModel.loggedInUser)
    }

    func testSuccessfulRegistration() {
        // Arrange
        let service = AuthService()
        let viewModel = RegistrationViewModel(registrationService: service)
        viewModel.username = "Taylor"
        viewModel.email = "taylor@test.com"
        viewModel.password = "Taylor123"
        viewModel.confirmPassword = "Taylor123"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(viewModel.registeredUser?.name, "Taylor")
        XCTAssertEqual(viewModel.registeredUser?.email, "taylor@test.com")
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testEmptyUsernameFailsRegistration() {
        // Arrange
        let service = AuthService()
        let viewModel = RegistrationViewModel(registrationService: service)
        viewModel.username = ""
        viewModel.email = "taylor@test.com"
        viewModel.password = "Taylor123"
        viewModel.confirmPassword = "Taylor123"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Username is required.")
        XCTAssertNil(viewModel.registeredUser)
    }
}
