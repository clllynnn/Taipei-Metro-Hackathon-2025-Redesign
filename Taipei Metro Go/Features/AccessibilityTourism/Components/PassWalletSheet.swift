import SwiftUI

struct PassWalletSheet: View {
    let language: TourismLanguage
    let qrTicketCount: Int
    var onSelectPass: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Taipei Pass / Fun Pass")
                    .font(.title2.weight(.bold))
                HStack(spacing: 14) {
                    qrCard(title: "Taipei Pass", code: "TP-101")
                    qrCard(title: "QR Ticket ×\(qrTicketCount)", code: "QR-2026")
                }
                GroupBox("特約景點折扣") {
                    VStack(alignment: .leading, spacing: 9) {
                        Label(discountOne, systemImage: "checkmark.seal.fill")
                        Label(discountTwo, systemImage: "checkmark.seal.fill")
                    }
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Button("加入 Taipei Pass") { onSelectPass("Taipei Pass") }
                        .buttonStyle(.borderedProminent)
                    Button("加入 Fun Pass") { onSelectPass("Fun Pass") }
                        .buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding(20)
            .navigationTitle("\(TourismHomeCopy.text(.passWallet, language: language))")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func qrCard(title: String, code: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "qrcode")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(Color.primaryText)
            Text(title).font(.caption.weight(.bold)).lineLimit(1).minimumScaleFactor(0.7)
            Text(code).font(.caption2.monospaced()).foregroundStyle(Color.secondaryText)
        }
        .frame(maxWidth: .infinity, minHeight: 145)
        .background(Color.secondarySurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var discountOne: String {
        switch language {
        case .traditionalChinese: "台北 101 觀景台 9 折"
        case .english: "Taipei 101 Observatory 10% off"
        case .japanese: "台北101展望台 10%割引"
        case .korean: "타이베이 101 전망대 10% 할인"
        }
    }

    private var discountTwo: String {
        switch language {
        case .traditionalChinese: "故宮博物院與捷運聯票優惠"
        case .english: "National Palace Museum metro combo"
        case .japanese: "故宮博物院とMRTセット割引"
        case .korean: "고궁박물관 MRT 연계 할인"
        }
    }
}
