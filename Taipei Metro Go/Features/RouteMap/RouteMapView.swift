import SwiftUI

@MainActor
struct RouteMapView: View {
    private enum StationSelectionTarget: String, Identifiable {
        case currentStation
        case destination

        var id: String { rawValue }

        var title: String {
            switch self {
            case .currentStation: "選擇目前站點"
            case .destination: "選擇目的地"
            }
        }
    }

    @EnvironmentObject var travelState: TravelState
    @StateObject private var viewModel: RouteMapViewModel
    @State private var stationSelectionTarget: StationSelectionTarget?

    init() {
        _viewModel = StateObject(wrappedValue: RouteMapViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            routeHero
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 10)

            Divider()

            InteractiveMapView(
                stations: viewModel.stations,
                currentStation: viewModel.userCurrentStation,
                destinationStation: viewModel.selectedDestinationStation,
                language: travelState.currentLanguage,
                onSelectStation: viewModel.selectDestination
            )
        }
        .background(Color(uiColor: .systemBackground))
        .sheet(item: $viewModel.presentedStation, onDismiss: viewModel.cancelStationSelection) { station in
            StationBottomSheet(
                viewModel: viewModel,
                station: station,
                isCurrentDestination: travelState.selectedDestination?.id == station.id,
                onSetDestination: { viewModel.setDestination(station) }
            )
        }
        .sheet(item: $stationSelectionTarget) { target in
            StationPickerSheet(
                title: target.title,
                stations: viewModel.stations,
                selectedStationID: target == .currentStation
                    ? viewModel.userCurrentStation?.id
                    : viewModel.selectedDestinationStation?.id
            ) { station in
                switch target {
                case .currentStation:
                    viewModel.selectCurrentStation(station)
                case .destination:
                    viewModel.selectDestinationFromHeader(station)
                }
                stationSelectionTarget = nil
            }
        }
        .onAppear { viewModel.bind(to: travelState) }
        .onChange(of: travelState.currentStation) { _, _ in viewModel.syncWithTravelState() }
        .onChange(of: travelState.selectedDestination) { _, _ in viewModel.syncWithTravelState() }
        .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }

    private var routeHero: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                stationSummary(
                    caption: "目前站點",
                    name: viewModel.userCurrentStation?.name ?? "定位中",
                    color: .primary,
                    action: { stationSelectionTarget = .currentStation }
                )

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.secondary)

                stationSummary(
                    caption: "目的地",
                    name: viewModel.selectedDestinationStation?.name ?? "選擇車站",
                    color: viewModel.selectedDestinationStation == nil ? .secondary : .primary,
                    action: { stationSelectionTarget = .destination }
                )

                Spacer(minLength: 0)
            }

            Divider()

            if let estimate = viewModel.bestRouteEstimate {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.branch")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.secondary)

                    Text("轉乘 \(estimate.transferCount) 次")
                        .font(.system(.caption, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    Spacer(minLength: 8)

                    Text("約 \(estimate.minutes) 分鐘")
                        .font(.system(.subheadline, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                HStack(spacing: 7) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 12, weight: .semibold))
                    Text("點擊下方任一站點開始規劃路線")
                        .font(.system(.caption, weight: .semibold))
                    Spacer(minLength: 0)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color.primary.opacity(0.07), lineWidth: 1))
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDestinationStation)
    }

    private func stationSummary(
        caption: String,
        name: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(caption)
                    .font(.system(.caption2, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(name)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(color)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(minWidth: 92, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(caption)：\(name)，點擊選擇車站")
    }

}

private struct StationPickerSheet: View {
    let title: String
    let stations: [Station]
    let selectedStationID: String?
    let onSelect: (Station) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var matchingStations: [Station] {
        guard !searchText.isEmpty else { return stations }
        return stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(matchingStations, id: \Station.id) { (station: Station) in
                    Button {
                        onSelect(station)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            MetroLineBadge(line: station.line, showsLineName: false, compact: true)
                            Text(station.name)
                                .foregroundStyle(.primary)
                            Spacer()
                            if station.id == selectedStationID {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(MetroColor.color(for: station.line))
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "搜尋車站")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview("台北車站到淡水路線試算") {
    let previewState = {
        let state = TravelState.mock
        if let destination = Station.mockNetwork.first(where: { $0.name == "淡水" }) {
            state.updateDestination(destination)
        }
        return state
    }()
    RouteMapView()
        .environmentObject(previewState)
}

#Preview("路線圖・最大輔助使用字級") {
    RouteMapView()
        .environmentObject(TravelState.mock)
        .environment(\.dynamicTypeSize, .accessibility5)
}
