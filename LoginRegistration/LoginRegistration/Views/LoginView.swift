import SwiftUI

@MainActor
struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    private enum Field: Hashable { case email, password }
    @FocusState private var focusedField: Field?
    @State private var isPasswordVisible = false
    @State private var isRegistering = false
    private let registrationService: RegistrationServicing?

    init(authService: AuthServiceProtocol? = nil, sessionStore: SessionStoring? = nil) {
        let authService = authService ?? AuthService()
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService, sessionStore: sessionStore))
        registrationService = authService as? RegistrationServicing
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(spacing: 28) {
                        LogoHeader(
                            title: "LoginKit",
                            subtitle: "Sign in to continue to your student account."
                        )
                        .padding(.top, 36)

                        VStack(spacing: 16) {
                            emailInput
                            passwordInput

                            Toggle("Remember Me", isOn: $viewModel.rememberMe)
                                .accessibilityIdentifier("remember_me_toggle")

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.footnote.weight(.medium))
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityIdentifier("error_label")
                            }

                            PrimaryButton(
                                title: "Log In",
                                systemImage: "arrow.right.circle.fill",
                                isLoading: viewModel.isLoading
                            ) {
                                focusedField = nil
                                Task { await viewModel.login() }
                            }
                            .accessibilityIdentifier("login_button")
                        }
                        .padding(22)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                        if registrationService != nil {
                            Button("Create a new account") { isRegistering = true }
                                .font(.callout.weight(.semibold))
                                .accessibilityIdentifier("registrationNavigationButton")
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 32)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                        .accessibilityIdentifier("dismiss_keyboard_button")
                }
            }
            .navigationDestination(item: $viewModel.loggedInUser) { user in
                DashboardView(user: user, onLogout: { viewModel.logout() })
            }
            .sheet(isPresented: $isRegistering) {
                if let registrationService {
                    NavigationStack {
                        RegistrationView(registrationService: registrationService) { user in
                            isRegistering = false
                            viewModel.completeRegistration(with: user)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var emailInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "envelope.fill").foregroundStyle(.secondary).frame(width: 22)
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .accessibilityIdentifier("email_field")
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var passwordInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill").foregroundStyle(.secondary).frame(width: 22)
            Group {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                } else {
                    SecureField("Password", text: $viewModel.password)
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focusedField, equals: .password)
            .accessibilityIdentifier("password_field")

            Button { isPasswordVisible.toggle() } label: {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
            }
            .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
            .accessibilityIdentifier("passwordVisibilityButton")
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    LoginView()
}
