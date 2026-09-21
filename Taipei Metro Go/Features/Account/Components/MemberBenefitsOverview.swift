import SwiftUI

/// The three high-level member benefits presented as one concise horizontal summary.
struct MemberBenefitsOverview: View {
    @ObservedObject var viewModel: AccountViewModel

    @ScaledMetric(relativeTo: .body) private var cardWidth: CGFloat = 150

    private var totalCO2: Double {
        viewModel.carbonBadges.first?.currentCO2 ?? 0
    }

    private var unlockedBadgeCount: Int {
        viewModel.carbonBadges.filter(\.isUnlocked).count
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                summaryCard(
                    title: "會員回饋",
                    value: "NT$\(viewModel.rewardInfo.availableCashback)",
                    detail: "本月 \(viewModel.rewardInfo.currentMonthCount) 次",
                    symbol: "gift.fill",
                    tint: Color.rewardsAccent,
                    surface: Color.rewardsSurface
                )

                summaryCard(
                    title: "減碳徽章",
                    value: totalCO2.formatted(.number.precision(.fractionLength(1))) + " kg",
                    detail: "已解鎖 \(unlockedBadgeCount) 枚",
                    symbol: "leaf.fill",
                    tint: Color.statusSuccess,
                    surface: Color.statusSuccess.opacity(0.12)
                )

                summaryCard(
                    title: "捷運點",
                    value: "\(viewModel.pointsInfo.currentPoints) 點",
                    detail: "累積點數",
                    symbol: "sparkles",
                    tint: Color.primaryAction,
                    surface: Color.softSurface
                )
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 2)
        }
        .accessibilityLabel("會員回饋、減碳徽章與捷運點摘要")
    }

    private func summaryCard(
        title: String,
        value: String,
        detail: String,
        symbol: String,
        tint: Color,
        surface: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 38, height: 38)
                .background(surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.footnote, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                Text(detail)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(14)
        .frame(width: cardWidth, height: 164, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    MemberBenefitsOverview(viewModel: AccountViewModel())
        .padding()
        .background(Color.pageBackground)
}
