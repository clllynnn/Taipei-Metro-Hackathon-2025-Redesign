import Combine
import Foundation

@MainActor
final class AccountViewModel: ObservableObject {
    @Published var userProfile: AccountUserProfile
    @Published var ridingStats: RidingStats
    @Published var recentRideRecords: [RideRecord]
    @Published var rewardInfo: FrequentRiderReward
    @Published var pointsInfo: MetroPointsInfo
    @Published var carbonBadges: [CarbonBadge]
    @Published var notificationSettings: PushNotificationSettings
    @Published var showLogoutAlert = false
    @Published private(set) var didLogout = false

    init() {
        let calendar = Calendar.current
        let today = Date()
        let date = { (daysAgo: Int) in
            calendar.date(byAdding: .day, value: -daysAgo, to: today) ?? today
        }

        userProfile = AccountUserProfile(
            name: "林怡君",
            accountID: "帳號 08•• ••42",
            avatarSystemName: "person.crop.circle.fill"
        )

        ridingStats = RidingStats(
            monthlyCount: 21,
            yearlyCount: 211,
            topRoute: "板南線",
            popularStation: "台北車站",
            previousMonthCount: 28,
            monthlyTrend: [
                RideChartItem(label: "第1週", count: 7), RideChartItem(label: "第2週", count: 8),
                RideChartItem(label: "第3週", count: 6)
            ],
            yearlyTrend: [
                RideChartItem(label: "1月", count: 20), RideChartItem(label: "2月", count: 18),
                RideChartItem(label: "3月", count: 25), RideChartItem(label: "4月", count: 22),
                RideChartItem(label: "5月", count: 27), RideChartItem(label: "6月", count: 24),
                RideChartItem(label: "7月", count: 26), RideChartItem(label: "8月", count: 28),
                RideChartItem(label: "9月", count: 21)
            ]
        )

        recentRideRecords = [
            RideRecord(timestamp: date(0), inStation: "市政府", outStation: "台北車站", amount: 20, lineName: "板南線", lineColorHex: "0070BD"),
            RideRecord(timestamp: date(1), inStation: "忠孝復興", outStation: "市政府", amount: 20, lineName: "板南線", lineColorHex: "0070BD"),
            RideRecord(timestamp: date(2), inStation: "大安", outStation: "忠孝復興", amount: 20, lineName: "文湖線", lineColorHex: "C48C31"),
            RideRecord(timestamp: date(3), inStation: "台北車站", outStation: "中山", amount: 20, lineName: "淡水信義線", lineColorHex: "E3002C")
        ]

        rewardInfo = FrequentRiderReward(
            currentMonthCount: 21,
            availableCashback: 120,
            expiryDate: calendar.date(byAdding: .day, value: 12, to: today) ?? today
        )
        pointsInfo = MetroPointsInfo(
            currentPoints: 1_280,
            pointsExpiryDate: calendar.date(byAdding: .day, value: 45, to: today) ?? today,
            history: [
                PointHistoryItem(title: "搭乘捷運累點", date: date(1), points: 12),
                PointHistoryItem(title: "每日簽到獎勵", date: date(2), points: 10),
                PointHistoryItem(title: "點數折抵車資", date: date(5), points: -30)
            ]
        )
        carbonBadges = [
            CarbonBadge(title: "綠色通勤達人", requiredCO2: 30, currentCO2: 128.4, isUnlocked: true, iconName: "leaf.fill"),
            CarbonBadge(title: "減碳百里捷人", requiredCO2: 100, currentCO2: 128.4, isUnlocked: true, iconName: "tram.fill"),
            CarbonBadge(title: "捷運綠色先鋒", requiredCO2: 200, currentCO2: 128.4, isUnlocked: false, iconName: "sparkles")
        ]
        notificationSettings = PushNotificationSettings(
            isServiceAlertEnabled: true,
            isPersonalizedLineEnabled: true,
            isExpiryReminderEnabled: true,
            isMarketingEnabled: false
        )
    }

    func performLogout() {
        userProfile = .guest
        didLogout = true
    }

    func toggleNotificationSetting(_ preference: NotificationPreference, isOn: Bool) {
        switch preference {
        case .serviceAlert: notificationSettings.isServiceAlertEnabled = isOn
        case .personalizedLine: notificationSettings.isPersonalizedLineEnabled = isOn
        case .expiryReminder: notificationSettings.isExpiryReminderEnabled = isOn
        case .marketing: notificationSettings.isMarketingEnabled = isOn
        }
    }

    func isNotificationEnabled(_ preference: NotificationPreference) -> Bool {
        switch preference {
        case .serviceAlert: notificationSettings.isServiceAlertEnabled
        case .personalizedLine: notificationSettings.isPersonalizedLineEnabled
        case .expiryReminder: notificationSettings.isExpiryReminderEnabled
        case .marketing: notificationSettings.isMarketingEnabled
        }
    }
}
