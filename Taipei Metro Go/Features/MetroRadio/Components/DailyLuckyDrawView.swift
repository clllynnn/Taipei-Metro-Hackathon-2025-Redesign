import Foundation
import SwiftUI

struct DailyLuckyDrawView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    let isCollapsible: Bool

    @State private var isExpanded: Bool
    @State private var isShowingReveal = false
    @State private var forcedOutcome: LuckyDrawOutcome?

    init(viewModel: MetroRadioViewModel, isCollapsible: Bool = false) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.isCollapsible = isCollapsible
        _isExpanded = State(initialValue: !isCollapsible)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded ? 14 : 0) {
            header

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    lotteryTicket
                    drawAction
                    simulationControls
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(isExpanded ? 18 : 13)
        .background(
            LinearGradient(
                colors: [Color.metroRadioCream.opacity(0.96), Color.metroRadioLilac.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.metroRadioBerry.opacity(0.18), lineWidth: 1)
        }
        .fullScreenCover(isPresented: $isShowingReveal, onDismiss: { forcedOutcome = nil }) {
            LuckyDrawRevealView(viewModel: viewModel, forcedOutcome: forcedOutcome)
        }
    }

    @ViewBuilder
    private var header: some View {
        if isCollapsible {
            Button {
                withAnimation(.easeInOut(duration: 0.24)) {
                    isExpanded.toggle()
                }
            } label: {
                headerContent
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isExpanded ? "收起每日幸運抽選" : "展開每日幸運抽選")
        } else {
            headerContent
        }
    }

    private var headerContent: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text("每日幸運抽選")
                    .font(.system(isExpanded ? .headline : .subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.metroRadioInk)
                Text(drawHeadline)
                    .font(.system(isExpanded ? .footnote : .caption))
                    .foregroundStyle(Color.metroRadioMutedInk)
                    .lineLimit(isExpanded ? 2 : 1)
            }

            Spacer(minLength: 6)

            VStack(alignment: .trailing, spacing: 4) {
                Text(statusLabel)
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(statusColor)
                if isCollapsible {
                    Text(isExpanded ? "收起" : "展開")
                        .font(.system(.caption2, weight: .medium))
                        .foregroundStyle(Color.metroRadioMutedInk)
                }
            }
        }
        .contentShape(Rectangle())
    }

    private var lotteryTicket: some View {
        VStack(spacing: 11) {
            HStack {
                Text("抽選序號")
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(Color.metroRadioMutedInk)
                Spacer(minLength: 8)
                Text(ticketCode)
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundStyle(Color.metroRadioBerry)
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
            }

            perforatedLine
            digitRow(settledDigits)

            Text(resultMessage)
                .font(.system(.footnote, weight: .medium))
                .foregroundStyle(resultColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.metroRadioBerry.opacity(0.12), lineWidth: 1)
        }
    }

    private func digitRow(_ digits: [String]) -> some View {
        HStack(spacing: 6) {
            ForEach(Array(digits.enumerated()), id: \.offset) { _, digit in
                Text(digit)
                    .font(.system(.title3, design: .monospaced, weight: .heavy))
                    .foregroundStyle(Color.metroRadioPlum)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.metroRadioLilac.opacity(0.52), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("抽選號碼 \(digits.joined())")
    }

    @ViewBuilder
    private var drawAction: some View {
        switch viewModel.checkInStatus {
        case .submitted, .carriedOver:
            Button { presentReveal() } label: {
                Text("揭曉今日結果")
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        LinearGradient(
                            colors: [Color.metroRadioPlum, Color.metroRadioBerry],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
            }
            .buttonStyle(.plain)

        case .winner:
            resultText("中選歌曲已加入今日幸運電台", color: .metroRadioBerry)
        case .notSelected:
            resultText("點播內容已保留，明天可以一鍵沿用", color: .metroRadioMutedInk)
        case .available:
            resultText("完成今日點播後，就會取得一張抽選券", color: .metroRadioMutedInk)
        }
    }

    private func resultText(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(.footnote, weight: .semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var simulationControls: some View {
        HStack(spacing: 8) {
            Text("滿版動畫預覽")
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(Color.metroRadioMutedInk)
            Spacer(minLength: 4)
            simulationButton("模擬中獎", outcome: .winner)
            simulationButton("模擬未中獎", outcome: .notSelected)
        }
    }

    private func simulationButton(_ title: String, outcome: LuckyDrawOutcome) -> some View {
        Button {
            viewModel.prepareLotterySimulation()
            presentReveal(forcedOutcome: outcome)
        } label: {
            Text(title)
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(Color.metroRadioBlue)
                .padding(.horizontal, 10)
                .frame(minHeight: 34)
                .background(Color.metroRadioBlueSurface, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var perforatedLine: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0.5))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0.5))
            }
            .stroke(Color.metroRadioBerry.opacity(0.28), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
        }
        .frame(height: 1)
    }

    private var ticketCode: String {
        guard let id = viewModel.mySongRequest?.id else { return "完成點播後取得抽選序號" }
        return "MRT-\(id.uuidString.replacingOccurrences(of: "-", with: "").prefix(8))"
    }

    private var settledDigits: [String] {
        guard let id = viewModel.mySongRequest?.id else { return Array(repeating: "–", count: 6) }
        let seed = id.uuidString.unicodeScalars.enumerated().reduce(0) { partial, pair in
            (partial + Int(pair.element.value) * (pair.offset + 3)) % 1_000_000
        }
        return String(format: "%06d", seed).map(String.init)
    }

    private var drawHeadline: String {
        switch viewModel.checkInStatus {
        case .available: "留下一首歌，取得今天的抽選券"
        case .submitted, .carriedOver: "抽選券已投入，結果等你親自揭曉"
        case .winner: "你的歌被選中了，今天會陪著沿線乘客"
        case .notSelected: "這次差一點，你的歌與故事仍會被保留"
        }
    }

    private var statusLabel: String {
        switch viewModel.checkInStatus {
        case .available: "等待登記"
        case .submitted, .carriedOver: "可揭曉"
        case .winner: "已中選"
        case .notSelected: "已開獎"
        }
    }

    private var statusColor: Color {
        switch viewModel.checkInStatus {
        case .winner: .metroRadioCoral
        case .submitted, .carriedOver: .metroRadioBerry
        case .available, .notSelected: .metroRadioMutedInk
        }
    }

    private var resultMessage: String {
        switch viewModel.checkInStatus {
        case .available: "今天的抽選號碼會在點播後出現"
        case .submitted, .carriedOver: "序號已鎖定，點一下進入滿版開獎"
        case .winner: "恭喜中選！你的點播成為今日幸運歌曲"
        case .notSelected: "本次未中選，但累積權重與點播紀錄都已保留"
        }
    }

    private var resultColor: Color {
        viewModel.checkInStatus == .winner ? .metroRadioCoral : .metroRadioMutedInk
    }

    private func presentReveal(forcedOutcome: LuckyDrawOutcome? = nil) {
        guard viewModel.checkInStatus == .submitted || viewModel.checkInStatus == .carriedOver else { return }
        self.forcedOutcome = forcedOutcome
        isShowingReveal = true
    }
}

#Preview("抽選券・展開") {
    DailyLuckyDrawView(viewModel: MetroRadioViewModel())
        .padding()
        .background(Color.metroRadioCanvas)
}

#Preview("抽選券・收合") {
    DailyLuckyDrawView(viewModel: MetroRadioViewModel(), isCollapsible: true)
        .padding()
        .background(Color.metroRadioCanvas)
}
