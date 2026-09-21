import AVFoundation
import Combine
import Foundation

enum AccessibilityEmergencyState: String, CaseIterable, Identifiable {
    case idle
    case notified
    case enRoute

    var id: Self { self }
}

@MainActor
final class AccessibilityHomeViewModel: ObservableObject {
    @Published var contrastMode: HighContrastMode = .grayOnBlack
    @Published var isVoiceListening = false
    @Published var isNearElevator = false
    @Published var recognizedSpeechText = "尚未辨識語音"
    @Published var currentGuidanceText = "前方 15 公尺右轉，3 號電梯就在右側。"
    @Published var emergencyState: AccessibilityEmergencyState = .idle
    @Published var countdownSeconds = 0
    @Published var emergencyLocation = "板南線 台北車站 3 號月台 (車廂 3-2)"
    @Published var quickDestinations: [QuickDestination] = [
        QuickDestination(
            id: "home",
            title: "回家",
            iconName: "house.fill",
            targetStation: "大安站",
            addressNote: "信義路三段附近"
        ),
        QuickDestination(
            id: "hospital",
            title: "台大醫院",
            iconName: "cross.case.fill",
            targetStation: "台大醫院站",
            addressNote: "中山南路 7 號"
        ),
        QuickDestination(
            id: "daughter",
            title: "女兒家",
            iconName: "person.fill",
            targetStation: "永春站",
            addressNote: "松山路附近"
        )
    ]
    @Published var voiceGuide = AIVoiceGuideState(
        isGuiding: false,
        currentInstruction: "前方約 20 公尺右轉，搭乘電梯前往月台層。抵達月台後，請在黃色導盲磚旁等候列車。",
        nearbyElevatorInfo: "電梯目前正常運作。靠近電梯後會自動為您按下前往月台。"
    )
    @Published var emergencyInfo = EmergencyHelpInfo(
        status: .idle,
        staffName: "台北車站站務員",
        estimatedArrivalMinutes: 2,
        reassuranceMessage: "按下緊急協助後，站務人員會前往您所在的位置。請先停在安全、方便辨識的地方。"
    )
    @Published var selectedDestination: QuickDestination?
    @Published var routePlanningMessage: String?
    @Published var isVoiceAssistantActive = false
    @Published var emergencyRemainingSeconds = 0

    private let speechSynthesizer = AVSpeechSynthesizer()
    private var emergencyTask: Task<Void, Never>?

    func cycleContrastMode() {
        contrastMode = contrastMode.next
    }

    func planAccessibleRoute(to destination: QuickDestination) {
        selectedDestination = destination
        recognizedSpeechText = "已辨識：前往\(destination.title)"
        routePlanningMessage = "已為您規劃前往\(destination.title)（\(destination.targetStation)）的無障礙路線。"
        currentGuidanceText = "已選擇\(destination.title)。前往\(destination.targetStation)的路線會優先使用電梯與無障礙通道。"
        voiceGuide.currentInstruction = currentGuidanceText
        speak(routePlanningMessage ?? voiceGuide.currentInstruction)
    }

    func toggleVoiceGuide() {
        if voiceGuide.isGuiding {
            voiceGuide.isGuiding = false
            isVoiceListening = false
            speechSynthesizer.stopSpeaking(at: .immediate)
        } else {
            voiceGuide.isGuiding = true
            isVoiceListening = true
            recognizedSpeechText = "正在辨識語音，請說出目的地或設施。"
            currentGuidanceText = voiceGuide.currentInstruction
            speak("\(currentGuidanceText)\(voiceGuide.nearbyElevatorInfo)")
        }
    }

    func activateVoiceAssistant() {
        isVoiceAssistantActive.toggle()
        isVoiceListening = isVoiceAssistantActive
        if isVoiceAssistantActive {
            recognizedSpeechText = "我在聆聽，請說出目的地或詢問無障礙設施。"
            currentGuidanceText = recognizedSpeechText
            voiceGuide.currentInstruction = currentGuidanceText
            let elevatorPrompt = isNearElevator
                ? "已為您按前往月台的電梯。"
                : voiceGuide.nearbyElevatorInfo
            speak("\(currentGuidanceText)\(elevatorPrompt)")
        } else {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Mock the proximity event that would normally come from station positioning.
    /// The card can therefore preview both the normal and the auto-pressed states.
    func updateElevatorProximity(isNear: Bool) {
        isNearElevator = isNear
        voiceGuide.nearbyElevatorInfo = isNear
            ? "已為您按前往月台的電梯"
            : "電梯目前正常運作。靠近電梯後會自動為您按下前往月台。"
        if isNear {
            speak("已為您按前往月台的電梯")
        }
    }

    func requestEmergencyHelp() {
        guard emergencyState == .idle else { return }

        emergencyState = .notified
        emergencyInfo.status = .staffAssigned
        countdownSeconds = max(60, emergencyInfo.estimatedArrivalMinutes * 60 - 2)
        emergencyRemainingSeconds = countdownSeconds
        emergencyInfo.staffName = "板南線站務員 王先生"
        emergencyInfo.reassuranceMessage = "已定位您在板南線 3 車廂。站務員王先生已出發，預估 01:58 內抵達，請原地安心等待。"
        speak(emergencyInfo.reassuranceMessage)

        emergencyTask?.cancel()
        emergencyTask = Task { [weak self] in
            guard let self else { return }
            var elapsed = 0
            while !Task.isCancelled && self.countdownSeconds > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                elapsed += 1
                self.countdownSeconds = max(0, self.countdownSeconds - 1)
                self.emergencyRemainingSeconds = self.countdownSeconds
                if elapsed == 1 {
                    self.emergencyState = .enRoute
                    self.emergencyInfo.status = .staffAssigned
                    self.emergencyInfo.staffName = "板南線站務員 王先生"
                    self.emergencyInfo.reassuranceMessage = "已定位您在板南線 3 車廂。王先生已出發，請安心留在原地等候。"
                } else if self.countdownSeconds <= 60 {
                    self.emergencyInfo.status = .staffArriving
                    self.emergencyInfo.reassuranceMessage = "王先生即將抵達，請留意身穿捷運制服的站務人員。您目前很安全。"
                }
                self.emergencyInfo.estimatedArrivalMinutes = max(1, Int(ceil(Double(self.countdownSeconds) / 60.0)))
            }
        }
    }

    func cancelEmergencyHelp() {
        emergencyTask?.cancel()
        emergencyTask = nil
        emergencyState = .idle
        countdownSeconds = 0
        emergencyRemainingSeconds = 0
        emergencyInfo.status = .idle
        emergencyInfo.reassuranceMessage = "通報已取消。如仍需要協助，請再次按下通報按鈕。"
    }

    func speakReassurance() {
        speak(emergencyInfo.reassuranceMessage)
    }

    private func speak(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        utterance.rate = 0.46
        speechSynthesizer.speak(utterance)
    }
}
