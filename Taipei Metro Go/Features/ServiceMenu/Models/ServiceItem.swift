import Foundation

struct ServiceItem: Identifiable, Equatable {
    let id: String
    let name: String
    let category: ServiceCategory
    let iconName: String
    let description: String
    let isDynamicShortcut: Bool

    init(
        id: String,
        name: String,
        category: ServiceCategory,
        iconName: String,
        description: String,
        isDynamicShortcut: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.iconName = iconName
        self.description = description
        self.isDynamicShortcut = isDynamicShortcut
    }
}

enum ServiceCategory: String, CaseIterable, Identifiable {
    case instantInfo
    case commuterTools
    case memberCard
    case lifestyleMap

    var id: String { rawValue }

    var title: String {
        switch self {
        case .instantInfo: "即時乘車資訊"
        case .commuterTools: "貼心與通勤輔助"
        case .memberCard: "會員與票卡服務"
        case .lifestyleMap: "周邊生活與地圖"
        }
    }

    var subtitle: String {
        switch self {
        case .instantInfo: "到站時間、路線狀況與列車動態"
        case .commuterTools: "提醒、協尋與旅遊票券服務"
        case .memberCard: "票卡、常客回饋、減碳紀錄與優惠"
        case .lifestyleMap: "探索捷運沿線美食、景點與生活設施"
        }
    }

    var iconName: String {
        switch self {
        case .instantInfo: "tram.fill"
        case .commuterTools: "bell.badge.fill"
        case .memberCard: "creditcard.fill"
        case .lifestyleMap: "map.fill"
        }
    }
}

enum ServiceMenuLayout {
    static let cardHeight: CGFloat = 78
}
