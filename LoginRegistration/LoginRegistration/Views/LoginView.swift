import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    private let authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService, preferences: LoginPreferences = LoginPreferences()) {
        self.authenticationService = authenticationService
        _viewModel = StateObject(wrappedValue: LoginViewModel(authenticationService: authenticationService, preferences: preferences))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 28) {
                        LogoHeader(
                            title: "Welcome Back",
                            subtitle: "Sign in to continue to your student account."
                        )
                        .padding(.top, 36)

                        VStack(spacing: 16) {
                            AppTextField(
                                title: "Email",
                                systemImage: "envelope.fill",
                                text: $viewModel.email,
                                keyboardType: .emailAddress,
                                textContentType: .username,
                                accessibilityIdentifier: "emailField"
                            )

                            SecureInputField(
                                title: "Password",
                                text: $viewModel.password,
                                accessibilityIdentifier: "passwordField"
                            )

                            Toggle("Remember Me", isOn: $viewModel.rememberMe)
                                .accessibilityIdentifier("rememberMeToggle")

                            Text("Forgot password?")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            ValidationMessageView(
                                message: viewModel.errorMessage,
                                accessibilityIdentifier: "error_label"
                            )

                            PrimaryButton(
                                title: "Log In",
                                systemImage: "arrow.right.circle.fill",
                                isLoading: viewModel.isLoading,
                                action: viewModel.login
                            )
                            .accessibilityIdentifier("loginButton")
                        }
                        .padding(22)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                        NavigationLink {
                            RegistrationView(authenticationService: authenticationService)
                        } label: {
                            Text("Create a new account")
                                .font(.callout.weight(.semibold))
                        }
                        .accessibilityIdentifier("registrationNavigationButton")
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 32)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginView(authenticationService: AuthenticationService())
}
