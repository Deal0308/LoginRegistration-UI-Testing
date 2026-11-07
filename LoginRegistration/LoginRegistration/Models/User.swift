import Foundation

// Matches the LoginKit user model used in class.
nonisolated struct User: Hashable, Sendable {
    let email: String
    let name: String
}
