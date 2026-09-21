import Foundation

struct RideRecord: Identifiable {
    let id: UUID
    let timestamp: Date
    let inStation: String
    let outStation: String
    let amount: Int
    let lineName: String
    let lineColorHex: String

    init(
        id: UUID = UUID(),
        timestamp: Date,
        inStation: String,
        outStation: String,
        amount: Int,
        lineName: String,
        lineColorHex: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.inStation = inStation
        self.outStation = outStation
        self.amount = amount
        self.lineName = lineName
        self.lineColorHex = lineColorHex
    }
}

struct RidingStats {
    let monthlyCount: Int
    let yearlyCount: Int
    let topRoute: String
    let popularStation: String
    let previousMonthCount: Int
    let monthlyTrend: [RideChartItem]
    let yearlyTrend: [RideChartItem]
}

struct RideChartItem: Identifiable {
    let id = UUID()
    let label: String
    let count: Int
}

struct FrequentRiderReward {
    let currentMonthCount: Int
    let availableCashback: Int
    let expiryDate: Date
}

struct MetroPointsInfo {
    var currentPoints: Int
    let pointsExpiryDate: Date
    let history: [PointHistoryItem]
}

struct PointHistoryItem: Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let points: Int

    init(id: UUID = UUID(), title: String, date: Date, points: Int) {
        self.id = id
        self.title = title
        self.date = date
        self.points = points
    }
}

struct CarbonBadge: Identifiable {
    let id: UUID
    let title: String
    let requiredCO2: Double
    let currentCO2: Double
    let isUnlocked: Bool
    let iconName: String

    init(
        id: UUID = UUID(),
        title: String,
        requiredCO2: Double,
        currentCO2: Double,
        isUnlocked: Bool,
        iconName: String
    ) {
        self.id = id
        self.title = title
        self.requiredCO2 = requiredCO2
        self.currentCO2 = currentCO2
        self.isUnlocked = isUnlocked
        self.iconName = iconName
    }
}

struct PushNotificationSettings {
    var isServiceAlertEnabled: Bool
    var isPersonalizedLineEnabled: Bool
    var isExpiryReminderEnabled: Bool
    var isMarketingEnabled: Bool
}

struct AccountUserProfile {
    let name: String
    let accountID: String
    let avatarSystemName: String

    static let guest = AccountUserProfile(
        name: "訪客",
        accountID: "",
        avatarSystemName: "person.crop.circle.fill"
    )
}

enum NotificationPreference: CaseIterable, Identifiable {
    case serviceAlert
    case personalizedLine
    case expiryReminder
    case marketing

    var id: Self { self }

    var title: String {
        switch self {
        case .serviceAlert: "捷運營運異動即時通知"
        case .personalizedLine: "常用路線個人化推播"
        case .expiryReminder: "點數與回饋到期提醒"
        case .marketing: "優惠行銷訊息"
        }
    }

    var subtitle: String {
        switch self {
        case .serviceAlert: "列車延誤、路線異動與車站公告"
        case .personalizedLine: "板南線等常用路線的乘車資訊"
        case .expiryReminder: "在點數或回饋即將到期前提醒你"
        case .marketing: "新活動、票券與會員專屬優惠"
        }
    }
}
