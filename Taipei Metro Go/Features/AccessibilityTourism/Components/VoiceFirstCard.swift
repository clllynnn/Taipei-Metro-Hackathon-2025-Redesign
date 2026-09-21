import SwiftUI

struct VoiceFirstCard: View {
    let isActive: Bool
    let contrastMode: HighContrastMode
    var onAsk: () -> Void

    private let heroYellow = Color(red: 1.0, green: 0.84, blue: 0.0)

    var body: some View {
        VStack(spacing: 10) {
            Button(action: onAsk) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 84, height: 84)
                    .background(heroYellow, in: Circle())
                    .overlay {
                        Circle()
                            .stroke(isActive ? .white : heroYellow, lineWidth: isActive ? 4 : 2)
                            .padding(isActive ? -6 : -2)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("AI 語音詢問")
            .accessibilityValue(isActive ? "正在聆聽" : "待命")
            .accessibilityHint("請說出目的地或詢問無障礙設施")

            Text("請說出目的地或詢問無障礙設施")
                .font(.callout.weight(.semibold))
                .foregroundStyle(contrastMode.foregroundColor)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 132)
        .accessibilityElement(children: .contain)
    }
}
