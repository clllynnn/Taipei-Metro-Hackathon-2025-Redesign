import SwiftUI

struct AssistanceModal: View {
    let language: TourismLanguage
    @Binding var isActive: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: isActive ? "checkmark.shield.fill" : "person.crop.circle.badge.exclamationmark")
                    .font(.system(size: 52))
                    .foregroundStyle(isActive ? Color.statusSuccess : Color.primaryAction)
                Text(isActive ? "站務人員已收到通報" : "需要站務人員協助嗎？")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                Text(isActive ? "台北車站站務員將在電梯大廳與你會合。預估 4 分鐘。" : "我們會將你的所在位置與無障礙需求通知最近的站務人員。")
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
                    .multilineTextAlignment(.center)
                Button(isActive ? "取消通報" : "立即通報站務人員") { isActive.toggle() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .navigationTitle(TourismHomeCopy.text(.assistance, language: language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
