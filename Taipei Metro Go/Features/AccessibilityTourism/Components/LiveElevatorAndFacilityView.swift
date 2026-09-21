import SwiftUI

struct LiveElevatorAndFacilityView: View {
    let facility: StationFacilityInfoModel
    let language: TourismLanguage

    private var isOperating: Bool { facility.elevatorStatus == .operating }
    private var statusColor: Color { isOperating ? TourismPalette.statusSuccess : TourismPalette.statusSecondary }
    private var crowdingTitle: String {
        let key: TourismCopy.Key
        switch facility.crowdingPrediction {
        case .comfortable: key = .comfortable
        case .moderate: key = .moderate
        case .busy: key = .busy
        }
        return TourismCopy.text(key, language: language)
    }
    private var luggageCarsTitle: String {
        let separator = language == .english ? " & " : "・"
        let cars = facility.luggageFriendlyCars.map(String.init).joined(separator: separator)
        return switch language {
        case .traditionalChinese: "第 \(cars) 車廂"
        case .english: "Cars \(cars)"
        case .japanese: "\(cars)号車"
        case .korean: "\(cars)호차"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "door.left.hand.open")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(TourismPalette.navy, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(TourismCopy.text(.facilities, language: language))
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(TourismPalette.text)
                    Text(facility.stationName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(TourismPalette.secondary)
                }
                Spacer(minLength: 0)
            }

            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isOperating ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(statusColor)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 5) {
                    Text(TourismCopy.text(.elevatorStatus, language: language))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(TourismPalette.text)
                    Text(TourismCopy.text(isOperating ? .operating : .maintenanceWarning, language: language))
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(statusColor)
                    Text(facility.elevatorStatusMessage)
                        .font(.subheadline)
                        .foregroundStyle(TourismPalette.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            HStack(spacing: 10) {
                facilityTile(
                    symbol: "figure.roll",
                    title: TourismCopy.text(.exit, language: language),
                    value: facility.elevatorExitNumber
                )
                facilityTile(
                    symbol: "suitcase.rolling.fill",
                    title: TourismCopy.text(.luggageSpace, language: language),
                    value: luggageCarsTitle
                )
            }

            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(TourismPalette.action)
                Text(TourismCopy.text(.crowding, language: language))
                    .foregroundStyle(TourismPalette.secondary)
                Spacer()
                Text(crowdingTitle)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(TourismPalette.navy)
            }
            .font(.subheadline.weight(.semibold))

            Text(facility.luggageSpaceMessage)
                .font(.footnote)
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(TourismPalette.line, lineWidth: 1))
    }

    private func facilityTile(symbol: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .foregroundStyle(TourismPalette.action)
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Text(value)
                .font(.headline.weight(.heavy))
                .foregroundStyle(TourismPalette.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .padding(12)
        .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    LiveElevatorAndFacilityView(
        facility: StationFacilityInfoModel(
            stationName: "台北車站",
            elevatorStatus: .operating,
            elevatorStatusMessage: "All station elevators are operating normally.",
            elevatorExitNumber: "M7",
            luggageFriendlyCars: [1, 6],
            crowdingPrediction: .comfortable,
            luggageSpaceMessage: "Cars 1 and 6 have more open space for large luggage."
        ),
        language: .english
    )
    .padding()
    .background(TourismPalette.canvas)
}
