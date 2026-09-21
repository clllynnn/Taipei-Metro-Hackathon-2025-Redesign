import SwiftUI

/// A compact, high-contrast header inspired by Taipei Metro platform signs.
struct WayfindingHeader<Accessory: View>: View {
    let title: String
    var subtitle: String?
    var symbol: String?
    @ViewBuilder var accessory: () -> Accessory

    init(
        title: String,
        subtitle: String? = nil,
        symbol: String? = nil,
        @ViewBuilder accessory: @escaping () -> Accessory = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.accessory = accessory
    }

    var body: some View {
        HStack(spacing: 12) {
            if let symbol {
                Image(systemName: symbol)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.headline, weight: .bold))
                    .foregroundStyle(.white)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.72))
                }
            }
            Spacer(minLength: 4)
            accessory()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    WayfindingHeader(title: "動態路線圖", subtitle: "點選站點查看搭乘資訊", symbol: "point.topleft.down.curvedto.point.bottomright.up") {
        Image(systemName: "chevron.right")
            .foregroundStyle(.white)
    }
    .padding()
    .background(Color.pageBackground)
}
