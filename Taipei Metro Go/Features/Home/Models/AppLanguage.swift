import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
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

    var shortName: String {
        switch self {
        case .traditionalChinese: "中"
        case .english: "EN"
        case .japanese: "日"
        case .korean: "한"
        }
    }
}
