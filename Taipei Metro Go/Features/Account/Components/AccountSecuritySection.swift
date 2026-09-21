import SwiftUI

struct AccountSecuritySection: View {
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        Button {
            viewModel.showLogoutAlert = true
        } label: {
            Label("登出", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AccountSecuritySection(viewModel: AccountViewModel())
        .padding()
        .background(Color.pageBackground)
}
