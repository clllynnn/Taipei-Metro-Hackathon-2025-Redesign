import SwiftUI

struct AIVoiceGuidanceCard: View {
    let state: AIVoiceGuideState
    let contrastMode: HighContrastMode
    var onToggleGuidance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("AI 語音陪伴")
                .font(.title2.weight(.heavy))
                .foregroundStyle(contrastMode.foregroundColor)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 12) {
                infoRow(icon: "figure.roll", title: "乘車指引", detail: state.currentInstruction)
                Rectangle()
                    .fill(contrastMode.borderColor.opacity(0.55))
                    .frame(height: 1)
                infoRow(icon: "figure.roll.circle", title: "電梯與坡道", detail: state.nearbyElevatorInfo)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(contrastMode.borderColor, lineWidth: 2))

            Button(action: onToggleGuidance) {
                Label(
                    state.isGuiding ? "停止語音導覽" : "播放語音導覽",
                    systemImage: state.isGuiding ? "stop.fill" : "speaker.wave.2.fill"
                )
                .font(.title3.weight(.heavy))
                .frame(maxWidth: .infinity, minHeight: 68)
                .foregroundStyle(contrastMode.backgroundColor)
                .background(contrastMode.foregroundColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(state.isGuiding ? "停止語音導覽" : "播放語音導覽")
            .accessibilityHint(state.isGuiding ? "停止目前的語音提示" : "朗讀乘車指引與附近電梯、坡道資訊")
        }
    }

    private func infoRow(icon: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2.weight(.bold))
                .frame(width: 34, height: 40)
                .foregroundStyle(contrastMode.accentColor)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(contrastMode.foregroundColor)
                Text(detail)
                    .font(.body.weight(.medium))
                    .foregroundStyle(contrastMode.secondaryColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AIVoiceGuidanceCard(
        state: AIVoiceGuideState(
            isGuiding: false,
            currentInstruction: "前方約 20 公尺右轉，搭乘電梯前往月台層。",
            nearbyElevatorInfo: "最近的無障礙電梯位於 1 號出口旁，直行約 35 公尺。"
        ),
        contrastMode: .grayOnBlack,
        onToggleGuidance: {}
    )
    .padding()
    .background(HighContrastMode.grayOnBlack.backgroundColor)
}
