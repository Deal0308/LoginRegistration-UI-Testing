import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: RegistrationViewModel

    init(authenticationService: AuthenticationService) {
        _viewModel = StateObject(wrappedValue: RegistrationViewModel(authenticationService: authenticationService))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 24) {
                    LogoHeader(
                        title: "Create Account",
                        subtitle: "Register once, then sign in during this app session."
                    )
                    .padding(.top, 18)

                    VStack(spacing: 16) {
                        AppTextField(
                            title: "Username",
                            systemImage: "person.fill",
                            text: $viewModel.username,
                            textContentType: .name,
                            accessibilityIdentifier: "usernameField"
                        )

                        AppTextField(
                            title: "Email",
                            systemImage: "envelope.fill",
                            text: $viewModel.email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            accessibilityIdentifier: "registrationEmailField"
                        )

                        SecureInputField(
                            title: "Password",
                            text: $viewModel.password,
                            accessibilityIdentifier: "registrationPasswordField"
                        )

                        SecureInputField(
                            title: "Confirm Password",
                            text: $viewModel.confirmPassword,
                            accessibilityIdentifier: "confirmPasswordField"
                        )

                        ValidationMessageView(
                            message: viewModel.errorMessage,
                            accessibilityIdentifier: "registrationErrorMessage"
                        )

                        PrimaryButton(
                            title: "Register",
                            systemImage: "checkmark.circle.fill",
                            isLoading: viewModel.isLoading,
                            action: viewModel.register
                        )
                        .accessibilityIdentifier("registerButton")
                    }
                    .padding(22)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                    Button("Back to Login") {
                        dismiss()
                    }
                    .font(.callout.weight(.semibold))
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RegistrationView(authenticationService: AuthenticationService())
    }
}
