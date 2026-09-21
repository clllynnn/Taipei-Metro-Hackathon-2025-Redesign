import SwiftUI

extension HighContrastMode {
    var backgroundColor: Color {
        switch self {
        case .standard: Color(white: 0.97)
        case .grayOnBlack, .whiteOnBlack: .black
        }
    }

    var surfaceColor: Color {
        switch self {
        case .standard: .white
        case .grayOnBlack: Color(white: 0.08)
        case .whiteOnBlack: Color(white: 0.09)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .standard: Color(white: 0.04)
        case .grayOnBlack: .white
        case .whiteOnBlack: .white
        }
    }

    var secondaryColor: Color {
        switch self {
        case .standard: Color(white: 0.16)
        case .grayOnBlack: Color(white: 0.86)
        case .whiteOnBlack: .white
        }
    }

    var accentColor: Color {
        switch self {
        case .standard: Color.primaryAction
        case .grayOnBlack: Color(red: 1.0, green: 0.84, blue: 0.0)
        case .whiteOnBlack: .white
        }
    }

    var borderColor: Color { foregroundColor }
}

extension Color {
    static let accessibilityEmergencyAccent = Color.primaryAction
    static let accessibilityEmergencyText = Color.white
}
