import Foundation

enum HighContrastMode: String, CaseIterable, Identifiable {
    case standard
    case grayOnBlack
    case whiteOnBlack

    var id: Self { self }

    var next: HighContrastMode {
        switch self {
        case .standard: .grayOnBlack
        case .grayOnBlack: .whiteOnBlack
        case .whiteOnBlack: .standard
        }
    }

    var title: String {
        switch self {
        case .standard: "標準高對比"
        case .grayOnBlack: "灰字黑底"
        case .whiteOnBlack: "白字黑底"
        }
    }
}
