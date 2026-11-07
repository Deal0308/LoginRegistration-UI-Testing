import SwiftUI

struct LogoHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.16))
                    .frame(width: 86, height: 86)

                Image(systemName: "person.badge.key.fill")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text(title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
