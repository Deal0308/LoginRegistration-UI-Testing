import Foundation

final class LoginPreferences {
    private let defaults: UserDefaults
    private let emailKey = "remembered_email"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var rememberedEmail: String? {
        defaults.string(forKey: emailKey)
    }

    func remember(email: String) {
        defaults.set(email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), forKey: emailKey)
    }

    func clear() {
        defaults.removeObject(forKey: emailKey)
    }
}
