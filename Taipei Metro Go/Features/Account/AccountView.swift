import SwiftUI

@MainActor
struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    @State private var activeDestination: AccountDestination?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 21) {
                ProfileHeaderCard(
                    profile: viewModel.userProfile,
                    onEditProfile: { activeDestination = .profile },
                    onAccountSecurity: { activeDestination = .security }
                )

                if !viewModel.didLogout {
                    MemberBenefitsOverview(viewModel: viewModel)

                    RidingAnalyticsSection(
                        viewModel: viewModel,
                        onOpenAllRides: { activeDestination = .rideHistory }
                    )
                }
                NotificationSettingsView(viewModel: viewModel)
                AccountSecuritySection(viewModel: viewModel)
            }
            .padding(.horizontal, 17)
            .padding(.top, 12)
            .padding(.bottom, 30)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .sheet(item: $activeDestination) { destination in
            AccountDestinationSheet(destination: destination, viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .alert("確定要登出？", isPresented: $viewModel.showLogoutAlert) {
            Button("取消", role: .cancel) {}
            Button("確定登出", role: .destructive) {
                viewModel.performLogout()
            }
        } message: {
            Text("登出後將停止同步此會員帳戶的乘車紀錄與回饋資料。")
        }
    }

}

private enum AccountDestination: String, Identifiable {
    case profile
    case security
    case rideHistory

    var id: String { rawValue }

    var title: String {
        switch self {
        case .profile: "個人資料"
        case .security: "帳號安全"
        case .rideHistory: "乘車紀錄"
        }
    }
}

private struct AccountDestinationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let destination: AccountDestination
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        NavigationStack {
            List {
                switch destination {
                case .profile:
                    Section("個人資料") {
                        LabeledContent("姓名", value: viewModel.userProfile.name)
                        if !viewModel.userProfile.accountID.isEmpty {
                            LabeledContent("帳號", value: viewModel.userProfile.accountID)
                        }
                    }
                    Section {
                        Text("個人資料編輯服務將在登入會員帳戶後提供。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                case .security:
                    Section("登入與安全") {
                        Label("會員密碼", systemImage: "key.horizontal")
                        Label("Face ID 與裝置驗證", systemImage: "faceid")
                        Label("已登入裝置", systemImage: "iphone.gen3")
                    }
                    Section {
                        Text("帳號安全設定會與會員登入服務同步。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                case .rideHistory:
                    Section("最近搭乘") {
                        ForEach(viewModel.recentRideRecords) { record in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("\(record.inStation) → \(record.outStation)")
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Text("−NT$\(record.amount)")
                                        .font(.subheadline.weight(.medium).monospacedDigit())
                                }
                                HStack(spacing: 6) {
                                    Circle().fill(Color(accountHex: record.lineColorHex)).frame(width: 7, height: 7)
                                    Text(record.lineName)
                                    Text("·")
                                    Text(record.timestamp.accountTimestampText)
                                }
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                }
            }
            .navigationTitle(destination.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AccountView()
}

#Preview("會員中心・最大輔助使用字級") {
    AccountView()
        .environment(\.dynamicTypeSize, .accessibility5)
}
