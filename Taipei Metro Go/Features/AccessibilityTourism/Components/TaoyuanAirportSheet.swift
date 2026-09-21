import SwiftUI

struct TaoyuanAirportSheet: View {
    let language: TourismLanguage

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Label(a1Title, systemImage: "tram.fill")
                    .font(.title2.weight(.bold))
                step(number: "1", title: "前往 A1 台北車站預辦登機區", detail: "依照 Airport MRT 指標前往 A1 站市民大道側服務櫃台。")
                step(number: "2", title: "確認航空公司與班機", detail: "完成報到、行李託運後，保留行李收據與 QR 車票。")
                step(number: "3", title: "輕裝前往機場", detail: "使用 Airport MRT 直達桃園機場，抵達後依指示入境安檢。")
                Spacer()
            }
            .padding(20)
            .navigationTitle(TourismHomeCopy.text(.airport, language: language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func step(number: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.headline.weight(.heavy))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Color.primaryAction, in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline.weight(.bold))
                Text(detail).font(.subheadline).foregroundStyle(Color.secondaryText)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var a1Title: String {
        switch language {
        case .traditionalChinese: "A1 台北車站"
        case .english: "A1 Taipei Main Station"
        case .japanese: "A1 台北駅"
        case .korean: "A1 타이베이 메인역"
        }
    }
}
