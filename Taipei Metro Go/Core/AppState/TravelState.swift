import Combine
import Foundation
import CoreLocation

@MainActor
final class TravelState: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentStation: Station?
    @Published var selectedDestination: Station?
    @Published var currentArrivalInfo: TrainArrivalInfo?
    @Published var currentLanguage: AppLanguage
    @Published private(set) var isUsingGPS = false
    @Published private(set) var locationAuthorization: CLAuthorizationStatus = .notDetermined

    private let locationManager = CLLocationManager()
    private let stationSearchRadius: CLLocationDistance = 1_500

    static let mock = TravelState()

    init(
        currentStation: Station? = nil,
        selectedDestination: Station? = nil,
        currentArrivalInfo: TrainArrivalInfo? = nil,
        currentLanguage: AppLanguage = .traditionalChinese
    ) {
        let origin = currentStation ?? Station.mockNetwork.first { $0.name == "台北車站" }
        let destination = selectedDestination ?? Station.mockNetwork.first { $0.name == "市政府" }
        self.currentStation = origin
        self.selectedDestination = destination
        self.currentLanguage = currentLanguage
        self.currentArrivalInfo = currentArrivalInfo ?? Self.makeArrivalInfo(for: destination, language: currentLanguage)
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        locationAuthorization = locationManager.authorizationStatus
    }

    /// Requests permission once and keeps the current station synced to the nearest
    /// Taipei Metro station while the app is in use. A mock station remains visible
    /// until a real GPS fix is available.
    func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            isUsingGPS = false
            return
        }

        locationAuthorization = locationManager.authorizationStatus
        switch locationAuthorization {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isUsingGPS = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isUsingGPS = false
        @unknown default:
            isUsingGPS = false
        }
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        isUsingGPS = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorization = manager.authorizationStatus
        startLocationUpdates()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy >= 0 else { return }

        let nearest = Station.mockNetwork.min { lhs, rhs in
            stationLocation(lhs).distance(from: location) < stationLocation(rhs).distance(from: location)
        }
        guard let nearest else { return }
        let distance = stationLocation(nearest).distance(from: location)
        guard distance <= stationSearchRadius, currentStation?.id != nearest.id else { return }
        updateCurrentStation(nearest)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Keep the last known or mock station when a temporary GPS fix fails.
        isUsingGPS = false
    }

    private func stationLocation(_ station: Station) -> CLLocation {
        CLLocation(latitude: station.coordinates.latitude, longitude: station.coordinates.longitude)
    }

    func updateDestination(_ station: Station) {
        selectedDestination = station
        currentArrivalInfo = Self.makeArrivalInfo(for: station, language: currentLanguage)
    }

    func updateDestination(_ station: Station, language: AppLanguage) {
        currentLanguage = language
        selectedDestination = station
        currentArrivalInfo = Self.makeArrivalInfo(for: station, language: currentLanguage)
    }

    func updateCurrentStation(_ station: Station) {
        currentStation = station
        if let selectedDestination {
            currentArrivalInfo = Self.makeArrivalInfo(for: selectedDestination, language: currentLanguage)
        }
    }

    func refreshArrivalInfo(language: AppLanguage) {
        currentLanguage = language
        guard let selectedDestination else { return }
        currentArrivalInfo = Self.makeArrivalInfo(for: selectedDestination, language: currentLanguage)
    }

    private static func makeArrivalInfo(for destination: Station?, language: AppLanguage) -> TrainArrivalInfo {
        let name = destination?.name ?? "市政府"
        let countdown: Int
        let crowding: CrowdingLevel

        switch name {
        case "淡水": countdown = 4 * 60 + 18; crowding = .high
        case "板橋": countdown = 2 * 60 + 42; crowding = .low
        case "市政府": countdown = 3 * 60 + 42; crowding = .moderate
        case "西門": countdown = 1 * 60 + 58; crowding = .low
        default: countdown = 5 * 60 + 6; crowding = .low
        }

        let direction: String
        switch (name, language) {
        case ("市政府", .traditionalChinese): direction = "往南港展覽館"
        case ("市政府", .english): direction = "Toward Nangang Exhibition Center"
        case ("市政府", .japanese): direction = "南港展覧館方面"
        case ("市政府", .korean): direction = "난강전람관 방면"
        case ("淡水", .traditionalChinese): direction = "往淡水"
        case ("淡水", .english): direction = "Toward Tamsui"
        case ("淡水", .japanese): direction = "淡水方面"
        case ("淡水", .korean): direction = "단수이 방면"
        case ("廣慈/奉天宮", .traditionalChinese): direction = "往廣慈／奉天宮"
        case ("廣慈/奉天宮", .english): direction = "Toward Guangci/Fengtian Temple"
        case ("廣慈/奉天宮", .japanese): direction = "広慈／奉天宮方面"
        case ("廣慈/奉天宮", .korean): direction = "광츠·펑톈궁 방면"
        case ("台北車站", .traditionalChinese), ("板橋", .traditionalChinese), ("西門", .traditionalChinese): direction = "往頂埔"
        case ("台北車站", .english), ("板橋", .english), ("西門", .english): direction = "Toward Dingpu"
        case ("台北車站", .japanese), ("板橋", .japanese), ("西門", .japanese): direction = "頂埔方面"
        case ("台北車站", .korean), ("板橋", .korean), ("西門", .korean): direction = "딩푸 방면"
        case (_, .traditionalChinese): direction = "往象山"
        case (_, .english): direction = "Toward Xiangshan"
        case (_, .japanese): direction = "象山方面"
        case (_, .korean): direction = "샹산 방면"
        }

        let exitProfile = mockExitUsageProfile(for: name)
        let carriageLevels = mockCarriageCrowding(for: name)
        let recommendations = recommendedCarriages(
            exitAffinity: exitProfile.affinityByCarriage,
            crowding: carriageLevels
        )
        let carriageCrowding = (1...6).map { carriageNumber in
            CarriageCrowdingInfo(
                number: carriageNumber,
                crowdingLevel: carriageLevels[carriageNumber] ?? crowding,
                recommendationRank: recommendations.firstIndex(of: carriageNumber).map { $0 + 1 }
            )
        }

        return TrainArrivalInfo(
            direction: direction,
            countdownSeconds: countdown,
            crowdingLevel: crowding,
            carriageCrowding: carriageCrowding,
            preferredExitName: localizedExitName(exitProfile.exitNumber, language: language)
        )
    }

    /// Mock analytics: higher values mean the carriage is closer to the exit most often used at that station.
    private static func mockExitUsageProfile(for stationName: String) -> (exitNumber: Int, affinityByCarriage: [Int: Int]) {
        switch stationName {
        case "象山": return (2, [1: 18, 2: 30, 3: 48, 4: 68, 5: 92, 6: 100])
        case "板橋": return (3, [1: 55, 2: 92, 3: 100, 4: 64, 5: 36, 6: 20])
        case "淡水": return (1, [1: 100, 2: 90, 3: 68, 4: 45, 5: 28, 6: 16])
        case "西門": return (6, [1: 18, 2: 30, 3: 46, 4: 67, 5: 94, 6: 100])
        default: return (2, [1: 15, 2: 35, 3: 70, 4: 100, 5: 95, 6: 40])
        }
    }

    private static func mockCarriageCrowding(for stationName: String) -> [Int: CrowdingLevel] {
        switch stationName {
        case "象山": return [1: .moderate, 2: .low, 3: .low, 4: .moderate, 5: .low, 6: .moderate]
        case "板橋": return [1: .moderate, 2: .low, 3: .low, 4: .moderate, 5: .high, 6: .moderate]
        case "淡水": return [1: .moderate, 2: .high, 3: .moderate, 4: .high, 5: .moderate, 6: .low]
        case "西門": return [1: .high, 2: .moderate, 3: .moderate, 4: .low, 5: .low, 6: .moderate]
        default: return [1: .high, 2: .moderate, 3: .low, 4: .low, 5: .moderate, 6: .high]
        }
    }

    /// Uses the rider's most frequently used exit as the primary signal.
    /// Live crowding only breaks equal exit-affinity scores, so exactly two cars are selected.
    private static func recommendedCarriages(
        exitAffinity: [Int: Int],
        crowding: [Int: CrowdingLevel]
    ) -> [Int] {
        let comfortPriority: [CrowdingLevel: Int] = [.low: 2, .moderate: 1, .high: 0]
        return (1...6)
            .sorted { lhs, rhs in
                let lhsAffinity = exitAffinity[lhs] ?? 0
                let rhsAffinity = exitAffinity[rhs] ?? 0
                guard lhsAffinity == rhsAffinity else { return lhsAffinity > rhsAffinity }

                let lhsComfort = comfortPriority[crowding[lhs] ?? .moderate] ?? 1
                let rhsComfort = comfortPriority[crowding[rhs] ?? .moderate] ?? 1
                return lhsComfort == rhsComfort ? lhs < rhs : lhsComfort > rhsComfort
            }
            .prefix(2)
            .map(\.self)
    }

    private static func localizedExitName(_ number: Int, language: AppLanguage) -> String {
        switch language {
        case .traditionalChinese: String(number) + " 號出口"
        case .english: "Exit " + String(number)
        case .japanese: String(number) + "番出口"
        case .korean: String(number) + "번 출구"
        }
    }
}
