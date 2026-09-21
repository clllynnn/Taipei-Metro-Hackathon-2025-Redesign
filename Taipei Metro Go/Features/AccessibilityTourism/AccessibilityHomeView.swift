import SwiftUI

@MainActor
struct AccessibilityHomeView: View {
    @StateObject private var viewModel: AccessibilityHomeViewModel
    private let onReturnToNormalMode: () -> Void
    @State private var isEmergencyStatusPresented = false

    init(onReturnToNormalMode: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AccessibilityHomeViewModel())
        self.onReturnToNormalMode = onReturnToNormalMode
    }

    init(viewModel: AccessibilityHomeViewModel, onReturnToNormalMode: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onReturnToNormalMode = onReturnToNormalMode
    }

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.height < 740
            let sectionSpacing: CGFloat = compact ? 18 : 24
            let verticalPadding: CGFloat = compact ? 10 : 16
            let headerHeight: CGFloat = compact ? 56 : 60

            VStack(spacing: sectionSpacing) {
                AccessibilityHeaderView(
                    contrastMode: viewModel.contrastMode,
                    onReturnToNormalMode: onReturnToNormalMode
                )
                .frame(height: headerHeight)

                AIPassengerCompanionCard(
                    state: viewModel.voiceGuide,
                    guidanceText: viewModel.currentGuidanceText,
                    recognizedSpeechText: viewModel.recognizedSpeechText,
                    isListening: viewModel.isVoiceListening,
                    isNearElevator: viewModel.isNearElevator,
                    compact: compact,
                    contrastMode: viewModel.contrastMode,
                    onAsk: viewModel.activateVoiceAssistant
                )
                .frame(maxHeight: .infinity)
                .layoutPriority(1)

                QuickDestinationsCard(
                    destinations: Array(viewModel.quickDestinations.prefix(2)),
                    compact: compact,
                    contrastMode: viewModel.contrastMode,
                    onSelect: viewModel.planAccessibleRoute
                )

                ReassuranceEmergencyCard(
                    info: viewModel.emergencyInfo,
                    remainingSeconds: viewModel.countdownSeconds,
                    contrastMode: viewModel.contrastMode,
                    onRequest: {
                        viewModel.requestEmergencyHelp()
                        isEmergencyStatusPresented = true
                    },
                    onSpeak: viewModel.speakReassurance
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: 760, maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.18), value: viewModel.contrastMode)
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
        .fullScreenCover(isPresented: $isEmergencyStatusPresented) {
            EmergencyStatusView(
                viewModel: viewModel,
                onCancel: {
                    viewModel.cancelEmergencyHelp()
                    isEmergencyStatusPresented = false
                }
            )
        }
    }
}

#Preview("無障礙陪伴・單頁高對比") {
    AccessibilityHomeView()
}

#Preview("無障礙陪伴・閉環救援") {
    let model = AccessibilityHomeViewModel()
    model.emergencyState = .enRoute
    model.countdownSeconds = 120
    model.emergencyRemainingSeconds = 120
    model.emergencyInfo.status = .staffAssigned
    model.emergencyInfo.staffName = "板南線站務員 王先生"
    model.emergencyInfo.reassuranceMessage = "已定位您在板南線 3 車廂。站務員王先生已出發，預估 02:00 抵達，請原地安心等待。"
    return AccessibilityHomeView(viewModel: model)
}

#Preview("無障礙陪伴・語音聆聽") {
    let model = AccessibilityHomeViewModel()
    model.isVoiceListening = true
    model.isVoiceAssistantActive = true
    model.voiceGuide.isGuiding = true
    model.currentGuidanceText = "我在聆聽。請說出目的地或詢問無障礙設施。"
    return AccessibilityHomeView(viewModel: model)
}

#Preview("無障礙陪伴・靠近電梯") {
    let model = AccessibilityHomeViewModel()
    model.isNearElevator = true
    model.voiceGuide.nearbyElevatorInfo = "已為您按前往月台的電梯"
    return AccessibilityHomeView(viewModel: model)
}
