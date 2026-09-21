import SwiftUI

struct TrainCrowdednessView: View {
    let arrivalInfo: TrainArrivalInfo
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(HomeCopy.text(.exitCarriageRecommendation, language: language))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.secondaryText)
                Spacer(minLength: 4)
                Text(recommendationReason)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.primaryText)
            }

            HStack(spacing: 4) {
                ForEach(displayCarriages) { carriageInfo in
                    carriage(carriageInfo)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(carCountLabel)。\(recommendationAccessibilityText)")
    }

    private var displayCarriages: [CarriageCrowdingInfo] {
        guard !arrivalInfo.carriageCrowding.isEmpty else {
            return (1...6).map {
                CarriageCrowdingInfo(
                    number: $0,
                    crowdingLevel: arrivalInfo.crowdingLevel,
                    recommendationRank: $0 == 3 ? 1 : ($0 == 4 ? 2 : nil)
                )
            }
        }
        return arrivalInfo.carriageCrowding
    }

    private var recommendedCarriages: [CarriageCrowdingInfo] {
        displayCarriages
            .filter { $0.recommendationRank != nil }
            .sorted { ($0.recommendationRank ?? 99) < ($1.recommendationRank ?? 99) }
    }

    private var recommendationAccessibilityText: String {
        let numbers = recommendedCarriages.map(\.number)
        guard numbers.count >= 2 else { return "" }
        let exit = arrivalInfo.preferredExitName ?? defaultExitLabel
        switch language {
        case .traditionalChinese:
            return "依常用 " + exit + "：首選第 " + String(numbers[0]) + " 車、次選第 " + String(numbers[1]) + " 車"
        case .english:
            return "For your usual " + exit + ": car " + String(numbers[0]) + " first, car " + String(numbers[1]) + " second"
        case .japanese:
            return "よく使う" + exit + "：第" + String(numbers[0]) + "車両、第" + String(numbers[1]) + "車両の順"
        case .korean:
            return "자주 쓰는 " + exit + ": " + String(numbers[0]) + "호차, " + String(numbers[1]) + "호차 순"
        }
    }

    private var defaultExitLabel: String {
        switch language {
        case .traditionalChinese: "出口"
        case .english: "exit"
        case .japanese: "出口"
        case .korean: "출구"
        }
    }

    private var carCountLabel: String {
        switch language {
        case .traditionalChinese: "六節車廂"
        case .english: "Six cars"
        case .japanese: "6両編成"
        case .korean: "6량 열차"
        }
    }

    private func carriage(_ info: CarriageCrowdingInfo) -> some View {
        let rank = info.recommendationRank
        let isRecommended = rank != nil
        let primaryContentColor = isRecommended ? Color.white : Color.primaryText.opacity(0.72)
        let secondaryContentColor = isRecommended ? Color.white.opacity(0.82) : Color.secondaryText
        return VStack(spacing: 3) {
            HStack(spacing: 2) {
                RoundedRectangle(cornerRadius: 1).fill(primaryContentColor.opacity(0.72))
                RoundedRectangle(cornerRadius: 1).fill(primaryContentColor.opacity(0.72))
            }
            .frame(height: 4)

            Text("\(info.number)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundStyle(primaryContentColor)

            Text(compactCrowdingTitle(info.crowdingLevel))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(secondaryContentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(
            isRecommended ? Color.black : Color.secondarySurface,
            in: RoundedRectangle(cornerRadius: 7, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .stroke(
                    isRecommended ? Color.black : Color.line.opacity(0.58),
                    lineWidth: isRecommended ? 1.5 : 1
                )
        }
    }

    private var recommendationReason: String {
        let exit = arrivalInfo.preferredExitName ?? defaultExitLabel
        return switch language {
        case .traditionalChinese: "靠近常用 \(exit)"
        case .english: "Near your usual \(exit)"
        case .japanese: "よく使う\(exit)に近い"
        case .korean: "자주 쓰는 \(exit) 근처"
        }
    }

    private func compactCrowdingTitle(_ level: CrowdingLevel) -> String {
        switch (level, language) {
        case (.low, .traditionalChinese): "舒適"
        case (.moderate, .traditionalChinese): "普通"
        case (.high, .traditionalChinese): "擁擠"
        case (.low, .english): "Comfortable"
        case (.moderate, .english): "Moderate"
        case (.high, .english): "Crowded"
        case (.low, .japanese): "快適"
        case (.moderate, .japanese): "普通"
        case (.high, .japanese): "混雑"
        case (.low, .korean): "여유"
        case (.moderate, .korean): "보통"
        case (.high, .korean): "혼잡"
        }
    }
}

#Preview {
    TrainCrowdednessView(
        arrivalInfo: TrainArrivalInfo(
            direction: "往南港展覽館",
            countdownSeconds: 222,
            crowdingLevel: .moderate,
            carriageCrowding: [
                .init(number: 1, crowdingLevel: .high, recommendationRank: nil),
                .init(number: 2, crowdingLevel: .moderate, recommendationRank: nil),
                .init(number: 3, crowdingLevel: .low, recommendationRank: nil),
                .init(number: 4, crowdingLevel: .low, recommendationRank: 1),
                .init(number: 5, crowdingLevel: .moderate, recommendationRank: 2),
                .init(number: 6, crowdingLevel: .high, recommendationRank: nil)
            ],
            preferredExitName: "2 號出口"
        ),
        language: .traditionalChinese
    )
        .padding()
        .background(Color.pageBackground)
}
