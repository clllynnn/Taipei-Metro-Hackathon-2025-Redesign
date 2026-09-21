import Combine
import Foundation

@MainActor
final class ServiceMenuViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var dynamicShortcuts: [ServiceItem]
    @Published var allServices: [ServiceItem]
    @Published private(set) var recommendationLabel: String

    var filteredServices: [ServiceItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allServices }

        return allServices.filter { service in
            service.name.localizedCaseInsensitiveContains(query)
                || service.description.localizedCaseInsensitiveContains(query)
                || service.category.title.localizedCaseInsensitiveContains(query)
        }
    }

    init() {
        allServices = Self.serviceCatalog
        dynamicShortcuts = []
        recommendationLabel = "即時乘車推薦"
        refreshDynamicShortcuts()
    }

    func refreshDynamicShortcuts(at date: Date = Date()) {
        let recommendation = Self.recommendation(for: date)
        let shortcutIDs = Set(recommendation.ids)

        allServices = Self.serviceCatalog.map { service in
            ServiceItem(
                id: service.id,
                name: service.name,
                category: service.category,
                iconName: service.iconName,
                description: service.description,
                isDynamicShortcut: shortcutIDs.contains(service.id)
            )
        }
        dynamicShortcuts = recommendation.ids.compactMap { id in
            allServices.first(where: { $0.id == id })
        }
        recommendationLabel = recommendation.title
    }

    private static func recommendation(for date: Date) -> (title: String, ids: [String]) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        if calendar.isDateInWeekend(date), (7..<20).contains(hour) {
            return (
                "假日休閒推薦",
                ["go-map", "tourist-fun", "cable-car-tickets", "tourist-pass-deals"]
            )
        }

        if (6..<10).contains(hour) || (16..<20).contains(hour) {
            return (
                "通勤高峰推薦",
                ["train-arrivals", "line-crowding", "alight-reminder", "meetup-train"]
            )
        }

        return (
            "即時乘車推薦",
            ["train-arrivals", "dynamic-info", "line-crowding", "delay-certificate"]
        )
    }

    private static let serviceCatalog: [ServiceItem] = [
        ServiceItem(
            id: "train-arrivals",
            name: "列車到站時刻",
            category: .instantInfo,
            iconName: "clock.arrow.circlepath",
            description: "查看各站列車到站時間、發車資訊與末班車時刻"
        ),
        ServiceItem(
            id: "line-crowding",
            name: "列車／路線擁擠度",
            category: .instantInfo,
            iconName: "figure.2",
            description: "查詢列車車廂與各路線即時擁擠狀況"
        ),
        ServiceItem(
            id: "dynamic-info",
            name: "動態資訊",
            category: .instantInfo,
            iconName: "waveform.path.ecg",
            description: "掌握列車運行、路線狀態與即時乘車動態"
        ),
        ServiceItem(
            id: "delay-certificate",
            name: "誤點證明",
            category: .instantInfo,
            iconName: "doc.text.magnifyingglass",
            description: "查詢列車延誤紀錄並申請誤點證明"
        ),
        ServiceItem(
            id: "meetup-train",
            name: "相約列車",
            category: .instantInfo,
            iconName: "person.2.wave.2.fill",
            description: "分享搭乘資訊與列車時間，和朋友相約同行"
        ),
        ServiceItem(
            id: "station-info",
            name: "車站資訊",
            category: .instantInfo,
            iconName: "building.2.fill",
            description: "查詢車站出口、電梯與站內設施資訊"
        ),
        ServiceItem(
            id: "service-alerts",
            name: "營運公告",
            category: .instantInfo,
            iconName: "megaphone.fill",
            description: "查看路線營運狀況、公告與服務異動"
        ),
        ServiceItem(
            id: "alight-reminder",
            name: "下車提醒",
            category: .commuterTools,
            iconName: "bell.and.waves.left.and.right.fill",
            description: "設定目的地與到站提醒，避免坐過站"
        ),
        ServiceItem(
            id: "lost-and-found",
            name: "遺失物協尋",
            category: .commuterTools,
            iconName: "magnifyingglass",
            description: "登記遺失物或搜尋捷運拾獲物品"
        ),
        ServiceItem(
            id: "cable-car-tickets",
            name: "貓纜購票",
            category: .commuterTools,
            iconName: "tram.fill",
            description: "快速選購貓空纜車乘車票券"
        ),
        ServiceItem(
            id: "tourist-pass-deals",
            name: "捷運旅遊票優惠",
            category: .commuterTools,
            iconName: "ticket.fill",
            description: "查詢捷運旅遊票種、搭乘方案與優惠"
        ),
        ServiceItem(
            id: "accessible-travel",
            name: "無障礙旅運",
            category: .commuterTools,
            iconName: "figure.roll",
            description: "規劃友善的無障礙乘車路線與站內動線"
        ),
        ServiceItem(
            id: "my-cards",
            name: "我的票卡／乘車碼",
            category: .memberCard,
            iconName: "qrcode.viewfinder",
            description: "管理常用票卡、乘車碼與乘車紀錄"
        ),
        ServiceItem(
            id: "frequent-rider",
            name: "常客優惠查詢",
            category: .memberCard,
            iconName: "percent",
            description: "查詢常客優惠資格、回饋與使用紀錄"
        ),
        ServiceItem(
            id: "carbon-records",
            name: "碳排／減碳紀錄",
            category: .memberCard,
            iconName: "leaf.fill",
            description: "查看搭乘捷運累積的減碳紀錄與碳排數據"
        ),
        ServiceItem(
            id: "metro-points",
            name: "捷運點數",
            category: .memberCard,
            iconName: "star.fill",
            description: "查看捷運點數、累積紀錄並兌換好禮"
        ),
        ServiceItem(
            id: "coupon-zone",
            name: "優惠券專區",
            category: .memberCard,
            iconName: "ticket.fill",
            description: "領取、查詢與使用會員優惠券"
        ),
        ServiceItem(
            id: "go-map",
            name: "Go! Map",
            category: .lifestyleMap,
            iconName: "map.fill",
            description: "探索美食、夜市、景點與車站周邊生活設施地圖"
        ),
        ServiceItem(
            id: "tourist-fun",
            name: "捷運旅遊趣",
            category: .lifestyleMap,
            iconName: "sparkles",
            description: "發現捷運沿線旅遊提案、熱門景點與活動"
        ),
        ServiceItem(
            id: "line-attractions",
            name: "沿線景點",
            category: .lifestyleMap,
            iconName: "mappin.and.ellipse",
            description: "發現捷運沿線熱門景點與當季活動"
        ),
        ServiceItem(
            id: "metro-mall",
            name: "捷運商城",
            category: .lifestyleMap,
            iconName: "bag.fill",
            description: "逛逛車站商店與精選優惠"
        )
    ]
}
