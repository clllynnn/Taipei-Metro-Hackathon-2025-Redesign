import Combine
import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    @Published var currentPage: Int = 0

    let pageCount = 3

    init(previewMode: Bool = false) {
        guard previewMode, let previewDefaults = UserDefaults(suiteName: "OnboardingPreview") else { return }
        previewDefaults.set(false, forKey: "hasSeenOnboarding")
        _hasSeenOnboarding = AppStorage(
            wrappedValue: false,
            "hasSeenOnboarding",
            store: previewDefaults
        )
    }

    func advanceOrDismiss() {
        guard currentPage < pageCount - 1 else {
            dismissOnboarding()
            return
        }

        withAnimation(.easeInOut(duration: 0.25)) {
            currentPage += 1
        }
    }

    func dismissOnboarding() {
        hasSeenOnboarding = true
    }
}
