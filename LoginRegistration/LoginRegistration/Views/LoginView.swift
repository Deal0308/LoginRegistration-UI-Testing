import SwiftUI

@MainActor
struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    private enum Field: Hashable { case email, password }
    @FocusState private var focusedField: Field?
    @State private var isPasswordVisible = false
    @State private var isRegistering = false
    @State private var loginRequestID: UUID?
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
                            emailInput.disabled(isSubmitting)
                            passwordInput.disabled(isSubmitting)

                            Toggle("Remember Me", isOn: $viewModel.rememberMe)
                                .accessibilityIdentifier("remember_me_toggle")
                                .disabled(isSubmitting)

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
                                isLoading: isSubmitting,
                                action: requestLogin
                            )
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
                                .disabled(isSubmitting)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 32)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .task(id: loginRequestID) {
                guard let requestID = loginRequestID else { return }
                await viewModel.login()
                if loginRequestID == requestID { loginRequestID = nil }
            }
            .onDisappear { loginRequestID = nil }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if focusedField != nil {
                    HStack {
                        Spacer()
                        Button("Done") { focusedField = nil }
                            .fontWeight(.semibold)
                            .accessibilityIdentifier("dismiss_keyboard_button")
                    }
                    .padding(.horizontal, 22)
                    .frame(height: 44)
                    .background(.regularMaterial)
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

    private var isSubmitting: Bool { loginRequestID != nil || viewModel.isLoading }

    private func requestLogin() {
        guard !isSubmitting else { return }
        focusedField = nil
        loginRequestID = UUID()
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
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
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
                        .focused($focusedField, equals: .password)
                } else {
                    SecureField("Password", text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .onSubmit(requestLogin)
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
