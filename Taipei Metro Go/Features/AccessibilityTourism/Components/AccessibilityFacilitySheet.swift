import SwiftUI

struct AccessibilityFacilitySheet: View {
    let sheet: AccessibilitySheet
    let contrastMode: HighContrastMode
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                switch sheet {
                case .passWallet:
                    Label("觀光 Pass & 票券錢包", systemImage: "ticket.fill")
                        .font(.title2.weight(.heavy))
                    detailRow("Taipei Pass", "掃碼進站，搭配景點優惠", "qrcode")
                    detailRow("Fun Pass", "景點與交通一日票", "sparkles")
                    detailRow("QR 車票", "可直接出示 QR Code", "qrcode.viewfinder")
                case .lockerInfo:
                    Label("Locker 寄物櫃與托運", systemImage: "shippingbox.fill")
                        .font(.title2.weight(.heavy))
                    detailRow("大型寄物櫃", "台北車站剩餘 12 格", "suitcase.rolling.fill")
                    detailRow("中型寄物櫃", "台北車站剩餘 28 格", "suitcase.fill")
                    detailRow("無障礙出口", "電梯出口 M7，手托運中心在站務中心旁", "figure.roll")
                }
                Spacer()
            }
            .foregroundStyle(contrastMode.foregroundColor)
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(contrastMode.backgroundColor.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成", action: onDismiss)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(contrastMode.accentColor)
                        .frame(minWidth: 56, minHeight: 56)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func detailRow(_ title: String, _ detail: String, _ symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.title2.weight(.bold))
                .foregroundStyle(contrastMode.accentColor)
                .frame(width: 42, height: 42)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline.weight(.heavy))
                Text(detail).font(.body.weight(.medium)).foregroundStyle(contrastMode.secondaryColor)
            }
            Spacer()
        }
        .padding(12)
        .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(contrastMode.borderColor, lineWidth: 1))
    }
}
