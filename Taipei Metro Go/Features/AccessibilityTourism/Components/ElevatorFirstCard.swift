import SwiftUI

struct ElevatorFirstCard: View {
    @Binding var route: ElevatorRouteModel
    @Binding var isElevatorFirst: Bool
    let language: TourismLanguage
    let localizedStation: (String) -> String
    let stationOptions: [String]
    let stationLine: (String) -> MetroLine
    let stationCode: (String) -> String
    let accessibleTransferMinutes: Int
    let totalTravelMinutes: Int
    let luggageMessage: String
    var onPlan: () -> Void
    var onSelectOrigin: (String) -> Void
    var onSelectDestination: (String) -> Void

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Label(TourismHomeCopy.text(.elevatorRoute, language: language), systemImage: "figure.roll")
                        .font(.title3.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.16)) {
                            isElevatorFirst.toggle()
                        }
                        onPlan()
                    } label: {
                        HStack(spacing: 5) {
                            Text(TourismHomeCopy.text(.avoidStairs, language: language))
                                .font(.caption.weight(.bold))
                            Image(systemName: isElevatorFirst ? "checkmark.circle.fill" : "circle")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(isElevatorFirst ? Color.primaryAction : Color.secondaryText)
                        }
                        .foregroundStyle(Color.primaryText)
                        .padding(.horizontal, 9)
                        .frame(minHeight: 40)
                        .background(Color.softSurface, in: Capsule())
                        .overlay(Capsule().stroke(Color.line, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(TourismHomeCopy.text(.avoidStairs, language: language))
                    .accessibilityValue(isElevatorFirst ? "On" : "Off")
                }
                HStack(spacing: 8) {
                    stationMenu(
                        selectedStation: route.originStation,
                        title: stationPickerTitle(isOrigin: true),
                        onSelect: onSelectOrigin
                    )
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.secondaryText)
                    stationMenu(
                        selectedStation: route.destinationStation,
                        title: stationPickerTitle(isOrigin: false),
                        onSelect: onSelectDestination
                    )
                }
                .padding(.vertical, 2)
                HStack(spacing: 8) {
                    metric(
                        title: TourismHomeCopy.text(.transferStation, language: language),
                        value: localizedStation(route.transferStation),
                        detail: accessibleTransferMinutes > 0
                            ? "\(TourismHomeCopy.text(.transfer, language: language)) \(accessibleTransferMinutes) min"
                            : nil
                    )
                    metric(title: TourismHomeCopy.text(.total, language: language), value: "\(totalTravelMinutes) min")
                }
                HStack(spacing: 9) {
                    Image(systemName: "suitcase.rolling.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.primaryAction)
                    Text(luggageMessage)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.primaryText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                .background(Color.softSurface, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accessibilityElement(children: .combine)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .groupBoxStyle(TourismGroupBoxStyle())
    }

    private func stationMenu(
        selectedStation: String,
        title: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        Menu {
            Section(title) {
                ForEach(stationOptions, id: \.self) { station in
                    Button {
                        onSelect(station)
                    } label: {
                        if station == selectedStation {
                            Label(localizedStation(station), systemImage: "checkmark")
                        } else {
                            Text(localizedStation(station))
                        }
                    }
                }
            }
        } label: {
            stationPill(
                localizedStation(selectedStation),
                line: stationLine(selectedStation),
                routeCode: stationCode(selectedStation)
            )
        }
        .accessibilityLabel(title)
        .accessibilityValue(localizedStation(selectedStation))
    }

    private func stationPill(_ name: String, line: MetroLine, routeCode: String) -> some View {
        HStack(spacing: 6) {
            MetroLineBadge(line: line, routeCode: routeCode, showsLineName: false, compact: true)
            Text(name)
                .font(.system(size: language == .traditionalChinese ? 20 : 15, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
            Image(systemName: "chevron.down")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.secondaryText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color(uiColor: .tertiarySystemGroupedBackground), in: Capsule())
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func stationPickerTitle(isOrigin: Bool) -> String {
        switch (language, isOrigin) {
        case (.traditionalChinese, true): "選擇出發站"
        case (.traditionalChinese, false): "選擇目的地"
        case (.english, true): "Choose origin"
        case (.english, false): "Choose destination"
        case (.japanese, true): "出発駅を選択"
        case (.japanese, false): "目的駅を選択"
        case (.korean, true): "출발역 선택"
        case (.korean, false): "도착역 선택"
        }
    }

    private func metric(title: String, value: String, detail: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.primaryText.opacity(0.62))
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Color.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.68)
            if let detail {
                Text(detail)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.primaryAction)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 8)
        .background(Color.secondarySurface, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
    }
}

struct TourismGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(11)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.line, lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
    }
}
