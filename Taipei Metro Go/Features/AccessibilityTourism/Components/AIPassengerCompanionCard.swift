import SwiftUI

/// The single primary interaction surface for voice questions and step-free guidance.
struct AIPassengerCompanionCard: View {
    let state: AIVoiceGuideState
    let guidanceText: String?
    let recognizedSpeechText: String?
    let isListening: Bool
    let isNearElevator: Bool
    let compact: Bool
    let contrastMode: HighContrastMode
    private var onAsk: () -> Void

    init(
        state: AIVoiceGuideState,
        guidanceText: String? = nil,
        recognizedSpeechText: String? = nil,
        isListening: Bool = false,
        isNearElevator: Bool = false,
        compact: Bool = false,
        contrastMode: HighContrastMode,
        onAsk: @escaping () -> Void
    ) {
        self.state = state
        self.guidanceText = guidanceText
        self.recognizedSpeechText = recognizedSpeechText
        self.isListening = isListening
        self.isNearElevator = isNearElevator
        self.compact = compact
        self.contrastMode = contrastMode
        self.onAsk = onAsk
    }

    /// Compatibility initializer for the legacy companion section.
    init(
        state: AIVoiceGuideState,
        guidanceText: String? = nil,
        contrastMode: HighContrastMode,
        onSpeak: @escaping () -> Void
    ) {
        self.init(
            state: state,
            guidanceText: guidanceText,
            recognizedSpeechText: nil,
            isListening: state.isGuiding,
            isNearElevator: false,
            compact: false,
            contrastMode: contrastMode,
            onAsk: onSpeak
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 10 : 12) {
            Text("AI 語音陪伴")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(contrastMode.foregroundColor)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Button(action: onAsk) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: compact ? 42 : 48, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(width: compact ? 96 : 112, height: compact ? 96 : 112)
                        .background(Color(red: 1.0, green: 0.84, blue: 0.0), in: Circle())
                        .overlay {
                            Circle()
                                .stroke(isListening ? .white : .clear, lineWidth: 4)
                                .padding(-6)
                        }
                }
                .buttonStyle(AccessibilityButtonStyle())
                .accessibilityLabel("AI 語音詢問")
                .accessibilityValue(isListening ? "正在聆聽" : "待命")
                .accessibilityHint("請說出目的地或詢問無障礙設施")
                Spacer(minLength: 0)
            }

            Text("辨識語音並轉為文字")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(contrastMode.secondaryColor)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: compact ? 8 : 10) {
                promptRow(
                    symbol: "waveform",
                    title: "語音辨識",
                    text: recognizedSpeechText ?? guidanceText ?? state.currentInstruction,
                    color: contrastMode.foregroundColor
                )
                promptRow(
                    symbol: "figure.roll",
                    title: "電梯提示",
                    text: isNearElevator ? "已為您按前往月台的電梯" : state.nearbyElevatorInfo,
                    color: contrastMode.accentColor
                )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, compact ? 10 : 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(compact ? 14 : 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(white: 0.035), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(contrastMode.accentColor, lineWidth: 2))
        .accessibilityElement(children: .contain)
    }

    private func promptRow(symbol: String, title: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol)
                .font(.body.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color.opacity(0.8))
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
