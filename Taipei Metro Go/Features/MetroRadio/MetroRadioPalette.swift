import SwiftUI

/// Semantic colors for the radio experience. Surfaces and labels follow UIKit's
/// adaptive palette; saturated colors are reserved for hierarchy and status.
extension Color {
    static let metroRadioCanvas = Color(uiColor: .systemGroupedBackground)
    static let metroRadioCanvasDeep = Color(red: 0.90, green: 0.95, blue: 0.98)
    static let metroRadioInk = Color(uiColor: .label)
    static let metroRadioMutedInk = Color(uiColor: .secondaryLabel)

    static let metroRadioNavy = Color(red: 0.08, green: 0.18, blue: 0.36)
    static let metroRadioIndigo = Color(uiColor: .systemIndigo)
    static let metroRadioTeal = Color(uiColor: .systemTeal)
    static let metroRadioSky = Color(uiColor: .systemCyan)
    static let metroRadioGold = Color(uiColor: .systemYellow)
    static let metroRadioMint = Color(uiColor: .systemGreen)
    static let metroRadioBlue = Color(uiColor: .systemBlue)

    static let metroRadioCream = Color(uiColor: .secondarySystemGroupedBackground)
    static let metroRadioLilac = Color(uiColor: .tertiarySystemGroupedBackground)
    static let metroRadioRoseSurface = Color(red: 0.86, green: 0.96, blue: 0.95)
    static let metroRadioBlueSurface = Color(red: 0.86, green: 0.93, blue: 0.99)
    static let metroRadioMintSurface = Color(red: 0.86, green: 0.96, blue: 0.91)

    // Compatibility aliases for existing components while the UI uses the new
    // cool semantic palette rather than the original warm spectrum.
    static let metroRadioPlum = metroRadioNavy
    static let metroRadioBerry = metroRadioIndigo
    static let metroRadioCoral = metroRadioTeal
    static let metroRadioPeach = metroRadioSky
    static let metroRadioSun = metroRadioGold
}
