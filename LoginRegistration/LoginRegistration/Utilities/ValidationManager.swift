import Foundation

nonisolated enum ValidationManager {
    static func normalizedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func isValidEmail(_ email: String) -> Bool {
        let email = normalizedEmail(email)
        guard email.utf8.count <= 254 else { return false }
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty, parts[0].utf8.count <= 64 else { return false }
        let local = String(parts[0])
        guard local.range(of: #"^[a-z0-9_%+-]+(?:\.[a-z0-9_%+-]+)*$"#, options: .regularExpression) != nil else { return false }
        let labels = parts[1].split(separator: ".", omittingEmptySubsequences: false)
        guard labels.count >= 2 else { return false }
        guard labels.allSatisfy({ label in
            !label.isEmpty && label.utf8.count <= 63 &&
            !label.hasPrefix("-") && !label.hasSuffix("-") &&
            label.range(of: #"^[a-z0-9-]+$"#, options: .regularExpression) != nil
        }) else { return false }
        guard let topLevelDomain = labels.last else { return false }
        return topLevelDomain.range(of: #"^[a-z]{2,63}$"#, options: .regularExpression) != nil
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
