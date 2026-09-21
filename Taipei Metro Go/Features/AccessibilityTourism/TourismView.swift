import SwiftUI

/// Compatibility entry point retained for existing navigation callers.
@MainActor
struct TourismView: View {
    var onReturnToGeneralMode: () -> Void = {}

    var body: some View {
        TourismHomeView(onReturnToGeneralMode: onReturnToGeneralMode)
    }
}

#Preview {
    TourismHomeView()
}
