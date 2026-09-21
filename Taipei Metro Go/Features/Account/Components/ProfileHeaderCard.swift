import SwiftUI

struct ProfileHeaderCard: View {
    let profile: AccountUserProfile
    let onEditProfile: () -> Void
    let onAccountSecurity: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            Text("會員資訊")
                .font(.system(.title3, design: .rounded, weight: .bold))

            HStack(spacing: 14) {
                Circle()
                    .fill(Color.softSurface)
                    .frame(width: 62, height: 62)
                    .overlay {
                        Image(systemName: profile.avatarSystemName)
                            .font(.system(size: 31, weight: .regular))
                            .foregroundStyle(Color.primaryAction)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(profile.name)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    if !profile.accountID.isEmpty {
                        Text(profile.accountID)
                            .font(.system(.footnote, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("登入以同步乘車紀錄與會員回饋")
                            .font(.system(.footnote))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 10) {
                Button(action: onEditProfile) {
                    Label("個人資料", systemImage: "person.text.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AccountOutlineButtonStyle())

                Button(action: onAccountSecurity) {
                    Label("帳號安全", systemImage: "lock.shield")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AccountOutlineButtonStyle())
            }
        }
        .accountCardStyle()
    }
}

private struct AccountOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(Color.primaryAction)
            .padding(.vertical, 10)
            .background(Color.softSurface.opacity(configuration.isPressed ? 0.55 : 0.8), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview {
    ProfileHeaderCard(profile: AccountUserProfile(name: "林怡君", accountID: "帳號 08•• ••42", avatarSystemName: "person.crop.circle.fill"), onEditProfile: {}, onAccountSecurity: {})
        .padding()
        .background(Color.pageBackground)
}
