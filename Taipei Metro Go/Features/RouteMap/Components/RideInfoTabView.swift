import SwiftUI

struct RideInfoTabView: View {
    let origin: Station?
    let destination: Station
    let carriageLocation: CarriageLocation?
    let routeEstimate: RouteTimeEstimate?
    let transferArrivalUpdate: TransferArrivalUpdate?
    let transferApproachNotification: TransferApproachNotification?
    let bestEscalatorRecommendation: String
    let transferExitPath: String
    var onDismissTransferNotification: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            journeyCard
            movementCard
        }
    }

    private var journeyCard: some View {
        VStack(alignment: .leading, spacing: 11) {
            sectionTitle("旅途規劃", symbol: "tram.fill")
            HStack(alignment: .center, spacing: 9) {
                stationBadge(origin?.name ?? "起點", caption: "出發", line: origin?.line)
                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.primaryAction)
                stationBadge(destination.name, caption: "目的地", line: destination.line, emphasized: true)
            }

            Text(routeInstruction)
                .font(.system(.footnote, weight: .medium))
                .foregroundStyle(Color.secondaryText)
            HStack(spacing: 8) {
                metricPill("tram.fill", "約 \(routeEstimate?.minutes ?? 0) 分鐘")
                metricPill("arrow.triangle.branch", "轉乘 \(routeEstimate?.transferCount ?? 0) 次")
                metricPill("mappin.and.ellipse", "\(routeEstimate?.stationCount ?? 0) 站")
            }

            if let transferArrivalUpdate {
                transferArrivalCard(transferArrivalUpdate)
            }

            if let transferApproachNotification {
                transferNotificationBanner(transferApproachNotification)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.pageBackground, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private var movementCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("下車與轉乘動線", symbol: "figure.walk")
            Text("依目前車廂位置與月台人流安排")
                .font(.system(.caption2, weight: .medium))
                .foregroundStyle(Color.secondaryText)

            movementStep(
                number: 1,
                title: "目前位置",
                detail: "第\(carriageLocation?.carNumber ?? 4)車廂・第\(carriageLocation?.doorNumber ?? 2)號門"
            )
            movementStep(
                number: 2,
                title: "建議下車位置",
                detail: bestEscalatorRecommendation,
                emphasized: true
            )
            movementStep(
                number: 3,
                title: routeEstimate?.transferCount == 0 ? "出站動線" : "轉乘與出站動線",
                detail: transferExitPath
            )
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private var routeInstruction: String {
        guard let routeEstimate else { return "選擇目的地後顯示搭乘路線" }
        if routeEstimate.transferCount == 0 {
            return "搭乘\(routeEstimate.lineName)，全程直達，不需換線"
        }
        return "搭乘\(routeEstimate.lineName)，途中轉乘 \(routeEstimate.transferCount) 次"
    }

    private func transferArrivalCard(_ update: TransferArrivalUpdate) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "clock.badge.checkmark")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.primaryAction)
                .frame(width: 34, height: 34)
                .background(Color.softSurface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text("\(update.stationName)・\(update.nextLineName)轉乘")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                Text("下一班接續列車約 \(update.countdownText) 到站・距離轉乘站約 \(update.stopsAway) 站")
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Text(update.countdownText)
                .font(.system(.headline, design: .monospaced, weight: .bold))
                .foregroundStyle(Color.primaryAction)
        }
        .padding(10)
        .background(Color.softSurface.opacity(0.72), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityLabel("\(update.stationName)轉乘，\(update.nextLineName)下一班列車\(update.countdownText)到站")
    }

    private func transferNotificationBanner(_ notification: TransferApproachNotification) -> some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.primaryAction)
            VStack(alignment: .leading, spacing: 2) {
                Text("轉乘提醒・\(notification.stationName)")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(Color.primaryText)
                Text(notification.message)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(Color.secondaryText)
            }
            Spacer(minLength: 0)
            Button(action: onDismissTransferNotification) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.secondaryText)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("關閉轉乘提醒")
        }
        .padding(10)
        .background(Color.alertBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.alertBorder, lineWidth: 1))
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func movementStep(
        number: Int,
        title: String,
        detail: String,
        emphasized: Bool = false
    ) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(number)")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(emphasized ? Color.primaryAction : Color.primaryText, in: Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(Color.secondaryText)
                Text(detail)
                    .font(.system(.footnote, weight: emphasized ? .bold : .semibold))
                    .foregroundStyle(emphasized ? Color.primaryAction : Color.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func stationBadge(_ title: String, caption: String, line: MetroLine?, emphasized: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(caption).font(.system(.caption2, weight: .semibold)).foregroundStyle(Color.secondaryText)
            HStack(spacing: 5) {
                if let line {
                    MetroLineBadge(line: line, showsLineName: false, compact: true)
                }
                Text(title)
                    .font(.system(.footnote, weight: .bold))
                    .foregroundStyle(emphasized ? Color.primaryAction : Color.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metricPill(_ symbol: String, _ title: String) -> some View {
        Label(title, systemImage: symbol)
            .font(.system(.caption2, weight: .semibold))
            .foregroundStyle(Color.primaryAction)
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .background(Color.softSurface.opacity(0.7), in: Capsule())
            .fixedSize(horizontal: false, vertical: true)
    }

    private func sectionTitle(_ title: String, symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .font(.system(.subheadline, weight: .bold))
            .foregroundStyle(Color.primaryText)
    }
}
