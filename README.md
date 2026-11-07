# LoginRegistration UI Testing Assignment

SwiftUI login and registration app using MVVM, XCTest, XCUITest Page Objects, and GitHub Actions.

- Public repository: https://github.com/Deal0308/LoginRegistration-UI-Testing
- Course: MDI1 117, iOS Automated Testing, Chapter 10
- Assignment: Class 4 UI Testing with XCUITest and CI Integration

## Open and run

Open `LoginRegistration/LoginRegistration.xcodeproj`, select the shared **LoginRegistration** scheme and an available iPhone simulator, then press **Command-U**. The scheme runs all 14 unit tests and 8 UI tests serially.

Demo login: `student@test.com` / `Student123`. These are sample credentials for the local, in-memory service. Registration lasts for the current app session. Remember Me stores only the email, never the password or a logged-in session.

## MVVM structure

- `Models/User.swift`: account model.
- `Services/AuthenticationService.swift`: in-memory authentication.
- `Services/LoginPreferences.swift`: injectable email preferences.
- `ViewModels/`: login and registration state and validation.
- `Views/`: login, registration, dashboard, and reusable controls.
- `LoginRegistrationUITests/PageObjects/`: `LoginScreen`, `DashboardScreen`, and `RegistrationScreen` centralize UI interactions and accessibility identifiers.

## UI coverage

| Test | Expected behavior |
| --- | --- |
| Invalid login | `error_label` appears and dashboard remains absent |
| Successful login | Dashboard appears |
| Logout | Returns to login; named activities and a kept screenshot attachment |
| Remembered email | Email survives termination and relaunch |
| Remember Me off | Saved email is removed and remains absent after relaunch |
| Password correction | Correct only the password after failure, then log in |
| Registration | Register, reach dashboard, and log out |
| Launch smoke | Login controls appear; screenshot attachment retained |

Each test initially launches with `-UITesting` and `-UITesting-Reset`. Test preferences use a dedicated UserDefaults suite. Persistence checks terminate and relaunch with only `-UITesting`, preserving the saved email within the test. There are no fixed sleeps or test-order dependencies.

## Class workflow

The instructor's original file was retrieved from the repository linked by the Canvas Class 4 slides:

https://github.com/Andres-SDGKU/MDI1-117-Ch10-LoginKit/blob/e6dac8585a21c69d78c481571dba8d029fd5cfd9/.github/workflows/ios-ci.yml

`.github/workflows/ios-ci.yml` is at this repository's root, beside the `LoginRegistration` project folder. Only the two project-dependent lines were changed:

```text
-project LoginRegistration/LoginRegistration.xcodeproj
-scheme "LoginRegistration"
```

The shared scheme is committed. The class workflow requests the `xcode-27` runner label and `/Applications/Xcode_27.0.app/Contents/Developer`. It triggers on pushes and pull requests to `main`, and supports manual dispatch. Actual CI status is available in the repository's Actions tab.

## Local validation

The initial complete local run passed all 22 tests: 14 unit tests and 8 UI tests, with zero failures. Evidence and the report are saved in the assignment delivery folder.
