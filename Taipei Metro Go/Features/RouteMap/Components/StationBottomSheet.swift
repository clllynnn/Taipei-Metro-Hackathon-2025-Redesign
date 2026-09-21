import SwiftUI

struct StationBottomSheet: View {
    @ObservedObject var viewModel: RouteMapViewModel
    let station: Station
    let isCurrentDestination: Bool
    var onSetDestination: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                HStack(spacing: 7) {
                    ForEach(station.lines, id: \.self) { line in
                        MetroLineBadge(line: line, showsLineName: false, compact: true)
                    }
                    Text(station.name)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                }
                Spacer()
                Button {
                    viewModel.cancelStationSelection()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.secondaryText)
                        .frame(minWidth: 44, minHeight: 44)
                        .background(Color.pageBackground, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("關閉車站資訊")
            }
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .padding(.bottom, 15)

            HStack(spacing: 0) {
                ForEach(StationInfoTab.allCases) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) { viewModel.activeTab = tab }
                    } label: {
                        VStack(spacing: 9) {
                            Text(tab.title)
                                .font(.system(.caption2, weight: viewModel.activeTab == tab ? .bold : .medium))
                                .foregroundStyle(viewModel.activeTab == tab ? Color.primaryAction : Color.secondaryText)
                            Capsule()
                                .fill(viewModel.activeTab == tab ? Color.primaryAction : .clear)
                                .frame(height: 2)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .overlay(alignment: .bottom) { Rectangle().fill(Color.line).frame(height: 1) }

            ScrollView(showsIndicators: false) {
                Group {
                    switch viewModel.activeTab {
                    case .rideInfo:
                        RideInfoTabView(
                            origin: viewModel.userCurrentStation,
                            destination: station,
                            carriageLocation: viewModel.userCarriageLocation,
                            routeEstimate: viewModel.bestRouteEstimate,
                            transferArrivalUpdate: viewModel.transferArrivalUpdate,
                            transferApproachNotification: viewModel.transferApproachNotification,
                            bestEscalatorRecommendation: viewModel.bestEscalatorRecommendation,
                            transferExitPath: viewModel.transferExitPath,
                            onDismissTransferNotification: viewModel.dismissTransferApproachNotification
                        )
                    case .stationFacilities:
                        StationFacilitiesTabView(station: station)
                    case .transferInfo:
                        TransferInfoTabView(station: station, transferExitPath: viewModel.transferExitPath)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
                .padding(.bottom, 26)
            }
            .frame(maxWidth: .infinity)

            Button(action: onSetDestination) {
                Label(isCurrentDestination ? "已設為目的地" : "設定為目的地", systemImage: isCurrentDestination ? "checkmark.circle.fill" : "mappin.and.ellipse")
                    .font(.system(.footnote, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 46)
                    .background(isCurrentDestination ? Color.statusSuccess : Color.primaryAction, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(isCurrentDestination)
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        .background(Color(uiColor: .systemBackground))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(26)
    }

}
