import Combine
import Foundation

@MainActor
final class TourismViewModel: ObservableObject {
    @Published var currentLanguage: TourismLanguage = .traditionalChinese
    @Published var isElevatorFirst = true
    @Published var selectedLockerStation = "台北車站"
    @Published var isAudioGuideEnabled = true
    @Published var isElevatorNotificationEnabled = true

    @Published var elevatorRoute = ElevatorRouteModel(
        originStation: "麟光站",
        destinationStation: "台北 101",
        transferStation: "大安站",
        accessibleTransferMinutes: 8,
        estimatedTravelMinutes: 28,
        elevatorMovementInstructions: "請走 Exit M7 旁的電梯，沿無障礙轉乘通道前往月台。"
    )
    @Published var stationFacility = StationFacilityInfoModel(
        stationName: "麟光站",
        elevatorStatus: .operating,
        elevatorStatusMessage: "站內電梯正常運作。",
        elevatorExitNumber: "M7",
        luggageFriendlyCars: [1, 6],
        crowdingPrediction: .comfortable,
        luggageSpaceMessage: "第 1、6 車廂提供較寬敞的大行李與輪椅空間。"
    )
    @Published var lockerStations: [LockerInfoModel] = [
        LockerInfoModel(stationName: "台北車站", largeLockerCount: 12, mediumLockerCount: 28, smallLockerCount: 46, supportsHandCarryService: true, locationNavigation: "東三通路藍色寄物櫃指標旁，手托運中心在站務中心旁。"),
        LockerInfoModel(stationName: "西門站", largeLockerCount: 4, mediumLockerCount: 16, smallLockerCount: 31, supportsHandCarryService: false, locationNavigation: "6 號出口與無障礙電梯大廳旁。"),
        LockerInfoModel(stationName: "市政府站", largeLockerCount: 7, mediumLockerCount: 19, smallLockerCount: 25, supportsHandCarryService: false, locationNavigation: "往 2 號出口的付費區通道內。")
    ]
    @Published var attractionExits: [AttractionExitInfoModel] = [
        AttractionExitInfoModel(attractionName: "台北 101", nearestStation: "台北 101／世貿站", exitNumber: "出口 4", luggageFriendlyNote: "寬敞無階梯路線，出口旁有電梯，適合拖行李。"),
        AttractionExitInfoModel(attractionName: "象山公園", nearestStation: "象山", exitNumber: "出口 3", luggageFriendlyNote: "沿無障礙坡道前往公園入口。"),
        AttractionExitInfoModel(attractionName: "臨江街夜市", nearestStation: "大安", exitNumber: "出口 1", luggageFriendlyNote: "出口旁設有電梯，適合拖行李前往夜市。")
    ]
    @Published var qrTicketCount = 2
    @Published var isTaipeiPassActive = true
    @Published var passDiscountCount = 12
    @Published var ticketWalletMessage: String?
    @Published var lockerNavigationMessage: String?
    @Published var airportTransferMessage: String?
    @Published var serviceActionMessage: String?
    @Published var isAssistanceAlertActive = false

    init(initialLanguage: TourismLanguage = .traditionalChinese) {
        currentLanguage = initialLanguage
        refreshRouteInstructions()
        refreshStationFacility()
    }

    var selectedLocker: LockerInfoModel? {
        lockerStations.first { $0.stationName == selectedLockerStation }
    }

    /// Values surfaced by the primary route card. Keep a safe fallback so a partially
    /// loaded route never renders an empty or malformed duration.
    var accessibleTransferMinutes: Int {
        let value = elevatorRoute.accessibleTransferMinutes
        if elevatorRoute.transferStation == "無需轉乘" { return 0 }
        return value > 0 ? value : 8
    }

    var totalTravelMinutes: Int {
        let value = elevatorRoute.estimatedTravelMinutes
        return value > 0 ? value : 28
    }

    var recommendedExitMessage: String {
        let exit = elevatorRoute.destinationStation.contains("101") ? "4" : "3"
        switch currentLanguage {
        case .traditionalChinese: return "出口 \(exit) 電梯"
        case .english: return "Elevator at Exit \(exit)"
        case .japanese: return "\(exit)番出口のエレベーター"
        case .korean: return "\(exit)번 출구 엘리베이터"
        }
    }

    /// Station choices used by the two independent route controls in the hero card.
    var routeStationOptions: [String] {
        ["麟光站", "台北車站", "大安站", "市政府站", "西門站", "象山", "台北 101"]
    }

    func metroLine(for station: String) -> MetroLine {
        switch station {
        case "麟光站": .brown
        case "市政府站", "西門站": .blue
        default: .red
        }
    }

    func metroCode(for station: String) -> String {
        switch station {
        case "麟光站": "BR06"
        case "台北車站": "R10"
        case "大安站": "R05"
        case "市政府站": "BL18"
        case "西門站": "BL11"
        case "象山": "R02"
        case "台北 101", "台北101", "台北 101／世貿站": "R03"
        default: metroLine(for: station).rawValue
        }
    }

    var quickActionStates: [TourismQuickActionState] {
        let passSubtitle: String = {
            switch currentLanguage {
            case .traditionalChinese: return isTaipeiPassActive ? "已開通・\(passDiscountCount) 個折扣" : "尚未開通・立即查看"
            case .english: return isTaipeiPassActive ? "Active • \(passDiscountCount) discounts" : "Not active • View passes"
            case .japanese: return isTaipeiPassActive ? "利用中・\(passDiscountCount) 件の特典" : "未開通・パスを見る"
            case .korean: return isTaipeiPassActive ? "사용 중・혜택 \(passDiscountCount)개" : "미사용・패스 보기"
            }
        }()
        let lockerSubtitle: String = {
            switch currentLanguage {
            case .traditionalChinese: return "台北車站・即時空位"
            case .english: return "Taipei Main • Live lockers"
            case .japanese: return "台北駅・空き状況"
            case .korean: return "타이베이역・빈 보관함"
            }
        }()
        let airportSubtitle: String = {
            switch currentLanguage {
            case .traditionalChinese: return "A1 台北車站・預辦登機"
            case .english: return "A1 Taipei Main • Check-in"
            case .japanese: return "A1 台北駅・荷物預け"
            case .korean: return "A1 타이베이역・수하물"
            }
        }()
        return [
            TourismQuickActionState(
                action: .passWallet,
                title: TourismHomeCopy.text(.passWallet, language: currentLanguage),
                subtitle: passSubtitle,
                symbol: "ticket.fill"
            ),
            TourismQuickActionState(
                action: .locker,
                title: TourismHomeCopy.text(.locker, language: currentLanguage),
                subtitle: lockerSubtitle,
                symbol: "shippingbox.fill"
            ),
            TourismQuickActionState(
                action: .airport,
                title: TourismHomeCopy.text(.airport, language: currentLanguage),
                subtitle: airportSubtitle,
                symbol: "airplane.departure"
            ),
            TourismQuickActionState(
                action: .aiRoute,
                title: TourismHomeCopy.text(.aiRoute, language: currentLanguage),
                subtitle: TourismHomeCopy.text(.aiRouteSubtitle, language: currentLanguage),
                symbol: "sparkles"
            )
        ]
    }

    func setLanguage(_ language: TourismLanguage) {
        currentLanguage = language
        refreshRouteInstructions()
        refreshStationFacility()
    }

    func localizedStation(_ station: String) -> String {
        switch (station, currentLanguage) {
        case ("台北車站", .traditionalChinese): "台北車站"
        case ("台北車站", .english): "Taipei Main Station"
        case ("台北車站", .japanese): "台北駅"
        case ("台北車站", .korean): "타이베이 메인역"
        case ("麟光站", .traditionalChinese): "麟光站"
        case ("麟光站", .english): "Linguang Station"
        case ("麟光站", .japanese): "麟光駅"
        case ("麟光站", .korean): "린광역"
        case ("台北 101", .traditionalChinese), ("台北101", .traditionalChinese): "台北 101"
        case ("台北 101", .english), ("台北101", .english): "Taipei 101"
        case ("台北 101", .japanese), ("台北101", .japanese): "台北101"
        case ("台北 101", .korean), ("台北101", .korean): "타이베이 101"
        case ("台北 101／世貿站", .traditionalChinese): "台北 101／世貿站"
        case ("台北 101／世貿站", .english): "Taipei 101／世貿 Station"
        case ("台北 101／世貿站", .japanese): "台北101／世貿駅"
        case ("台北 101／世貿站", .korean): "타이베이 101／스마오역"
        case ("市政府站", .traditionalChinese), ("市政府", .traditionalChinese): "市政府站"
        case ("市政府站", .english), ("市政府", .english): "Taipei City Hall"
        case ("市政府站", .japanese), ("市政府", .japanese): "市政府駅"
        case ("市政府站", .korean), ("市政府", .korean): "시정부역"
        case ("西門站", .traditionalChinese), ("西門", .traditionalChinese): "西門站"
        case ("西門站", .english), ("西門", .english): "Ximen Station"
        case ("西門站", .japanese), ("西門", .japanese): "西門駅"
        case ("西門站", .korean), ("西門", .korean): "시먼역"
        case ("大安站", .traditionalChinese), ("大安", .traditionalChinese): "大安站"
        case ("大安站", .english), ("大安", .english): "Daan Station"
        case ("大安站", .japanese), ("大安", .japanese): "大安駅"
        case ("大安站", .korean), ("大安", .korean): "다안역"
        case ("無需轉乘", .traditionalChinese): "無需轉乘"
        case ("無需轉乘", .english): "Direct"
        case ("無需轉乘", .japanese): "乗換なし"
        case ("無需轉乘", .korean): "환승 없음"
        case ("忠孝復興站", .traditionalChinese): "忠孝復興站"
        case ("忠孝復興站", .english): "Zhongxiao Fuxing"
        case ("忠孝復興站", .japanese): "忠孝復興駅"
        case ("忠孝復興站", .korean): "중샤오푸싱역"
        case ("象山", .traditionalChinese): "象山"
        case ("象山", .english): "Xiangshan"
        case ("象山", .japanese): "象山"
        case ("象山", .korean): "샹산"
        default: station
        }
    }

    func localizedAttraction(_ attraction: String) -> String {
        switch (attraction, currentLanguage) {
        case ("台北 101", .traditionalChinese): "台北 101"
        case ("台北 101", .english): "Taipei 101"
        case ("台北 101", .japanese): "台北101"
        case ("台北 101", .korean): "타이베이 101"
        case ("象山公園", .traditionalChinese): "象山公園"
        case ("象山公園", .english): "Xiangshan Park"
        case ("象山公園", .japanese): "象山公園"
        case ("象山公園", .korean): "샹산 공원"
        case ("臨江街夜市", .traditionalChinese): "臨江街夜市"
        case ("臨江街夜市", .english): "Linjiang Night Market"
        case ("臨江街夜市", .japanese): "臨江街夜市"
        case ("臨江街夜市", .korean): "린장 야시장"
        default: attraction
        }
    }

    func planElevatorRoute() {
        updateRouteMetrics()
        refreshRouteInstructions()
        refreshStationFacility()
    }

    func selectOriginStation(_ station: String) {
        elevatorRoute.originStation = station
        planElevatorRoute()
    }

    func selectDestinationStation(_ station: String) {
        elevatorRoute.destinationStation = station
        planElevatorRoute()
    }

    private func updateRouteMetrics() {
        let origin = elevatorRoute.originStation
        let destination = elevatorRoute.destinationStation

        if origin == destination {
            elevatorRoute.transferStation = "無需轉乘"
            elevatorRoute.accessibleTransferMinutes = 0
            elevatorRoute.estimatedTravelMinutes = 5
            return
        }

        let originLine = metroLine(for: origin)
        let destinationLine = metroLine(for: destination)

        if originLine == destinationLine {
            elevatorRoute.transferStation = "無需轉乘"
            elevatorRoute.accessibleTransferMinutes = 0
            elevatorRoute.estimatedTravelMinutes = directTravelMinutes(from: origin, to: destination)
            return
        }

        let routeLines = Set([originLine, destinationLine])
        if routeLines == Set([MetroLine.brown, .red]) {
            elevatorRoute.transferStation = "大安站"
            elevatorRoute.accessibleTransferMinutes = 8
        } else if routeLines == Set([MetroLine.blue, .red]) {
            elevatorRoute.transferStation = "台北車站"
            elevatorRoute.accessibleTransferMinutes = 7
        } else {
            elevatorRoute.transferStation = "忠孝復興站"
            elevatorRoute.accessibleTransferMinutes = 7
        }

        let isDefaultRoute = Set([origin, destination]) == Set(["麟光站", "台北 101"])
        elevatorRoute.estimatedTravelMinutes = isDefaultRoute
            ? (isElevatorFirst ? 28 : 24)
            : (isElevatorFirst ? 26 : 22)
    }

    private func directTravelMinutes(from origin: String, to destination: String) -> Int {
        let stationOrder: [String: Int] = [
            "象山": 2,
            "台北 101": 3,
            "大安站": 5,
            "台北車站": 10,
            "西門站": 11,
            "市政府站": 18,
            "麟光站": 6
        ]
        let stops = abs((stationOrder[origin] ?? 0) - (stationOrder[destination] ?? 0))
        return max(6, stops * 2 + (isElevatorFirst ? 6 : 4))
    }

    func selectLockerStation(_ stationName: String) {
        selectedLockerStation = stationName
        lockerNavigationMessage = nil
    }

    func navigateToLocker() {
        guard let locker = selectedLocker else { return }
        lockerNavigationMessage = locker.locationNavigation
    }

    func selectPass(_ passName: String) {
        ticketWalletMessage = "\(passName) — \(TourismCopy.text(.ticketNotice, language: currentLanguage))"
    }

    func requestHotelDelivery() {
        serviceActionMessage = TourismCopy.text(.deliveryNotice, language: currentLanguage)
    }

    func showAirportTransferGuide() {
        airportTransferMessage = TourismCopy.text(.airportGuide, language: currentLanguage)
    }

    func toggleAssistanceAlert() {
        isAssistanceAlertActive.toggle()
        serviceActionMessage = TourismCopy.text(isAssistanceAlertActive ? .assistanceSent : .cancelAssistance, language: currentLanguage)
    }

    private func refreshRouteInstructions() {
        let station = localizedStation(elevatorRoute.originStation)
        switch (currentLanguage, isElevatorFirst) {
        case (.traditionalChinese, true): elevatorRoute.elevatorMovementInstructions = "請從\(station)沿電梯專用指標前往月台，走 Exit M7 旁電梯。"
        case (.traditionalChinese, false): elevatorRoute.elevatorMovementInstructions = "目前為最快路線，可能經過階梯；開啟避開階梯可改走無障礙路線。"
        case (.english, true): elevatorRoute.elevatorMovementInstructions = "At \(station), follow the elevator signs and use the lift beside Exit M7."
        case (.english, false): elevatorRoute.elevatorMovementInstructions = "Fastest route selected. Turn on elevator-first routing for a step-free path."
        case (.japanese, true): elevatorRoute.elevatorMovementInstructions = "\(station)でエレベーター案内に沿って、M7出口そばのエレベーターをご利用ください。"
        case (.japanese, false): elevatorRoute.elevatorMovementInstructions = "最短ルートです。段差のない経路にはエレベーター優先をオンにしてください。"
        case (.korean, true): elevatorRoute.elevatorMovementInstructions = "\(station)에서 엘리베이터 표지판을 따라 Exit M7 옆 리프트를 이용하세요."
        case (.korean, false): elevatorRoute.elevatorMovementInstructions = "최단 경로입니다. 단차 없는 경로는 엘리베이터 우선을 켜세요."
        }
    }

    private func refreshStationFacility() {
        stationFacility.stationName = elevatorRoute.originStation
        stationFacility.elevatorExitNumber = elevatorRoute.originStation.contains("西門") ? "出口 2" : "M7"
        stationFacility.luggageFriendlyCars = isElevatorFirst ? [1, 6] : [1]
        stationFacility.crowdingPrediction = .comfortable
        switch (currentLanguage, stationFacility.elevatorStatus) {
        case (.traditionalChinese, .operating): stationFacility.elevatorStatusMessage = "站內電梯正常運作。"
        case (.traditionalChinese, .maintenanceWarning): stationFacility.elevatorStatusMessage = "出口電梯有維修預警，請改走出口 2。"
        case (.english, .operating): stationFacility.elevatorStatusMessage = "All station elevators are operating normally."
        case (.english, .maintenanceWarning): stationFacility.elevatorStatusMessage = "Maintenance warning. Use the lift at Exit 2."
        case (.japanese, .operating): stationFacility.elevatorStatusMessage = "駅構内のエレベーターは通常運転中です。"
        case (.japanese, .maintenanceWarning): stationFacility.elevatorStatusMessage = "エレベーター点検のお知らせ。2番出口をご利用ください。"
        case (.korean, .operating): stationFacility.elevatorStatusMessage = "역 내 엘리베이터가 정상 운행 중입니다."
        case (.korean, .maintenanceWarning): stationFacility.elevatorStatusMessage = "엘리베이터 점검 안내입니다. 2번 출구를 이용하세요."
        }
        stationFacility.luggageSpaceMessage = luggageSpaceMessage(for: currentLanguage)
    }

    private func luggageSpaceMessage(for language: TourismLanguage) -> String {
        switch language {
        case .traditionalChinese: "建議搭乘第 1 或第 6 大行李友善車廂"
        case .english: "Cars 1 or 6 are recommended for large luggage."
        case .japanese: "大型荷物には1号車または6号車がおすすめです。"
        case .korean: "큰 짐은 1호차 또는 6호차를 추천합니다."
        }
    }
}
