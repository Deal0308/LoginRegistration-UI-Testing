import Foundation

enum ValidationManager {
    static func isValidEmail(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else { return false }

        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return trimmedEmail.range(of: pattern, options: .regularExpression) != nil
    }

    static func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        return password.rangeOfCharacter(from: .decimalDigits) != nil
    }

    static func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        password == confirmPassword
    }

    static func isValidUsername(_ username: String) -> Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
