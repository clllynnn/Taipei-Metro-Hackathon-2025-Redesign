import SwiftUI

struct AccessibilityAICompanionSection: View {
    let voiceGuide: AIVoiceGuideState
    let emergencyInfo: EmergencyHelpInfo
    let emergencyRemainingSeconds: Int
    let destinations: [QuickDestination]
    let contrastMode: HighContrastMode
    var isVoiceAssistantActive: Bool
    var onAskAI: () -> Void
    var onToggleGuidance: () -> Void
    var onRequestHelp: () -> Void
    var onSpeakReassurance: () -> Void
    var onSelectDestination: (QuickDestination) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            sectionTitle("AI 語音、陪伴與安心救援", symbol: "waveform.and.mic")
            VoiceFirstCard(isActive: isVoiceAssistantActive, contrastMode: contrastMode, onAsk: onAskAI)
            AIPassengerCompanionCard(state: voiceGuide, contrastMode: contrastMode, onSpeak: onToggleGuidance)
            ReassuranceEmergencyCard(info: emergencyInfo, remainingSeconds: emergencyRemainingSeconds, contrastMode: contrastMode, onRequest: onRequestHelp, onSpeak: onSpeakReassurance)
            QuickDestinationsCard(destinations: destinations, contrastMode: contrastMode, onSelect: onSelectDestination)
        }
        .padding(12)
        .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(contrastMode.borderColor, lineWidth: 2))
    }

    private func sectionTitle(_ title: String, symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .font(.headline.weight(.heavy))
            .foregroundStyle(contrastMode.foregroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .accessibilityAddTraits(.isHeader)
    }
}
