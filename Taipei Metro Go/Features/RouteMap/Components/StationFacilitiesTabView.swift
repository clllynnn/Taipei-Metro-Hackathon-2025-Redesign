import SwiftUI

struct StationFacilitiesTabView: View {
    let station: Station

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("依出口查看設施")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                Text("選擇出口，快速找到站內服務")
                    .font(.system(.footnote, weight: .medium))
                    .foregroundStyle(Color.secondaryText)
            }

            ForEach(station.exitGuides) { guide in
                VStack(alignment: .leading, spacing: 10) {
                    Text(exitTitle(for: guide))
                        .font(.system(.footnote, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 8)
                        .background(.black, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                        .accessibilityLabel(exitTitle(for: guide))

                    Text(guide.guidance)
                        .font(.system(.caption2, weight: .medium))
                        .foregroundStyle(Color.secondaryText)

                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
                        ForEach(guide.facilities, id: \.self) { facility in
                            GridRow {
                                HStack(spacing: 8) {
                                    Image(systemName: facility.symbol)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Color.primaryText)
                                        .frame(width: 24, height: 24)
                                        .background(Color.softSurface.opacity(0.75), in: RoundedRectangle(cornerRadius: 7))
                                    Text(facility.title)
                                        .font(.system(.footnote, weight: .semibold))
                                        .foregroundStyle(Color.primaryText)
                                }
                                Text(detail(for: facility))
                                    .font(.system(.caption2, weight: .medium))
                                    .foregroundStyle(Color.secondaryText)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .gridColumnAlignment(.trailing)
                            }
                        }
                    }
                }
                .padding(14)
                .background(Color.pageBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }

    private func detail(for facility: StationFacilityKind) -> String {
        switch facility {
        case .restroom: "近月台層與大廳"
        case .escalator: "往主要出口方向"
        case .elevator: "無障礙電梯可直達月台"
        case .serviceDesk: "大廳層・服務時間 06:00–24:00"
        case .wayfinding: "月台與通道皆有方向指引"
        }
    }

    private func exitTitle(for guide: StationExitGuide) -> String {
        let prefix = guide.name
            .split(separator: "／", maxSplits: 1)
            .first
            .map(String.init) ?? guide.name
        return prefix.contains("出口") ? prefix : "\(prefix) 出口"
    }
}
