# LoginRegistration

A polished SwiftUI Login & Registration app built with MVVM, reusable components, in-memory authentication, validation, unit tests, UI tests, and accessibility identifiers for automation.

## Project Overview

LoginRegistration demonstrates a complete authentication flow for a college iOS assignment. The app includes login, registration, home, logout, validation feedback, default credentials, and a professional SwiftUI interface that supports Light Mode and Dark Mode.

## Architecture

The project follows MVVM:

- Models define app data.
- Services own authentication state and user storage.
- Utilities provide reusable validation rules.
- ViewModels contain business logic and validation decisions.
- Views render state and forward user actions.
- Components provide reusable SwiftUI controls.

## Folder Structure

```text
LoginRegistration
├── Models
│   └── User.swift
├── Services
│   └── AuthenticationService.swift
├── Utilities
│   └── ValidationManager.swift
├── ViewModels
│   ├── LoginViewModel.swift
│   └── RegistrationViewModel.swift
├── Views
│   ├── LoginView.swift
│   ├── RegistrationView.swift
│   ├── HomeView.swift
│   └── Components
│       ├── PrimaryButton.swift
│       ├── AppTextField.swift
│       ├── SecureInputField.swift
│       ├── ValidationMessageView.swift
│       ├── AppBackground.swift
│       └── LogoHeader.swift
├── Assets.xcassets
└── ContentView.swift
```

## Technologies

- Swift
- SwiftUI
- MVVM
- XCTest
- XCUIAutomation
- SF Symbols
- NavigationStack
- Dynamic Light/Dark Mode colors

## Features

- Login with default credentials
- Register a new user during the same app session
- Logout from the home screen
- In-memory authentication service
- Reusable text fields, secure fields, buttons, headers, background, and validation message views
- Validation messages for invalid input
- Loading state support in primary buttons
- Accessibility identifiers for UI testing
- Modern gradient background, material cards, rounded corners, shadows, and animations

## Validation Rules

- Email cannot be empty.
- Email must use a valid email format.
- Password must be at least 8 characters.
- Password must include at least 1 number.
- Confirm password must match password.
- Username cannot be empty.

## Default Credentials

```text
Username: Student
Email: student@test.com
Password: Student123
```

## Unit Tests

The unit test target uses `@testable import LoginRegistration` and includes:

- `testInvalidEmailReturnsFalse()`
- `testValidEmailReturnsTrue()`
- `testPasswordWithoutNumberReturnsFalse()`
- `testValidPasswordReturnsTrue()`
- `testEmptyLoginShowsError()`
- `testPasswordMismatchReturnsError()`
- `testSuccessfulLogin()`
- `testIncorrectPasswordFailsLogin()`
- `testSuccessfulRegistration()`
- `testEmptyUsernameFailsRegistration()`

## UI Tests

Eight UI tests use `LoginScreen`, `DashboardScreen`, and `RegistrationScreen` Page Objects. They cover login success and failure, logout, remembered email across relaunch, clearing Remember Me, correcting only a failed password, registration, and launch. The logout test includes named activities and a screenshot attachment.

All tests initially launch with `-UITesting-Reset`. Persistence checks retain the separate `-UITesting` launch argument while dropping Reset on relaunch. Remember Me stores only the email in injectable preferences.

## Accessibility Identifiers

```text
emailField
passwordField
rememberMeToggle
loginButton
error_label
registrationNavigationButton
usernameField
registrationEmailField
registrationPasswordField
confirmPasswordField
registerButton
registrationErrorMessage
welcome_label
logoutButton
```

## Running the App

1. Open `LoginRegistration.xcodeproj` in Xcode.
2. Select the `LoginRegistration` scheme.
3. Choose an iPhone simulator such as iPhone 16, iPhone 16 Pro, or iPhone 16 Pro Max.
4. Press Command-R.

## Running Unit Tests

1. Open the Test navigator in Xcode.
2. Run the `LoginRegistrationTests` target.

You can also select an individual unit test and press the test diamond next to it.

## Running UI Tests

1. Select an iPhone simulator.
2. Open the Test navigator in Xcode.
3. Run the `LoginRegistrationUITests` target.

The simulator should remain unlocked and active while UI tests run.

## Notes

The app uses an in-memory authentication service, so registered users remain available only during the current app session. Remembered email persists when enabled; passwords and authentication sessions are never saved.
