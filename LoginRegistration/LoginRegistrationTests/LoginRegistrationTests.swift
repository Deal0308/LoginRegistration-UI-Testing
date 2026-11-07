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
        let email = "student@test.com"

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
        let password = "Student123"

        // Act
        let result = ValidationManager.isValidPassword(password)

        // Assert
        XCTAssertTrue(result)
    }

    func testEmptyLoginShowsError() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = LoginViewModel(authenticationService: service)

        // Act
        viewModel.login()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Email and password are required.")
        XCTAssertNil(service.currentUser)
    }

    func testPasswordMismatchReturnsError() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = RegistrationViewModel(authenticationService: service)
        viewModel.username = "Taylor"
        viewModel.email = "taylor@test.com"
        viewModel.password = "Student123"
        viewModel.confirmPassword = "Student456"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Passwords must match.")
        XCTAssertNil(service.currentUser)
    }

    func testSuccessfulLogin() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = LoginViewModel(authenticationService: service)
        viewModel.email = "student@test.com"
        viewModel.password = "Student123"

        // Act
        viewModel.login()

        // Assert
        XCTAssertEqual(service.currentUser?.username, "Student")
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testIncorrectPasswordFailsLogin() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = LoginViewModel(authenticationService: service)
        viewModel.email = "student@test.com"
        viewModel.password = "Wrong123"

        // Act
        viewModel.login()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Incorrect email or password.")
        XCTAssertNil(service.currentUser)
    }

    func testSuccessfulRegistration() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = RegistrationViewModel(authenticationService: service)
        viewModel.username = "Taylor"
        viewModel.email = "taylor@test.com"
        viewModel.password = "Taylor123"
        viewModel.confirmPassword = "Taylor123"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(service.currentUser?.username, "Taylor")
        XCTAssertEqual(service.currentUser?.email, "taylor@test.com")
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testEmptyUsernameFailsRegistration() {
        // Arrange
        let service = AuthenticationService()
        let viewModel = RegistrationViewModel(authenticationService: service)
        viewModel.username = ""
        viewModel.email = "taylor@test.com"
        viewModel.password = "Taylor123"
        viewModel.confirmPassword = "Taylor123"

        // Act
        viewModel.register()

        // Assert
        XCTAssertEqual(viewModel.errorMessage, "Username is required.")
        XCTAssertNil(service.currentUser)
    }
}
