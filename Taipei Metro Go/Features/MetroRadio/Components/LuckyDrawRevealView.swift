import Foundation
import SwiftUI

struct LuckyDrawRevealView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    let forcedOutcome: LuckyDrawOutcome?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isRevealing = true
    @State private var startedAt = Date()
    @State private var revealTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.metroRadioNavy, .metroRadioIndigo, .metroRadioTeal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            animatedBackdrop

            VStack(spacing: 0) {
                HStack {
                    Text("每日幸運抽選")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                    Spacer()
                    Button(isRevealing ? "略過" : "關閉") { dismiss() }
                        .font(.system(.subheadline, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 14)

                Spacer()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(isRevealing ? "正在揭曉" : resultTitle)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text(isRevealing ? "今天的幸運序號正在對獎" : resultMessage)
                            .font(.system(.subheadline, weight: .medium))
                            .foregroundStyle(.white.opacity(0.78))
                            .multilineTextAlignment(.center)
                    }

                    drawNumber
                        .padding(.horizontal, 16)

                    Text(ticketCode)
                        .font(.system(.caption, design: .monospaced, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.64))

                    if !isRevealing {
                        Button("回到捷客電台") { dismiss() }
                            .font(.system(.headline, weight: .semibold))
                            .foregroundStyle(Color.metroRadioNavy)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.top, 8)
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .frame(maxWidth: 520)

                Spacer()
                Spacer(minLength: 32)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: startReveal)
        .onDisappear { revealTask?.cancel() }
    }

    @ViewBuilder
    private var drawNumber: some View {
        if isRevealing && !reduceMotion {
            TimelineView(.animation(minimumInterval: 0.065)) { context in
                digitRow(rollingDigits(at: context.date))
            }
        } else if isRevealing {
            digitRow(Array(repeating: "•", count: 6))
        } else {
            digitRow(settledDigits)
        }
    }

    private func digitRow(_ digits: [String]) -> some View {
        HStack(spacing: 7) {
            ForEach(Array(digits.enumerated()), id: \.offset) { _, digit in
                Text(digit)
                    .font(.system(size: 29, weight: .heavy, design: .monospaced))
                    .foregroundStyle(Color.metroRadioNavy)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .contentTransition(.numericText())
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isRevealing ? "抽選號碼轉動中" : "抽選號碼 \(digits.joined())")
    }

    @ViewBuilder
    private var animatedBackdrop: some View {
        if reduceMotion {
            backdrop(phase: 0)
        } else {
            TimelineView(.animation(minimumInterval: 0.04)) { context in
                backdrop(phase: context.date.timeIntervalSinceReferenceDate)
            }
        }
    }

    private func backdrop(phase: TimeInterval) -> some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    let progress = (sin(phase * 0.65 + Double(index) * 1.3) + 1) / 2
                    Circle()
                        .stroke(.white.opacity(0.07 + progress * 0.08), lineWidth: 2)
                        .frame(width: 130 + progress * 210, height: 130 + progress * 210)
                        .position(
                            x: geometry.size.width * (0.16 + Double(index) * 0.18),
                            y: geometry.size.height * (0.20 + 0.13 * sin(phase * 0.42 + Double(index)))
                        )
                }
            }
        }
        .ignoresSafeArea()
    }

    private var ticketCode: String {
        guard let id = viewModel.mySongRequest?.id else { return "MRT-——" }
        return "抽選序號 MRT-\(id.uuidString.replacingOccurrences(of: "-", with: "").prefix(8))"
    }

    private var settledDigits: [String] {
        guard let id = viewModel.mySongRequest?.id else { return Array(repeating: "–", count: 6) }
        let seed = id.uuidString.unicodeScalars.enumerated().reduce(0) { partial, pair in
            (partial + Int(pair.element.value) * (pair.offset + 3)) % 1_000_000
        }
        return String(format: "%06d", seed).map(String.init)
    }

    private func rollingDigits(at date: Date) -> [String] {
        let tick = Int(max(date.timeIntervalSince(startedAt), 0) * 16)
        return (0..<6).map { String((tick * 3 + $0 * 7) % 10) }
    }

    private var resultTitle: String {
        viewModel.checkInStatus == .winner ? "恭喜中選" : "今天差一點"
    }

    private var resultMessage: String {
        if viewModel.checkInStatus == .winner {
            return "你的歌曲已成為今日幸運點播"
        }
        return "歌曲與故事已保留，明天可以一鍵沿用"
    }

    private func startReveal() {
        guard revealTask == nil else { return }
        startedAt = .now
        let delay: UInt64 = reduceMotion ? 350_000_000 : 2_400_000_000
        revealTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay)
            guard !Task.isCancelled else { return }
            viewModel.drawLottery(forcedOutcome: forcedOutcome)
            withAnimation(.spring(response: 0.55, dampingFraction: 0.68)) {
                isRevealing = false
            }
        }
    }
}

#Preview {
    LuckyDrawRevealView(viewModel: MetroRadioViewModel(), forcedOutcome: .winner)
}
