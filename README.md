# LoginKit Class Project with Personal Touches

This MVVM SwiftUI app follows Professor Andres de la Cruz's LoginKit login architecture and behavior, while retaining Michael Deal's gradient design, material cards, SF Symbols, password visibility control, and registration feature.

Class source: [Andres-SDGKU/MDI1-117-Ch10-LoginKit](https://github.com/Andres-SDGKU/MDI1-117-Ch10-LoginKit/tree/048f91866ec423d74184990bc911c9e02070f769). The comparison is pinned to commit `048f91866ec423d74184990bc911c9e02070f769` on the professor's main branch.

Student repository: https://github.com/Deal0308/LoginRegistration-UI-Testing

## Run the app and tests

Open `LoginRegistration/LoginRegistration.xcodeproj`, select the shared **LoginRegistration** scheme and an available iPhone simulator, then press **Command-R** to run or **Command-U** to test. **Command-6** opens the Test navigator.

The class demo account is:

```text
Email: test@mail.com
Password: test1234
Dashboard: Welcome, Example
```

These are demonstration credentials for the local service. Remember Me saves only the email, never the password or an authenticated session. Registered accounts are available only during the current app session.

## What matches the professor's code

| Part | Class behavior retained |
| --- | --- |
| `User` | Hashable model containing `email` and `name` |
| `AuthServiceProtocol` | `login(email:password:) async throws -> User` |
| `AuthService` | Class demo credentials, 400 ms simulated request, `AuthError.invalidCredentials` |
| Error text | `Invalid email or password` |
| `SessionStoring` / `SessionStore` | Read/write `rememberedEmail`, `clear()`, injectable UserDefaults, and the `rememberedEmail` storage key |
| `LoginViewModel` | Injected services, async login, loading state, optional error, and `loggedInUser` |
| Logout | Clears the user and password; keeps the email only when Remember Me is on |
| Navigation | NavigationStack and `navigationDestination(item: $viewModel.loggedInUser)` with `DashboardView` |
| Accessibility | `email_field`, `password_field`, `remember_me_toggle`, `login_button`, `loading_indicator`, `error_label`, `welcome_label`, `logout_button` |
| UI reset | Initial launch with `-UITesting-Reset` clears the saved email |

The app retains its `LoginRegistration` Xcode project and scheme names so existing submission links and the class workflow project path remain valid.

## Personal additions

- Gradient background, material cards, icons, and password visibility control.
- Registration is an extension through `RegistrationServicing`; it does not change the class login protocol.
- Turning Remember Me off immediately clears saved email, completing assignment exercise 5.
- Keyboard focus and an accessible Done button keep login usable with the software keyboard.
- UI tests use a dedicated preferences suite so resetting a test does not affect normal app preferences.
- Protocols explicitly use the main actor for this SwiftUI app.

## Test coverage

The shared scheme includes 28 unit tests and 8 UI tests (36 total). Unit coverage includes the class credentials and error, injected authentication, the exact session key, both logout modes, registration, validation, and Remember Me.

`LoginScreen`, `DashboardScreen`, and `RegistrationScreen` Page Objects centralize UI interactions. The UI suite covers invalid and successful login, logout, remembered email after relaunch, turning Remember Me off, correcting only a wrong password, registration, and launch. The logout test uses named activities and a screenshot attachment. Login, dashboard, and error screenshots are also retained as test attachments.

Each independent test initially launches with `-UITesting` and `-UITesting-Reset`. Persistence checks remove only Reset before relaunch. Page Objects dismiss the software keyboard with the app's Done control before tapping Log In. There are no fixed sleeps in UI tests.

The professor's main branch has generated starter test placeholders. This project implements the exercise requirements instead of copying those placeholders.

## Class workflow

The original instructor workflow came from the [class repository](https://github.com/Andres-SDGKU/MDI1-117-Ch10-LoginKit/blob/e6dac8585a21c69d78c481571dba8d029fd5cfd9/.github/workflows/ios-ci.yml). It is saved at `.github/workflows/ios-ci.yml`, beside the project folder. Only these two project-dependent lines differ:

```text
-project LoginRegistration/LoginRegistration.xcodeproj
-scheme "LoginRegistration"
```

The pipeline runs on pushes and pull requests to main, supports manual dispatch, and uploads the `.xcresult` test bundle. Actual run results are recorded in the Actions tab and the assignment report.

## Attribution

The login model, service interfaces, session storage, async view-model flow, navigation pattern, identifiers, and sample account are adapted from Andres de la Cruz's course LoginKit project. The source comments mark these adaptations. The styling, registration extension, completed tests, and assignment documentation are Michael Deal's personalized version with AI assistance disclosed in the report.

## Swift 6 logic safeguards

The app and test targets use Swift 6 language mode with complete concurrency checking. Immutable User values are Sendable; UI state and service mutation are main-actor isolated. Login rejects duplicate requests, checks cancellation after suspension, and ignores responses invalidated by logout. The view ties login work to its lifetime using SwiftUI task(id:). Input and navigation controls are disabled while a request is pending.

Email normalization and validation are shared between login and registration; registration also validates at the service boundary. UserDefaults persists automatically without synchronize(). Eight regression tests were run failing before these fixes and passing afterward, covering cancellation, overlapping requests, late replies after logout, remembered email consistency, malformed addresses, normalized class credentials, and invalid registration.

The UI tests assert the resulting error or dashboard instead of requiring UIKit to remove an offscreen keyboard accessibility object. The cloud video demonstrated that the keyboard could be visually dismissed while that object remained in the tree.

References: [Swift concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html), [Task cancellation](https://developer.apple.com/documentation/swift/task), [UserDefaults persistence](https://developer.apple.com/documentation/foundation/userdefaults/synchronize()).
