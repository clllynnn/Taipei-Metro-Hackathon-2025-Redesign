import SwiftUI

@MainActor
struct TourismHomeView: View {
    @StateObject private var viewModel: TourismViewModel
    var onReturnToGeneralMode: () -> Void = {}
    var onOpenRoutePlanner: () -> Void = {}

    @State private var activeSheet: TourismQuickAction?

    init(initialLanguage: TourismLanguage = .traditionalChinese, onReturnToGeneralMode: @escaping () -> Void = {}, onOpenRoutePlanner: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: TourismViewModel(initialLanguage: initialLanguage))
        self.onReturnToGeneralMode = onReturnToGeneralMode
        self.onOpenRoutePlanner = onOpenRoutePlanner
    }

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.height < 700
            let sectionSpacing: CGFloat = compact ? 10 : 12
            let verticalPadding: CGFloat = compact ? 8 : 10
            let headerHeight: CGFloat = compact ? 56 : 62
            let exitsHeight: CGFloat = compact ? 88 : 96
            let servicesHeight: CGFloat = compact ? 188 : 224

            VStack(spacing: sectionSpacing) {
                topNavigation(compact: compact)
                    .frame(height: headerHeight)
                ElevatorFirstCard(
                    route: $viewModel.elevatorRoute,
                    isElevatorFirst: $viewModel.isElevatorFirst,
                    language: viewModel.currentLanguage,
                    localizedStation: viewModel.localizedStation,
                    stationOptions: viewModel.routeStationOptions,
                    stationLine: viewModel.metroLine,
                    stationCode: viewModel.metroCode,
                    accessibleTransferMinutes: viewModel.accessibleTransferMinutes,
                    totalTravelMinutes: viewModel.totalTravelMinutes,
                    luggageMessage: viewModel.stationFacility.luggageSpaceMessage,
                    onPlan: viewModel.planElevatorRoute,
                    onSelectOrigin: viewModel.selectOriginStation,
                    onSelectDestination: viewModel.selectDestinationStation
                )
                .frame(maxHeight: .infinity)
                .layoutPriority(1)
                AttractionExitsBar(
                    exits: viewModel.attractionExits,
                    language: viewModel.currentLanguage,
                    localizedAttraction: viewModel.localizedAttraction
                )
                .frame(height: exitsHeight)
                TourismQuickActionGrid(
                    actions: viewModel.quickActionStates
                ) { action in
                    if action == .aiRoute {
                        onOpenRoutePlanner()
                    } else {
                        activeSheet = action
                    }
                }
                .frame(height: servicesHeight)
            }
            .padding(.horizontal, compact ? 12 : 16)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: 760, maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .onChange(of: viewModel.currentLanguage) { _, language in
            viewModel.setLanguage(language)
        }
        .sheet(item: $activeSheet) { action in
            sheetView(for: action)
                .presentationDetents([.medium, .large])
        }
    }

    private func topNavigation(compact: Bool) -> some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                MetroLogoView(size: compact ? 22 : 26, foregroundColor: .white)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Metro Go")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(TourismHomeCopy.text(.title, language: viewModel.currentLanguage))
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
            Spacer()
            Menu {
                ForEach(TourismLanguage.allCases) { option in
                    Button {
                        viewModel.setLanguage(option)
                    } label: {
                        if option == viewModel.currentLanguage {
                            Label(option.displayName, systemImage: "checkmark")
                        } else {
                            Text(option.displayName)
                        }
                    }
                }
            } label: {
                Label(viewModel.currentLanguage.displayName, systemImage: "globe")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .frame(minHeight: 38)
                    .background(Color.primaryAction.opacity(0.82), in: Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.45), lineWidth: 1))
            }
            .accessibilityLabel("Language: \(viewModel.currentLanguage.displayName)")
            Button(action: onReturnToGeneralMode) {
                Image(systemName: "suitcase.fill")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.primaryAction.opacity(0.82), in: Circle())
                    .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(TourismHomeCopy.text(.generalMode, language: viewModel.currentLanguage))
        }
        .padding(.horizontal, 13)
        .frame(minHeight: compact ? 54 : 62)
        .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    @ViewBuilder
    private func sheetView(for action: TourismQuickAction) -> some View {
        switch action {
        case .passWallet:
            PassWalletSheet(language: viewModel.currentLanguage, qrTicketCount: viewModel.qrTicketCount, onSelectPass: viewModel.selectPass)
        case .locker:
            LockerInfoSheet(language: viewModel.currentLanguage, station: viewModel.selectedLockerStation, locker: viewModel.selectedLocker, onSelectStation: viewModel.selectLockerStation)
        case .airport:
            TaoyuanAirportSheet(language: viewModel.currentLanguage)
        case .assistance:
            AssistanceModal(language: viewModel.currentLanguage, isActive: $viewModel.isAssistanceAlertActive)
        case .aiRoute:
            EmptyView()
        }
    }
}

#Preview("觀光模式・四國語言") {
    TourismHomeView()
}

#Preview("觀光模式・English") {
    TourismHomeView(initialLanguage: .english)
}

#Preview("觀光模式・日本語／한국어") {
    HStack(spacing: 12) {
        TourismHomeView(initialLanguage: .japanese)
        TourismHomeView(initialLanguage: .korean)
    }
}
