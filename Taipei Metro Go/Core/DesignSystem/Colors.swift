import SwiftUI

extension Color {
    // Transit route colors live in MetroColor. Status colors use the platform semantic palette.
    static let pageBackground = Color(uiColor: .systemGroupedBackground)
    static let primaryAction = Color(white: 0.10)
    static let secondaryAction = Color(white: 0.32)
    static let secondarySurface = Color(uiColor: .secondarySystemGroupedBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let line = Color(uiColor: .separator)
    static let softSurface = Color(uiColor: .tertiarySystemGroupedBackground)
    static let statusSuccess = secondaryAction
    static let alertAccent = primaryAction
    static let alertBackground = secondarySurface
    static let alertBorder = line
    static let crowdingLow = Color(uiColor: .systemGreen)
    static let crowdingModerate = Color(uiColor: .systemOrange)
    static let crowdingHigh = Color(uiColor: .systemRed)
    static let communityAccent = Color(uiColor: .systemBlue)
    static let communitySurface = Color(uiColor: .systemBlue).opacity(0.10)
    static let servicesAccent = secondaryAction
    static let servicesSurface = secondarySurface
    static let rewardsAccent = secondaryAction
    static let rewardsSurface = secondarySurface
}
