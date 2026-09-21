import Foundation

enum AppMode: String, CaseIterable, Identifiable {
    case normal
    case tourist
    case accessibility

    var id: Self { self }

    func title(language: AppLanguage) -> String {
        switch (self, language) {
        case (.normal, .traditionalChinese): "一般模式"
        case (.tourist, .traditionalChinese): "觀光客模式"
        case (.accessibility, .traditionalChinese): "無障礙模式"
        case (.normal, .english): "Standard"
        case (.tourist, .english): "Tourist"
        case (.accessibility, .english): "Accessibility"
        case (.normal, .japanese): "標準モード"
        case (.tourist, .japanese): "観光モード"
        case (.accessibility, .japanese): "バリアフリーモード"
        case (.normal, .korean): "일반 모드"
        case (.tourist, .korean): "관광객 모드"
        case (.accessibility, .korean): "교통약자 모드"
        }
    }

    var symbol: String {
        switch self {
        case .normal: "tram.fill"
        case .tourist: "suitcase.rolling.fill"
        case .accessibility: "figure.roll"
        }
    }
}
