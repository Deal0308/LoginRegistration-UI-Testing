//
//  LoginRegistrationApp.swift
//  LoginRegistration
//
//  Created by Michael Deal on 8/7/26.
//

import SwiftUI
import Foundation

@main
struct LoginRegistrationApp: App {
    private let preferences: LoginPreferences

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let isUITesting = arguments.contains("-UITesting") || arguments.contains("-UITesting-Reset")
        let defaults = isUITesting
            ? UserDefaults(suiteName: "com.example.LoginRegistration.UITesting")!
            : UserDefaults.standard
        let preferences = LoginPreferences(defaults: defaults)
        if arguments.contains("-UITesting-Reset") {
            preferences.clear()
        }
        self.preferences = preferences
    }

    var body: some Scene {
        WindowGroup {
            ContentView(preferences: preferences)
        }
    }
}
