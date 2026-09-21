import SwiftUI

/// Shared tactile feedback for the high-contrast mode buttons.
/// The visual treatment stays custom, while the interaction follows the
/// standard iOS pressed-state behavior.
struct AccessibilityButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.78 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
