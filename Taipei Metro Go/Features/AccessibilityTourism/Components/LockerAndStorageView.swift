import SwiftUI

struct LockerAndStorageView: View {
    let lockers: [LockerInfoModel]
    @Binding var selectedStation: String
    let language: TourismLanguage
    let navigationMessage: String?
    var onOpenDirections: () -> Void

    private var selectedLocker: LockerInfoModel? {
        lockers.first { $0.stationName == selectedStation }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: "luggage.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(TourismPalette.action, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(TourismCopy.text(.lockers, language: language))
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(TourismPalette.text)
                    Text(TourismCopy.text(.demoData, language: language))
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(TourismPalette.secondary)
                }
                Spacer(minLength: 0)
            }

            Picker(TourismCopy.text(.from, language: language), selection: $selectedStation) {
                ForEach(lockers) { locker in
                    Text(locker.stationName).tag(locker.stationName)
                }
            }
            .pickerStyle(.menu)
            .font(.headline.weight(.bold))
            .tint(TourismPalette.navy)
            .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
            .padding(.horizontal, 14)
            .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .accessibilityLabel("\(TourismCopy.text(.lockers, language: language)): \(selectedStation)")
            .accessibilityHint("Choose a station to check locker availability")

            if let selectedLocker {
                HStack(spacing: 9) {
                    lockerCount(title: TourismCopy.text(.large, language: language), count: selectedLocker.largeLockerCount, symbol: "suitcase.rolling.fill")
                    lockerCount(title: TourismCopy.text(.medium, language: language), count: selectedLocker.mediumLockerCount, symbol: "suitcase.fill")
                    lockerCount(title: TourismCopy.text(.small, language: language), count: selectedLocker.smallLockerCount, symbol: "bag.fill")
                }

                HStack(spacing: 8) {
                    Image(systemName: selectedLocker.supportsHandCarryService ? "checkmark.circle.fill" : "info.circle.fill")
                        .foregroundStyle(selectedLocker.supportsHandCarryService ? TourismPalette.statusSuccess : TourismPalette.action)
                    Text(TourismCopy.text(.handCarry, language: language))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(TourismPalette.text)
                    Spacer()
                    Text(TourismCopy.text(selectedLocker.supportsHandCarryService ? .available : .unavailable, language: language))
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(selectedLocker.supportsHandCarryService ? TourismPalette.statusSuccess : TourismPalette.secondary)
                }
                .font(.subheadline)

                Button(action: onOpenDirections) {
                    Label(TourismCopy.text(.openDirections, language: language), systemImage: "location.north.line.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .foregroundStyle(TourismPalette.action)
                        .background(TourismPalette.paleSurface, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityHint("Show accessible directions to the selected station lockers")
            }

            if let navigationMessage {
                Label(navigationMessage, systemImage: "signpost.right.fill")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(TourismPalette.text)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(TourismPalette.line, lineWidth: 1))
        .animation(.easeInOut(duration: 0.2), value: selectedStation)
    }

    private func lockerCount(title: String, count: Int, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: symbol)
                .font(.headline.weight(.semibold))
                .foregroundStyle(TourismPalette.action)
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(count)")
                .font(.title2.weight(.heavy).monospacedDigit())
                .foregroundStyle(TourismPalette.navy)
            Text(TourismCopy.text(.lockersAvailable, language: language))
                .font(.footnote.weight(.medium))
                .foregroundStyle(TourismPalette.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 106, alignment: .leading)
        .padding(11)
        .background(TourismPalette.canvas, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    @Previewable @State var station = "台北車站"
    LockerAndStorageView(
        lockers: [
            LockerInfoModel(stationName: "台北車站", largeLockerCount: 12, mediumLockerCount: 28, smallLockerCount: 46, supportsHandCarryService: true, locationNavigation: "Near East 3 passage"),
            LockerInfoModel(stationName: "西門站", largeLockerCount: 4, mediumLockerCount: 16, smallLockerCount: 31, supportsHandCarryService: false, locationNavigation: "Beside Exit 6")
        ],
        selectedStation: $station,
        language: .english,
        navigationMessage: nil,
        onOpenDirections: {}
    )
    .padding()
    .background(TourismPalette.canvas)
}
