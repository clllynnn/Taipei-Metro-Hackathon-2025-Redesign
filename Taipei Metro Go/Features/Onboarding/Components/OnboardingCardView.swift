import SwiftUI

struct OnboardingCardView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let page: Int

    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                ScrollView(showsIndicators: false) {
                    cardContent(isAccessibilitySize: true)
                }
            } else {
                cardContent(isAccessibilitySize: false)
            }
        }
    }

    private func cardContent(isAccessibilitySize: Bool) -> some View {
        VStack(spacing: 0) {
            Group {
                switch page {
                case 0:
                    SmartCommuteDemoView()
                case 1:
                    StationMapDemoView()
                default:
                    TailoredModesDemoView()
                }
            }
            // The embedded mock screens are decorative previews; keep their sample UI
            // at a stable size while the explanatory copy below uses Dynamic Type.
            .environment(\.dynamicTypeSize, .large)
            .accessibilityHidden(true)
            .frame(height: isAccessibilitySize ? 180 : 250)
            .padding(.bottom, isAccessibilitySize ? 16 : 25)

            Text(title)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 12)

            Text(description)
                .font(.system(.subheadline))
                .foregroundStyle(Color.secondaryText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 3)

            if !isAccessibilitySize {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 2)
        .padding(.top, 4)
    }

    private var title: String {
        switch page {
        case 0: "智慧通勤，準時掌握"
        case 1: "自由查站，精準出口指引"
        default: "專屬模式，隨時切換"
        }
    }

    private var description: String {
        switch page {
        case 0:
            "AI 自動預測你的常用起終點，開啟 App 即可秒查進站倒數與車廂擁擠度，趕車不再慌張。"
        case 1:
            "點擊地圖任意車站即可查看廁所、電梯與超商出口；系統更會推薦最快出站／轉乘車廂，幫你高效避開人潮。"
        default:
            "為觀光客提供全段電梯與多語系導航；為無障礙族群提供語音問答與安心的實體求助反饋。"
        }
    }
}

private struct SmartCommuteDemoView: View {
    private let crowdLevels: [(String, Color, String)] = [
        ("舒適", Color(white: 0.48), "person.fill"),
        ("普通", Color(white: 0.30), "person.2.fill"),
        ("擁擠", Color.primaryText, "person.3.fill")
    ]

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let seconds = 38 - Int(context.date.timeIntervalSinceReferenceDate) % 30
            let crowdIndex = Int(context.date.timeIntervalSinceReferenceDate / 2.4) % crowdLevels.count
            let crowd = crowdLevels[crowdIndex]

            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("SMART TRAVEL")
                            .font(.system(.caption2, design: .rounded, weight: .bold))
                            .tracking(1.2)
                            .foregroundStyle(Color.secondaryText)
                        Text("台北車站  →  淡水")
                            .font(.system(.body, weight: .bold))
                            .foregroundStyle(Color.primaryText)
                    }
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.primaryAction)
                        .frame(width: 38, height: 38)
                        .background(Color.primaryAction.opacity(0.1), in: Circle())
                }

                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "tram.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.primaryAction)
                        .frame(width: 44, height: 44)
                        .background(Color.primaryAction.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("下一班列車")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                        Text("進站倒數")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.primaryText)
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("00:\(String(format: "%02d", seconds))")
                            .font(.system(.title, design: .rounded, weight: .bold).monospacedDigit())
                            .contentTransition(.numericText())
                            .foregroundStyle(Color.primaryText)
                        Text("秒")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                    }
                }

                HStack {
                    Label("建議第 3 車廂", systemImage: "figure.walk")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.primaryText)
                    Spacer(minLength: 6)
                    Label(crowd.0, systemImage: crowd.2)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(crowd.1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(crowd.1.opacity(0.11), in: Capsule())
                        .contentTransition(.opacity)
                        .animation(.easeInOut(duration: 0.35), value: crowdIndex)
                }
            }
            .padding(18)
            .background(.white, in: RoundedRectangle(cornerRadius: 23, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 23).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct StationMapDemoView: View {
    @State private var isSheetVisible = false
    @State private var selectedNode = 1

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(white: 0.10))

                Canvas { context, size in
                    var redRoute = Path()
                    redRoute.move(to: CGPoint(x: size.width * 0.17, y: size.height * 0.2))
                    redRoute.addLine(to: CGPoint(x: size.width * 0.17, y: size.height * 0.34))
                    redRoute.addQuadCurve(to: CGPoint(x: size.width * 0.76, y: size.height * 0.38), control: CGPoint(x: size.width * 0.19, y: size.height * 0.40))
                    redRoute.addLine(to: CGPoint(x: size.width * 0.76, y: size.height * 0.17))
                    context.stroke(redRoute, with: .color(MetroColor.R), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))

                    var goldRoute = Path()
                    goldRoute.move(to: CGPoint(x: size.width * 0.46, y: size.height * 0.12))
                    goldRoute.addLine(to: CGPoint(x: size.width * 0.46, y: size.height * 0.58))
                    context.stroke(goldRoute, with: .color(MetroColor.O), style: StrokeStyle(lineWidth: 7, lineCap: .round))
                }

                stationButton(id: 0, label: "中山", line: .red)
                    .position(x: proxy.size.width * 0.17, y: proxy.size.height * 0.29)
                stationButton(id: 1, label: "台北車站", line: .red)
                    .position(x: proxy.size.width * 0.46, y: proxy.size.height * 0.38)
                stationButton(id: 2, label: "東門", line: .orange)
                    .position(x: proxy.size.width * 0.46, y: proxy.size.height * 0.25)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("台北車站")
                                .font(.headline.weight(.bold))
                            Text("出口與站內設施")
                                .font(.caption)
                                .foregroundStyle(Color.secondaryText)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.secondaryText)
                    }
                    HStack(spacing: 8) {
                        facilityPill("🚻 廁所")
                        facilityPill("🏪 超商")
                        facilityPill("🛗 電梯")
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "figure.walk")
                        Text("建議第 4 車廂，轉乘更順")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.primaryAction)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .offset(y: isSheetVisible ? 0 : proxy.size.height * 0.62)
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .onAppear {
                withAnimation(.spring(response: 0.62, dampingFraction: 0.84).delay(0.35)) {
                    isSheetVisible = true
                }
            }
        }
        .padding(.horizontal, 6)
    }

    private func stationButton(id: Int, label: String, line: MetroLine) -> some View {
        Button {
            selectedNode = id
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) { isSheetVisible = true }
        } label: {
            HStack(spacing: 4) {
                MetroLineBadge(line: line, showsLineName: false, compact: true)
                Text(label)
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(Color.primaryText)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous).stroke(MetroColor.color(for: line), lineWidth: 2))
                .scaleEffect(selectedNode == id ? 1.08 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("選擇\(label)")
    }

    private func facilityPill(_ title: String) -> some View {
        Text(title)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Color.primaryText)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Color.pageBackground, in: Capsule())
    }
}

private struct TailoredModesDemoView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 2.8)) { context in
            let modeIndex = Int(context.date.timeIntervalSinceReferenceDate / 2.8) % 2
            let isTourism = modeIndex == 0

            VStack(spacing: 14) {
                HStack(spacing: 8) {
                    modePill("🧳 觀光模式", isSelected: isTourism)
                    modePill("🦯 無障礙模式", isSelected: !isTourism)
                }
                .padding(7)
                .background(Color.pageBackground, in: Capsule())

                VStack(spacing: 13) {
                    ZStack {
                        Circle()
                            .fill(Color.primaryAction.opacity(0.1))
                            .frame(width: 72, height: 72)
                        Image(systemName: isTourism ? "character.bubble.fill" : "figure.roll")
                            .font(.system(size: 29, weight: .semibold))
                            .foregroundStyle(Color.primaryAction)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    VStack(spacing: 5) {
                        Text(isTourism ? "多語系景點導航" : "安心語音引導")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.primaryText)
                            .contentTransition(.opacity)
                        Text(isTourism ? "電梯優先・景點出口推薦" : "語音問答・真人求助支援")
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                            .contentTransition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 148)
                .background(.white, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.black.opacity(0.06), lineWidth: 1))
                .animation(.easeInOut(duration: 0.45), value: modeIndex)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 6)
    }

    private func modePill(_ title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(isSelected ? Color.white : Color.secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(isSelected ? Color.primaryAction : .clear, in: Capsule())
            .animation(.easeInOut(duration: 0.35), value: isSelected)
    }
}
