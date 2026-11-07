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
    private let sessionStore: SessionStore

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let isUITesting = arguments.contains("-UITesting") || arguments.contains("-UITesting-Reset")
        let defaults = isUITesting
            ? UserDefaults(suiteName: "com.example.LoginRegistration.UITesting")!
            : UserDefaults.standard
        let sessionStore = SessionStore(defaults: defaults)
        if arguments.contains("-UITesting-Reset") {
            sessionStore.clear()
        }
        self.sessionStore = sessionStore
    }

    var body: some Scene {
        WindowGroup {
            ContentView(sessionStore: sessionStore)
        }
    }
}
