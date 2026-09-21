import SwiftUI

struct LockerInfoSheet: View {
    let language: TourismLanguage
    let station: String
    let locker: LockerInfoModel?
    var onSelectStation: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(localized(station)) · \(language == .traditionalChinese ? "即時空位" : language == .english ? "Live spaces" : language == .japanese ? "空き状況" : "실시간 여유")")
                    .font(.title3.weight(.bold))
                if let locker {
                    HStack(spacing: 8) {
                        countCard("大", locker.largeLockerCount, "suitcase.rolling.fill")
                        countCard("中", locker.mediumLockerCount, "suitcase.fill")
                        countCard("小", locker.smallLockerCount, "bag.fill")
                    }
                    Label(locker.locationNavigation, systemImage: "map.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Picker("站點", selection: Binding(get: { station }, set: onSelectStation)) {
                    Text(localized("台北車站")).tag("台北車站")
                    Text(localized("西門站")).tag("西門站")
                    Text(localized("市政府站")).tag("市政府站")
                }
                .pickerStyle(.menu)
                Spacer()
            }
            .padding(20)
            .navigationTitle(TourismHomeCopy.text(.locker, language: language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func countCard(_ title: String, _ value: Int, _ symbol: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: symbol).foregroundStyle(Color.primaryAction)
            Text(title).font(.caption.weight(.bold))
            Text("\(value)").font(.title2.weight(.heavy).monospacedDigit())
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.secondarySurface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func localized(_ station: String) -> String {
        switch (station, language) {
        case ("台北車站", .traditionalChinese): "台北車站"
        case ("台北車站", .english): "Taipei Main Station"
        case ("台北車站", .japanese): "台北駅"
        case ("台北車站", .korean): "타이베이 메인역"
        case ("西門站", .traditionalChinese): "西門站"
        case ("西門站", .english): "Ximen Station"
        case ("西門站", .japanese): "西門駅"
        case ("西門站", .korean): "시먼역"
        case ("市政府站", .traditionalChinese): "市政府站"
        case ("市政府站", .english): "Taipei City Hall"
        case ("市政府站", .japanese): "市政府駅"
        case ("市政府站", .korean): "시정부역"
        default: station
        }
    }
}
