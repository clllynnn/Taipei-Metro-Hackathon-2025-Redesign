import Foundation

enum TourismCopy {
    enum Key: Hashable {
        case title, returnMode, routePlan, from, to, findRoute, elevatorFirst
        case accessibleTransfer, transferTime, estimatedTravel, elevatorInstructions
        case facilities, elevatorStatus, operating, maintenanceWarning, exit
        case luggageSpace, car, crowding, comfortable, moderate, busy, lockers
        case large, medium, small, lockersAvailable, handCarry, locationGuide
        case available, unavailable
        case openDirections, attractions, luggageFriendly, tickets, taipeiPass
        case funPass, qrTickets, airportTransfer, preCheckIn, hotelDelivery
        case requestDelivery, assistance, assistanceSent, cancelAssistance
        case language, audioGuide, arrivalAnnouncements, elevatorAlerts
        case routeUpdated, deliveryNotice, ticketNotice, demoData
        case forRollingBags, elevatorAtExit, addToWallet, airportMRT, airportGuide, alertActive
    }

    static func text(_ key: Key, language: TourismLanguage) -> String {
        translations[language]?[key] ?? ""
    }

    private static let translations: [TourismLanguage: [Key: String]] = [
        .english: [
            .title: "Tourist Journey Assistant", .returnMode: "General mode", .routePlan: "Step-free route",
            .from: "From", .to: "To", .findRoute: "Plan route", .elevatorFirst: "Elevator-first route",
            .accessibleTransfer: "Accessible transfer", .transferTime: "transfer", .estimatedTravel: "Total travel",
            .elevatorInstructions: "Elevator directions", .facilities: "Elevators & train facilities",
            .elevatorStatus: "Elevator status", .operating: "Operating normally", .maintenanceWarning: "Maintenance warning",
            .exit: "Elevator exit", .luggageSpace: "Luggage-friendly cars", .car: "Car", .crowding: "Crowding forecast",
            .comfortable: "Comfortable", .moderate: "Moderate", .busy: "Busy", .lockers: "Live luggage lockers",
            .large: "Large", .medium: "Medium", .small: "Small", .lockersAvailable: "available", .available: "Available", .unavailable: "Not available",
            .handCarry: "Hand-carry service", .locationGuide: "Locker location", .openDirections: "Show directions",
            .attractions: "Luggage-friendly attraction exits", .luggageFriendly: "Step-free exit",
            .tickets: "Pass & ticket wallet", .taipeiPass: "Taipei Pass", .funPass: "Fun Pass", .qrTickets: "QR tickets",
            .airportTransfer: "Airport MRT transfer", .preCheckIn: "Airport pre-check-in and baggage transfer guide",
            .hotelDelivery: "Hotel luggage delivery", .requestDelivery: "View delivery options",
            .assistance: "Station assistance alert", .assistanceSent: "Alert sent — staff can meet you at the elevator lobby.",
            .cancelAssistance: "Cancel assistance alert", .language: "Language", .audioGuide: "Audio guide",
            .arrivalAnnouncements: "Arrival & transfer announcements", .elevatorAlerts: "Elevator exit notifications",
            .routeUpdated: "Route updated", .deliveryNotice: "Ask the service counter to confirm pickup options.",
            .ticketNotice: "Added to your trip wallet.", .demoData: "Sample live service data",
            .forRollingBags: "Best for rolling bags", .elevatorAtExit: "Elevator access at this exit", .addToWallet: "Add to wallet",
            .airportMRT: "Airport MRT", .airportGuide: "From Taipei Main Station, follow the Airport MRT signs. Confirm pre-check-in and baggage drop eligibility with your airline.", .alertActive: "Assistance alert is active"
        ],
        .japanese: [
            .title: "観光サポート", .returnMode: "通常モードへ", .routePlan: "段差のないルート",
            .from: "出発駅", .to: "目的地", .findRoute: "ルート検索", .elevatorFirst: "エレベーター優先ルート",
            .accessibleTransfer: "バリアフリー乗換", .transferTime: "乗換", .estimatedTravel: "所要時間",
            .elevatorInstructions: "エレベーター案内", .facilities: "エレベーターと車内設備",
            .elevatorStatus: "エレベーター状況", .operating: "通常運転", .maintenanceWarning: "点検のお知らせ",
            .exit: "エレベーター出口", .luggageSpace: "荷物に便利な車両", .car: "号車", .crowding: "混雑予測",
            .comfortable: "空いています", .moderate: "普通", .busy: "混雑", .lockers: "ロッカー空き状況",
            .large: "大型", .medium: "中型", .small: "小型", .lockersAvailable: "空き", .available: "利用可能", .unavailable: "利用不可",
            .handCarry: "手荷物運搬サービス", .locationGuide: "ロッカーの場所", .openDirections: "場所を案内",
            .attractions: "荷物に便利な観光出口", .luggageFriendly: "段差のない出口",
            .tickets: "乗車券・パス", .taipeiPass: "Taipei Pass", .funPass: "Fun Pass", .qrTickets: "QR乗車券",
            .airportTransfer: "空港MRT乗換", .preCheckIn: "空港の事前チェックイン・荷物預け案内",
            .hotelDelivery: "ホテルへの荷物配送", .requestDelivery: "配送方法を見る",
            .assistance: "駅係員に連絡", .assistanceSent: "通知しました。エレベーター付近で係員と合流できます。",
            .cancelAssistance: "駅係員への通知を取消", .language: "言語", .audioGuide: "音声ガイド",
            .arrivalAnnouncements: "到着・乗換アナウンス", .elevatorAlerts: "エレベーター出口通知",
            .routeUpdated: "ルートを更新しました", .deliveryNotice: "配送方法は駅のサービスカウンターでご確認ください。",
            .ticketNotice: "旅のチケット一覧に追加しました。", .demoData: "サービス情報はサンプルです",
            .forRollingBags: "キャリーケースに便利", .elevatorAtExit: "この出口にエレベーターあり", .addToWallet: "ウォレットに追加",
            .airportMRT: "空港MRT", .airportGuide: "台北駅で空港MRTの案内に従ってください。事前チェックインと手荷物預けの対象は航空会社にご確認ください。", .alertActive: "係員への連絡中です"
        ],
        .korean: [
            .title: "관광 이동 도우미", .returnMode: "일반 모드로 돌아가기", .routePlan: "무단차 경로",
            .from: "출발역", .to: "목적지", .findRoute: "경로 찾기", .elevatorFirst: "엘리베이터 우선 경로",
            .accessibleTransfer: "교통약자 환승", .transferTime: "환승", .estimatedTravel: "총 이동 시간",
            .elevatorInstructions: "엘리베이터 안내", .facilities: "엘리베이터 및 객차 시설",
            .elevatorStatus: "엘리베이터 상태", .operating: "정상 운행", .maintenanceWarning: "점검 안내",
            .exit: "엘리베이터 출구", .luggageSpace: "짐이 편한 객차", .car: "호차", .crowding: "혼잡도 예측",
            .comfortable: "여유로움", .moderate: "보통", .busy: "혼잡", .lockers: "실시간 물품보관함",
            .large: "대형", .medium: "중형", .small: "소형", .lockersAvailable: "개 사용 가능", .available: "이용 가능", .unavailable: "이용 불가",
            .handCarry: "수하물 운반 서비스", .locationGuide: "보관함 위치", .openDirections: "위치 안내",
            .attractions: "짐 이동에 편리한 관광지 출구", .luggageFriendly: "무단차 출구",
            .tickets: "패스 및 승차권 지갑", .taipeiPass: "Taipei Pass", .funPass: "Fun Pass", .qrTickets: "QR 승차권",
            .airportTransfer: "공항 MRT 환승", .preCheckIn: "공항 사전 체크인 및 수하물 안내",
            .hotelDelivery: "호텔 수하물 당일 배송", .requestDelivery: "배송 옵션 보기",
            .assistance: "역무원 도움 요청", .assistanceSent: "요청을 보냈습니다. 엘리베이터 앞에서 역무원을 만날 수 있습니다.",
            .cancelAssistance: "도움 요청 취소", .language: "언어", .audioGuide: "음성 안내",
            .arrivalAnnouncements: "도착 및 환승 음성 안내", .elevatorAlerts: "엘리베이터 출구 알림",
            .routeUpdated: "경로를 업데이트했습니다", .deliveryNotice: "배송 옵션은 역 서비스 센터에서 확인하세요.",
            .ticketNotice: "여행 티켓 지갑에 추가했습니다.", .demoData: "서비스 정보는 예시입니다",
            .forRollingBags: "캐리어 이동에 편리", .elevatorAtExit: "이 출구에 엘리베이터 있음", .addToWallet: "지갑에 추가",
            .airportMRT: "공항 MRT", .airportGuide: "타이베이 메인역에서 공항 MRT 표지판을 따라가세요. 사전 체크인 및 수하물 위탁 가능 여부는 항공사에 확인하세요.", .alertActive: "역무원 도움 요청이 활성화됨"
        ],
    ]
}
