import SwiftUI

@MainActor
struct EmergencyStatusView: View {
    @ObservedObject var viewModel: AccessibilityHomeViewModel
    let onCancel: () -> Void
    @State private var isPulsing = false

    private let reassuranceYellow = Color(red: 1.0, green: 0.84, blue: 0.0)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("安心通報狀態")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)

                Spacer(minLength: 4)

                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 68, weight: .bold))
                    .foregroundStyle(reassuranceYellow)
                    .frame(width: 112, height: 112)
                    .background(Color.green.opacity(0.22), in: Circle())
                    .overlay(Circle().stroke(reassuranceYellow, lineWidth: 3))
                    .scaleEffect(isPulsing ? 1.04 : 0.96)
                    .animation(
                        .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: isPulsing
                    )

                Text("已成功通報行控中心")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text("請於原地安心等待")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))

                VStack(alignment: .leading, spacing: 12) {
                    statusRow(title: "目前定位", value: "📍 \(viewModel.emergencyLocation)")
                    statusRow(title: "站務支援", value: "\(viewModel.emergencyInfo.staffName) 已出發")
                    HStack {
                        Text("抵達倒數")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.85))
                        Spacer()
                        Text(countdownText)
                            .font(.title.weight(.bold).monospacedDigit())
                            .foregroundStyle(reassuranceYellow)
                        Text("內抵達")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    Text("請留在原地，我們會持續陪伴您。")
                        .font(.body)
                        .foregroundStyle(.white)
                        .lineSpacing(6)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(reassuranceYellow, lineWidth: 2))

                Spacer(minLength: 4)

                VStack(spacing: 10) {
                    Button(action: viewModel.speakReassurance) {
                        Label("語音播報現況", systemImage: "speaker.wave.2.fill")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .foregroundStyle(.black)
                            .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    Button(action: onCancel) {
                        Label("取消通報／誤觸", systemImage: "xmark.circle")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .foregroundStyle(reassuranceYellow)
                            .background(Color.black, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(reassuranceYellow, lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: 720, maxHeight: .infinity)
        }
        .onAppear {
            isPulsing = true
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
        .interactiveDismissDisabled(true)
    }

    private var countdownText: String {
        String(format: "%02d:%02d", viewModel.countdownSeconds / 60, viewModel.countdownSeconds % 60)
    }

    private func statusRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(reassuranceYellow)
            Text(value)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .lineSpacing(4)
        }
    }
}

#Preview("通報狀態") {
    let model: AccessibilityHomeViewModel = {
        let model = AccessibilityHomeViewModel()
        model.emergencyState = .enRoute
        model.countdownSeconds = 118
        model.emergencyInfo.status = .staffAssigned
        model.emergencyInfo.staffName = "站務員 王先生"
        return model
    }()
    EmergencyStatusView(viewModel: model, onCancel: {})
}
