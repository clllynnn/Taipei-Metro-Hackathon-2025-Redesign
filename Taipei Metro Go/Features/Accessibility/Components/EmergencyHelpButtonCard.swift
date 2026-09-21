import SwiftUI

struct EmergencyHelpButtonCard: View {
    let info: EmergencyHelpInfo
    let contrastMode: HighContrastMode
    var onRequestHelp: () -> Void
    var onSpeakReassurance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("安心緊急協助")
                .font(.title2.weight(.heavy))
                .foregroundStyle(contrastMode.foregroundColor)
                .accessibilityAddTraits(.isHeader)

            if info.status == .idle {
                Button(action: onRequestHelp) {
                    Label("需要緊急協助", systemImage: "cross.case.fill")
                        .font(.title2.weight(.heavy))
                        .frame(maxWidth: .infinity, minHeight: 82)
                        .foregroundStyle(Color.accessibilityEmergencyText)
                        .background(Color.accessibilityEmergencyAccent, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("需要緊急協助")
                .accessibilityHint("通知最近的站務人員前來協助您")

                Text("按下後，站務人員會前往您所在的位置。")
                    .font(.body.weight(.medium))
                    .foregroundStyle(contrastMode.secondaryColor)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                accompanimentPanel
            }
        }
        .animation(.easeInOut(duration: 0.25), value: info)
    }

    private var accompanimentPanel: some View {
        VStack(alignment: .leading, spacing: 13) {
            Label(statusTitle, systemImage: statusSymbol)
                .font(.headline.weight(.heavy))
                .foregroundStyle(contrastMode.foregroundColor)

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(contrastMode.accentColor)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(info.staffName)
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(contrastMode.foregroundColor)
                    Text("預估抵達")
                        .font(.body.weight(.medium))
                        .foregroundStyle(contrastMode.secondaryColor)
                }
                Spacer(minLength: 8)
                Text("\(info.estimatedArrivalMinutes) 分鐘")
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(contrastMode.foregroundColor)
                    .fixedSize()
                    .accessibilityLabel("預估還有 \(info.estimatedArrivalMinutes) 分鐘抵達")
            }

            Text(info.reassuranceMessage)
                .font(.body.weight(.semibold))
                .foregroundStyle(contrastMode.foregroundColor)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .combine)

            Button(action: onSpeakReassurance) {
                Label("播放安心提示", systemImage: "speaker.wave.2.fill")
                    .font(.headline.weight(.heavy))
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .foregroundStyle(contrastMode.backgroundColor)
                    .background(contrastMode.foregroundColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("播放安心提示")
            .accessibilityHint("朗讀站務人員資訊、抵達時間與安心訊息")
        }
        .padding(16)
        .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(contrastMode.borderColor, lineWidth: 2))
        .accessibilityElement(children: .contain)
    }

    private var statusTitle: String {
        switch info.status {
        case .idle: "等待協助"
        case .calling: "正在聯絡站務人員"
        case .staffAssigned: "站務人員已接獲通知"
        case .staffArriving: "站務人員即將抵達"
        }
    }

    private var statusSymbol: String {
        switch info.status {
        case .idle: "checkmark.circle"
        case .calling: "phone.arrow.up.right"
        case .staffAssigned: "person.badge.key.fill"
        case .staffArriving: "figure.walk"
        }
    }
}

#Preview {
    EmergencyHelpButtonCard(
        info: EmergencyHelpInfo(
            status: .staffAssigned,
            staffName: "台北車站站務員 林先生",
            estimatedArrivalMinutes: 4,
            reassuranceMessage: "林先生已收到通知，正前往您所在的位置。請安心留在原地。"
        ),
        contrastMode: .grayOnBlack,
        onRequestHelp: {},
        onSpeakReassurance: {}
    )
    .padding()
    .background(HighContrastMode.grayOnBlack.backgroundColor)
}
