import SwiftUI

struct ReassuranceEmergencyCard: View {
    let info: EmergencyHelpInfo
    let remainingSeconds: Int
    let contrastMode: HighContrastMode
    var onRequest: () -> Void
    var onSpeak: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("安心緊急呼叫")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(contrastMode.accentColor)
                .accessibilityAddTraits(.isHeader)
            if info.status == .idle {
                Button(action: onRequest) {
                    Label("一鍵通報站務人員", systemImage: "bell.and.waves.left.and.right.fill")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .foregroundStyle(.black)
                        .background(contrastMode.accentColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(AccessibilityButtonStyle())
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text("已通報行控中心，\(info.staffName)已出發")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(contrastMode.foregroundColor)
                        .lineSpacing(6)
                    HStack {
                        Text("預計抵達").font(.system(size: 18, weight: .medium)).foregroundStyle(contrastMode.secondaryColor)
                        Spacer()
                        Text(String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60))
                            .font(.system(size: 25, weight: .heavy, design: .rounded).monospacedDigit())
                            .foregroundStyle(contrastMode.accentColor)
                    }
                    Text(info.reassuranceMessage)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(contrastMode.secondaryColor)
                        .lineLimit(2)
                        .lineSpacing(6)
                    Button(action: onSpeak) {
                        Label("播報安心訊息", systemImage: "speaker.wave.2.fill")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .foregroundStyle(contrastMode.backgroundColor)
                            .background(contrastMode.foregroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(AccessibilityButtonStyle())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
