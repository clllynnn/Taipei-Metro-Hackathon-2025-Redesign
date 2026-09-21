import Charts
import SwiftUI

private enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case month = "本月"
    case year = "今年"
    var id: Self { self }
}

struct RidingAnalyticsSection: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ObservedObject var viewModel: AccountViewModel
    let onOpenAllRides: () -> Void
    @State private var selectedPeriod: AnalyticsPeriod = .month
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 150

    private var chartData: [RideChartItem] {
        selectedPeriod == .month ? viewModel.ridingStats.monthlyTrend : viewModel.ridingStats.yearlyTrend
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            sectionTitle("乘車數據")

            VStack(alignment: .leading, spacing: 13) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(selectedPeriod == .month ? "本月搭乘" : "今年累積搭乘")
                            .font(.system(.footnote, weight: .medium))
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text("\(selectedPeriod == .month ? viewModel.ridingStats.monthlyCount : viewModel.ridingStats.yearlyCount)")
                                .font(.system(.title, design: .rounded, weight: .bold))
                            Text("次")
                                .font(.system(.footnote, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    periodPicker
                }

                Chart(chartData) { item in
                    if selectedPeriod == .month {
                        BarMark(
                            x: .value("日期", item.label),
                            y: .value("搭乘次數", item.count)
                        )
                        .foregroundStyle(Color.primaryAction)
                        .cornerRadius(5)
                    } else {
                        AreaMark(
                            x: .value("月份", item.label),
                            y: .value("搭乘次數", item.count)
                        )
                        .foregroundStyle(Color.primaryAction.opacity(0.10))
                        LineMark(
                            x: .value("月份", item.label),
                            y: .value("搭乘次數", item.count)
                        )
                        .foregroundStyle(Color.primaryAction)
                        .lineStyle(StrokeStyle(lineWidth: 2.5))
                        PointMark(
                            x: .value("月份", item.label),
                            y: .value("搭乘次數", item.count)
                        )
                        .foregroundStyle(Color.primaryAction)
                        .symbolSize(20)
                    }
                }
                .chartYAxis { AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) }
                .chartXAxis { AxisMarks { _ in AxisValueLabel().font(.system(.caption2)) } }
                .chartYAxisLabel("次", position: .leading)
                .frame(height: chartHeight)

                HStack(spacing: 8) {
                    insightPill(symbol: "tram.fill", title: "最常搭乘", value: viewModel.ridingStats.topRoute, color: Color.primaryAction)
                    insightPill(symbol: "mappin.and.ellipse", title: "熱門車站", value: viewModel.ridingStats.popularStation, color: Color.communityAccent)
                }
            }
            .accountCardStyle()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("最近搭乘紀錄")
                        .font(.system(.body, weight: .bold))
                    Spacer()
                    Button("查看全部", action: onOpenAllRides)
                        .font(.system(.footnote, weight: .semibold))
                        .foregroundStyle(Color.primaryAction)
                }
                .padding(.bottom, 4)

                ForEach(Array(viewModel.recentRideRecords.enumerated()), id: \.element.id) { index, record in
                    rideRow(record)
                    if index < viewModel.recentRideRecords.count - 1 {
                        Divider().padding(.leading, 46)
                    }
                }
            }
            .accountCardStyle()
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(.title3, design: .rounded, weight: .bold))
            .padding(.horizontal, 2)
    }

    @ViewBuilder
    private var periodPicker: some View {
        if dynamicTypeSize.isAccessibilitySize {
            Picker("統計區間", selection: $selectedPeriod) {
                ForEach(AnalyticsPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        } else {
            Picker("統計區間", selection: $selectedPeriod) {
                ForEach(AnalyticsPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 142)
            .labelsHidden()
        }
    }

    private func insightPill(symbol: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.11), in: Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(.footnote, weight: .medium)).foregroundStyle(.secondary)
                Text(value)
                    .font(.system(.footnote, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func rideRow(_ record: RideRecord) -> some View {
        HStack(spacing: 11) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(accountHex: record.lineColorHex))
                .frame(width: 5, height: 42)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 5) {
                    Text(record.inStation).font(.system(.footnote, weight: .semibold))
                    Image(systemName: "arrow.right").font(.system(size: 9, weight: .bold)).foregroundStyle(.tertiary)
                    Text(record.outStation).font(.system(.footnote, weight: .semibold))
                }
                HStack(spacing: 6) {
                    Text(record.lineName).foregroundStyle(Color(accountHex: record.lineColorHex))
                    Text("·").foregroundStyle(.tertiary)
                    Text(record.timestamp.accountTimestampText).foregroundStyle(.secondary)
                }
                .font(.system(.caption2, weight: .medium))
            }
            Spacer(minLength: 2)
            Text("−NT$\(record.amount)")
                .font(.system(.footnote, design: .rounded, weight: .semibold))
                .monospacedDigit()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    RidingAnalyticsSection(viewModel: AccountViewModel(), onOpenAllRides: {}).padding().background(Color.pageBackground)
}
