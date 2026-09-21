import SwiftUI

@MainActor
struct HomeView: View {
    @ObservedObject private var travelState: TravelState
    @StateObject private var viewModel: HomeViewModel
    private let onOpenRouteMap: () -> Void
    private let onSelectService: (MetroServiceShortcut) -> Void

    init(
        travelState: TravelState,
        onOpenRouteMap: @escaping () -> Void = {},
        onSelectService: @escaping (MetroServiceShortcut) -> Void = { _ in }
    ) {
        _travelState = ObservedObject(wrappedValue: travelState)
        _viewModel = StateObject(wrappedValue: HomeViewModel(travelState: travelState))
        self.onOpenRouteMap = onOpenRouteMap
        self.onSelectService = onSelectService
    }

    var body: some View {
        Group {
            if viewModel.appMode == .accessibility {
                AccessibilityHomeView {
                    viewModel.setMode(.normal)
                }
            } else if viewModel.appMode == .tourist {
                TourismHomeView(onReturnToGeneralMode: {
                    viewModel.setMode(.normal)
                }, onOpenRoutePlanner: onOpenRouteMap)
            } else {
                standardHome
            }
        }
    }

    private var standardHome: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.height < 820
            ZStack(alignment: .top) {
                standardContent(isCompact: isCompact)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if let alertMessage = viewModel.alertMessage, !alertMessage.isEmpty {
                    ServiceAlertBanner(
                        alertMessage: alertMessage,
                        language: viewModel.currentLanguage,
                        isCompact: isCompact,
                        onDismiss: viewModel.dismissAlert
                    )
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .zIndex(10)
                }
            }
            .background(Color.pageBackground.ignoresSafeArea())
        }
        .onChange(of: viewModel.currentLanguage) { _, language in
            viewModel.setLanguage(language)
        }
        .preferredColorScheme(.light)
    }

    private func standardContent(isCompact: Bool, fillsViewport: Bool = true) -> some View {
        VStack(spacing: 0) {
            HeaderSectionView(
                currentLanguage: $viewModel.currentLanguage,
                appMode: $viewModel.appMode,
                isCompact: isCompact
            )

            VStack(spacing: isCompact ? 10 : 16) {
                Text(viewModel.smartTravelState.routeRecommendation.contextMessage)
                    .font(.system(size: isCompact ? 38 : 46, weight: .bold, design: .default))
                    .foregroundStyle(Color.primaryText)
                    .kerning(-0.35)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)

                SmartTravelCard(
                    state: viewModel.smartTravelState,
                    language: viewModel.currentLanguage,
                    isCompact: isCompact,
                    favoriteDestinations: viewModel.favoriteDestinations,
                    selectableStations: viewModel.selectableStations,
                    onAdjustRoute: onOpenRouteMap,
                    onSwapRoute: viewModel.swapRoute,
                    onSelectOrigin: viewModel.updateOrigin,
                    onSelectDestination: viewModel.updateDestination
                )

                MetroServicesSection(
                    language: viewModel.currentLanguage,
                    isCompact: isCompact,
                    onSelect: onSelectService
                )
            }
                .padding(.horizontal, isCompact ? 14 : 20)
                .padding(.top, isCompact ? 8 : 14)
                .padding(.bottom, isCompact ? 5 : 12)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity, maxHeight: fillsViewport ? .infinity : nil, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: fillsViewport ? .infinity : nil, alignment: .top)
    }

}

#Preview {
    HomeView(travelState: TravelState.mock)
        .environmentObject(TravelState.mock)
}

#Preview("首頁・最大輔助使用字級") {
    HomeView(travelState: TravelState.mock)
        .environmentObject(TravelState.mock)
        .environment(\.dynamicTypeSize, .accessibility5)
}
