import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("通知設定")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text("選擇你想收到的捷運資訊")
                    .font(.system(.footnote, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 2)

            VStack(spacing: 0) {
                ForEach(Array(NotificationPreference.allCases.enumerated()), id: \.element.id) { index, preference in
                    Toggle(isOn: binding(for: preference)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(preference.title)
                                .font(.system(.footnote, weight: .semibold))
                                .foregroundStyle(.primary)
                            Text(preference.subtitle)
                                .font(.system(.footnote, weight: .regular))
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .tint(Color.primaryAction)
                    .padding(.vertical, 11)

                    if index < NotificationPreference.allCases.count - 1 {
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 15)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func binding(for preference: NotificationPreference) -> Binding<Bool> {
        Binding(
            get: { viewModel.isNotificationEnabled(preference) },
            set: { viewModel.toggleNotificationSetting(preference, isOn: $0) }
        )
    }
}

#Preview {
    NotificationSettingsView(viewModel: AccountViewModel()).padding().background(Color.pageBackground)
}
