import SwiftUI

struct TransferInfoTabView: View {
    let station: Station
    let transferExitPath: String

    private var connections: [(String, String, String, String)] {
        if station.name == "台北車站" {
            return [
                ("台鐵 TRA", "train.side.front.car", "站內連通・約 5 分鐘", "TRA"),
                ("高鐵 THSR", "tram.fill", "站內連通・約 7 分鐘", "THSR"),
                ("市區公車", "bus.fill", "M4 出口步行約 3 分鐘", "BUS")
            ]
        }
        if station.name == "板橋" {
            return [
                ("台鐵 TRA", "train.side.front.car", "由 3 號出口前往板橋車站・約 4 分鐘", "TRA"),
                ("高鐵 THSR", "tram.fill", "由 3 號出口前往高鐵大廳・約 5 分鐘", "THSR"),
                ("市區公車", "bus.fill", "由 3 號出口前往公車轉運站・約 3 分鐘", "BUS")
            ]
        }
        if station.name == "南港" {
            return [
                ("台鐵 TRA", "train.side.front.car", "由 1 號出口沿連通道前往・約 5 分鐘", "TRA"),
                ("高鐵 THSR", "tram.fill", "由 1 號出口沿連通道前往・約 6 分鐘", "THSR"),
                ("市區公車", "bus.fill", "由 2 號出口前往南港轉運站・約 4 分鐘", "BUS")
            ]
        }
        if station.lines.count > 1 {
            let lines = station.lines.map(\.rawValue).joined(separator: "／")
            return [
                ("捷運轉乘", "arrow.triangle.branch", "站內轉乘 \(lines) 線・依指標前往", "MRT"),
                ("市區公車", "bus.fill", "建議由\(station.exitInfo.first ?? "1 號出口")出站", "BUS"),
                ("台鐵／高鐵", "train.side.front.car", "可經台北車站轉乘・約 12 分鐘", "RAIL")
            ]
        }
        return [
            ("市區公車", "bus.fill", "建議由\(station.exitInfo.first ?? "1 號出口")出站", "BUS"),
            ("台鐵 TRA", "train.side.front.car", "可轉乘台北車站・約 12 分鐘", "TRA"),
            ("高鐵 THSR", "tram.fill", "可轉乘台北車站・約 14 分鐘", "THSR")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            VStack(alignment: .leading, spacing: 5) {
                Text("跨運具轉乘")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                Text("整合公車、台鐵與高鐵的接續資訊")
                    .font(.system(.footnote, weight: .medium))
                    .foregroundStyle(Color.secondaryText)
            }

            ForEach(connections, id: \.3) { title, symbol, detail, badge in
                HStack(spacing: 10) {
                    Image(systemName: symbol)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.primaryAction)
                        .frame(width: 38, height: 38)
                        .background(Color.softSurface, in: RoundedRectangle(cornerRadius: 11))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title).font(.system(.caption2, weight: .bold)).foregroundStyle(Color.primaryText)
                        Text(detail).font(.system(.footnote, weight: .medium)).foregroundStyle(Color.secondaryText)
                    }
                    Spacer()
                    Text(badge)
                        .font(.system(.caption2, weight: .heavy))
                        .foregroundStyle(Color.primaryAction)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(Color.softSurface, in: Capsule())
                }
                .padding(10)
                .background(Color.pageBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            HStack(alignment: .top, spacing: 9) {
                Image(systemName: "figure.walk.motion")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.statusSuccess)
                VStack(alignment: .leading, spacing: 4) {
                    Text("最有效率的出站路徑")
                        .font(.system(.footnote, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                    Text(transferExitPath)
                        .font(.system(.footnote, weight: .medium))
                        .foregroundStyle(Color.secondaryText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.statusSuccess.opacity(0.09), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}
