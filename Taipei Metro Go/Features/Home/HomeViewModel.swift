import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    let travelState: TravelState

    @Published private(set) var smartTravelState: SmartTravelState
    @Published var alertMessage: String?
    @Published var currentLanguage: AppLanguage
    @Published var appMode: AppMode

    let favoriteDestinations = [
        HomeFavoriteDestination(id: "home", title: "回家", station: "象山"),
        HomeFavoriteDestination(id: "office", title: "去公司", station: "市政府"),
        HomeFavoriteDestination(id: "school", title: "學校", station: "公館"),
        HomeFavoriteDestination(id: "custom", title: "自訂站點", station: "", opensRoutePlanner: true)
    ]

    let selectableStations: [Station] = {
        let names = ["台北車站", "市政府", "象山", "公館", "淡水", "板橋", "西門"]
        return names.compactMap { name in Station.mockNetwork.first(where: { $0.name == name }) }
    }()

    private var cancellables = Set<AnyCancellable>()

    init(travelState: TravelState) {
        self.travelState = travelState
        let language = travelState.currentLanguage
        currentLanguage = language
        appMode = .normal
        alertMessage = Self.serviceAlertMessage(for: language)

        let origin = travelState.currentStation?.name ?? "台北車站"
        let destination = travelState.selectedDestination?.name ?? "市政府"
        let arrival = travelState.currentArrivalInfo ?? TrainArrivalInfo(
            direction: "往南港展覽館",
            countdownSeconds: 3 * 60 + 42,
            crowdingLevel: .moderate
        )
        let routeLines = Self.resolveRouteLines(
            origin: travelState.currentStation,
            destination: travelState.selectedDestination
        )
        smartTravelState = SmartTravelState(
            routeRecommendation: AIRouteRecommendation(
                originStation: origin,
                destinationStation: destination,
                contextMessage: Self.routeContextMessage(
                    for: language
                )
            ),
            arrivalInfo: arrival,
            originLine: routeLines.origin,
            destinationLine: routeLines.destination
        )

        Publishers.CombineLatest3(
            travelState.$currentStation,
            travelState.$selectedDestination,
            travelState.$currentArrivalInfo
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] _, _, _ in
            self?.refreshSmartTravelState()
        }
        .store(in: &cancellables)
    }

    func setLanguage(_ language: AppLanguage) {
        let shouldKeepAlertVisible = alertMessage != nil
        currentLanguage = language
        if shouldKeepAlertVisible {
            alertMessage = Self.serviceAlertMessage(for: language)
        }
        travelState.refreshArrivalInfo(language: language)
        refreshSmartTravelState()
    }

    func setMode(_ mode: AppMode) {
        appMode = mode
    }

    /// Refreshes the mock train estimate for the currently selected destination.
    func simulateAIInference() {
        travelState.refreshArrivalInfo(language: currentLanguage)
    }

    /// Cycles the mock current location between Taipei Main Station and City Hall.
    func simulateStationChange() {
        let nextStationName = travelState.currentStation?.name == "台北車站" ? "市政府" : "台北車站"
        guard let station = Station.mockNetwork.first(where: { $0.name == nextStationName }) else { return }
        travelState.updateCurrentStation(station)
        refreshSmartTravelState()
    }

    func updateDestination(_ destination: String) {
        guard let station = Station.mockNetwork.first(where: { $0.name == destination }) else { return }
        travelState.updateDestination(station, language: currentLanguage)
        refreshSmartTravelState()
    }

    func updateOrigin(_ origin: String) {
        guard let station = Station.mockNetwork.first(where: { $0.name == origin }) else { return }
        travelState.updateCurrentStation(station)
        refreshSmartTravelState()
    }

    func swapRoute() {
        guard
            let origin = travelState.currentStation,
            let destination = travelState.selectedDestination
        else { return }
        travelState.updateCurrentStation(destination)
        travelState.updateDestination(origin, language: currentLanguage)
        refreshSmartTravelState()
    }

    func simulateTrainStatus(_ status: TrainDataStatus) {
        guard var arrival = travelState.currentArrivalInfo else { return }
        arrival.status = status
        arrival.updatedAt = .now
        travelState.currentArrivalInfo = arrival
        refreshSmartTravelState()
    }

    func dismissAlert() {
        alertMessage = nil
    }

    private func refreshSmartTravelState() {
        let origin = travelState.currentStation?.name ?? "台北車站"
        let destination = travelState.selectedDestination?.name ?? "市政府"
        let arrival = travelState.currentArrivalInfo ?? TrainArrivalInfo(
            direction: "往南港展覽館",
            countdownSeconds: 3 * 60 + 42,
            crowdingLevel: .moderate
        )
        let routeLines = Self.resolveRouteLines(
            origin: travelState.currentStation,
            destination: travelState.selectedDestination
        )
        smartTravelState = SmartTravelState(
            routeRecommendation: AIRouteRecommendation(
                id: smartTravelState.routeRecommendation.id,
                originStation: origin,
                destinationStation: destination,
                contextMessage: Self.routeContextMessage(
                    for: currentLanguage
                )
            ),
            arrivalInfo: arrival,
            originLine: routeLines.origin,
            destinationLine: routeLines.destination
        )
    }

    private struct RouteNode: Hashable {
        let stationID: String
        let line: MetroLine
    }

    private struct RouteEdge {
        let destination: RouteNode
        let cost: Int
    }

    /// Resolves the line shown on each station badge from the actual journey.
    /// A direct common line always wins. Transfer routes use the shortest network path,
    /// with a small transfer penalty so the first badge is the line the rider boards.
    private static func resolveRouteLines(
        origin: Station?,
        destination: Station?
    ) -> (origin: MetroLine, destination: MetroLine) {
        guard let origin, let destination else {
            return (origin?.line ?? .red, destination?.line ?? .red)
        }

        if let directLine = origin.lines.first(where: destination.lines.contains) {
            return (directLine, directLine)
        }

        let graph = makeRouteGraph()
        let startNodes = origin.lines.map { RouteNode(stationID: origin.id, line: $0) }
        let destinationNodes = Set(destination.lines.map { RouteNode(stationID: destination.id, line: $0) })
        var distance: [RouteNode: Int] = Dictionary(uniqueKeysWithValues: startNodes.map { ($0, 0) })
        var previous: [RouteNode: RouteNode] = [:]
        var unvisited = Set(graph.keys)

        while let current = unvisited.min(by: {
            distance[$0, default: .max] < distance[$1, default: .max]
        }), distance[current] != nil {
            unvisited.remove(current)
            if destinationNodes.contains(current) { break }

            for edge in graph[current, default: []] where unvisited.contains(edge.destination) {
                let candidate = distance[current, default: .max] + edge.cost
                if candidate < distance[edge.destination, default: .max] {
                    distance[edge.destination] = candidate
                    previous[edge.destination] = current
                }
            }
        }

        guard let target = destinationNodes
            .filter({ distance[$0] != nil })
            .min(by: { distance[$0, default: .max] < distance[$1, default: .max] })
        else {
            return (origin.line, destination.line)
        }

        var path = [target]
        var cursor = target
        while let prior = previous[cursor] {
            path.append(prior)
            cursor = prior
        }
        path.reverse()
        return (path.first?.line ?? origin.line, path.last?.line ?? destination.line)
    }

    private static func makeRouteGraph() -> [RouteNode: [RouteEdge]] {
        var graph: [RouteNode: [RouteEdge]] = [:]

        func connect(_ lhs: RouteNode, _ rhs: RouteNode, cost: Int) {
            graph[lhs, default: []].append(RouteEdge(destination: rhs, cost: cost))
            graph[rhs, default: []].append(RouteEdge(destination: lhs, cost: cost))
        }

        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                for (lhsID, rhsID) in zip(segment, segment.dropFirst()) {
                    connect(
                        RouteNode(stationID: lhsID, line: route.line),
                        RouteNode(stationID: rhsID, line: route.line),
                        cost: 1
                    )
                }
            }
        }

        for station in Station.mockNetwork where station.lines.count > 1 {
            for lhsIndex in station.lines.indices {
                for rhsIndex in station.lines.indices where lhsIndex < rhsIndex {
                    connect(
                        RouteNode(stationID: station.id, line: station.lines[lhsIndex]),
                        RouteNode(stationID: station.id, line: station.lines[rhsIndex]),
                        cost: 3
                    )
                }
            }
        }

        return graph
    }

    private static func routeContextMessage(for language: AppLanguage) -> String {
        switch language {
        case .traditionalChinese:
            "下班時間，準備回家嗎？"
        case .english:
            "Heading home after work?"
        case .japanese:
            "お仕事帰りですか？"
        case .korean:
            "퇴근길인가요?"
        }
    }

    private static func serviceAlertMessage(for language: AppLanguage) -> String {
        switch language {
        case .traditionalChinese: "淡水信義線：台北車站月台人潮較多，請留意月台安全。"
        case .english: "Tamsui–Xinyi Line: Platforms at Taipei Main Station are busy. Please take care."
        case .japanese: "淡水信義線：台北駅のホームは混雑しています。足元にご注意ください。"
        case .korean: "단수이–신이선: 타이베이 메인역 승강장이 혼잡합니다. 안전에 유의하세요."
        }
    }
}
