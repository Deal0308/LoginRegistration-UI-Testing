import SwiftUI

struct DashboardView: View {
    let user: User
    let onLogout: () -> Void
    @State private var iconScale = 0.72

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 28) {
                Spacer(minLength: 24)

                VStack(spacing: 18) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 76, weight: .semibold))
                        .foregroundStyle(.green)
                        .scaleEffect(iconScale)
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.62)) {
                                iconScale = 1.0
                            }
                        }
                        .accessibilityLabel("Successful login")

                    Text("Welcome, \(user.name)")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("welcome_label")

                    VStack(spacing: 8) {
                        Text(user.name)
                            .font(.title3.weight(.semibold))
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .padding(26)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                Button(action: onLogout) {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityIdentifier("logout_button")

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 22)
        }
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DashboardView(user: User(email: "test@mail.com", name: "Example"), onLogout: {})
}
