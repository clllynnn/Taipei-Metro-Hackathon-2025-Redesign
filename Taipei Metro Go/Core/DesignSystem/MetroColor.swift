import SwiftUI

/// Official Taipei Metro line colors used by station markers and vector routes.
enum MetroColor {
    static let BR = color(hex: hexValue(for: .brown))
    static let R = color(hex: hexValue(for: .red))
    static let G = color(hex: hexValue(for: .green))
    /// Xiaobitan branch color used between Qizhang and Xiaobitan.
    static let G03A = color(hex: 0xCFDB00)
    static let O = color(hex: hexValue(for: .orange))
    static let BL = color(hex: hexValue(for: .blue))
    static let Y = color(hex: hexValue(for: .yellow))

    static func color(for line: MetroLine) -> Color {
        switch line {
        case .brown: BR
        case .red: R
        case .green: G
        case .orange: O
        case .blue: BL
        case .yellow: Y
        }
    }

    static func hex(for line: MetroLine) -> String {
        String(format: "%06X", hexValue(for: line))
    }

    private static func hexValue(for line: MetroLine) -> UInt32 {
        switch line {
        case .brown: 0xC48C31
        case .red: 0xE3002C
        case .green: 0x008659
        case .orange: 0xF8B61C
        case .blue: 0x0070BD
        case .yellow: 0xFCDA01
        }
    }

    private static func color(hex: UInt32) -> Color {
        Color(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
