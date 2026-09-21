import Foundation

enum TourismLanguage: String, CaseIterable, Identifiable {
    case traditionalChinese
    case english
    case japanese
    case korean

    var id: Self { self }

    var displayName: String {
        switch self {
        case .traditionalChinese: "繁體中文"
        case .english: "English"
        case .japanese: "日本語"
        case .korean: "한국어"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .traditionalChinese: "zh-Hant-TW"
        case .english: "en-US"
        case .japanese: "ja-JP"
        case .korean: "ko-KR"
        }
    }
}
