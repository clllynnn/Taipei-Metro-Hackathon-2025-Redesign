import SwiftUI

enum MetroServiceShortcut {
    case metroMall
    case metroRadio
    case points
}

struct MetroServicesSection: View {
    let language: AppLanguage
    var isCompact = false
    var onSelect: (MetroServiceShortcut) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(sectionTitle)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.primaryText)
            HStack(spacing: isCompact ? 7 : 9) {
                serviceButton(
                    title: mallTitle,
                    highlight: mallHighlight,
                    tint: .primaryAction,
                    action: { onSelect(.metroMall) }
                )
                serviceButton(
                    title: radioTitle,
                    highlight: radioHighlight,
                    tint: .primaryAction,
                    action: { onSelect(.metroRadio) }
                )
                serviceButton(
                    title: pointsTitle,
                    highlight: pointsHighlight,
                    tint: .primaryAction,
                    action: { onSelect(.points) }
                )
            }
        }
    }

    private var sectionTitle: String {
        switch language {
        case .traditionalChinese: "捷運生活與商業服務"
        case .english: "Metro services"
        case .japanese: "地下鉄サービス"
        case .korean: "지하철 서비스"
        }
    }

    private var mallTitle: String { language == .traditionalChinese ? "捷運商城" : HomeCopy.text(.metroMall, language: language) }
    private var radioTitle: String {
        switch language {
        case .traditionalChinese: "捷客電台"
        case .english: "MetroTogether"
        case .japanese, .korean: HomeCopy.text(.metroTogether, language: language)
        }
    }
    private var pointsTitle: String { language == .traditionalChinese ? "捷運點活動" : HomeCopy.text(.points, language: language) }

    private var mallHighlight: String {
        switch language { case .traditionalChinese: "熱銷商品"; case .english: "Best sellers"; case .japanese: "人気商品"; case .korean: "인기 상품" }
    }
    private var radioHighlight: String {
        switch language { case .traditionalChinese: "線上共乘"; case .english: "Live community"; case .japanese: "ライブ交流"; case .korean: "라이브 커뮤니티" }
    }
    private var pointsHighlight: String {
        switch language { case .traditionalChinese: "搭乘集點"; case .english: "Rewards available"; case .japanese: "乗車で貯まる"; case .korean: "탑승 적립 혜택" }
    }

    private func serviceButton(title: String, highlight: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
                Text(highlight)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(tint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
            }
            .padding(.horizontal, isCompact ? 8 : 10)
            .padding(.vertical, 8)
            .frame(
                maxWidth: .infinity,
                minHeight: isCompact ? 76 : 82,
                alignment: .leading
            )
            .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.line.opacity(0.65), lineWidth: 1))
            .shadow(color: .black.opacity(0.025), radius: 6, y: 2)
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(MetroServiceCardButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(openHint(title))
    }

    private func openHint(_ title: String) -> String {
        switch language {
        case .traditionalChinese: "開啟 \(title)"
        case .english: "Open \(title)"
        case .japanese: "\(title)を開く"
        case .korean: "\(title) 열기"
        }
    }
}

private struct MetroServiceCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.74 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    MetroServicesSection(language: .traditionalChinese)
        .padding()
        .background(Color.pageBackground)
}
