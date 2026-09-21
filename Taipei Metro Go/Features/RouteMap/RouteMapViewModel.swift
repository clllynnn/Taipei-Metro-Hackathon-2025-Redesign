import Combine
import Foundation

struct RouteTimeEstimate: Equatable {
    let origin: String
    let destination: String
    let lineName: String
    let minutes: Int
    let stationCount: Int
    let transferCount: Int
    let transferStationNames: [String]
    let nextTransferLineName: String?

    var message: String {
        "\(origin) ➔ \(destination)｜搭乘\(lineName)約 \(minutes) 分鐘"
    }
}

struct TransferArrivalUpdate: Equatable {
    let stationName: String
    let nextLineName: String
    var secondsUntilArrival: Int
    var stopsAway: Int

    var countdownText: String {
        String(format: "%d:%02d", secondsUntilArrival / 60, secondsUntilArrival % 60)
    }
}

struct TransferApproachNotification: Equatable {
    let stationName: String
    let message: String
}

@MainActor
final class RouteMapViewModel: ObservableObject {
    private(set) var travelState: TravelState?

    @Published var userCurrentStation: Station?
    @Published var selectedDestinationStation: Station?
    @Published var presentedStation: Station?
    @Published private(set) var bestRouteEstimate: RouteTimeEstimate?
    @Published private(set) var transferArrivalUpdate: TransferArrivalUpdate?
    @Published var transferApproachNotification: TransferApproachNotification?
    @Published var activeTab: StationInfoTab = .rideInfo
    @Published var userCarriageLocation: CarriageLocation?

    let stations: [Station]
    private var transferTimer: Timer?

    init(travelState: TravelState? = nil) {
        let currentStation = travelState?.currentStation
        let destinationStation = travelState?.selectedDestination
        self.travelState = travelState
        stations = Station.mockNetwork
        userCurrentStation = currentStation
        selectedDestinationStation = destinationStation
        userCarriageLocation = CarriageLocation(carNumber: 4, doorNumber: 2)
        refreshRouteEstimate()
    }

    var bestEscalatorRecommendation: String {
        guard let destination = selectedDestinationStation else { return "選擇目的地後查看推薦" }
        let recommendedCar = travelState?.currentArrivalInfo?.carriageCrowding
            .first(where: { $0.recommendationRank == 1 })?.number
            ?? recommendedCarNumber(for: destination)
        let exit = travelState?.currentArrivalInfo?.preferredExitName
            ?? destination.exitInfo.first
            ?? "1 號出口"
        return "第\(recommendedCar)車廂，往\(exit)手扶梯較順暢"
    }

    var transferExitPath: String {
        guard let destination = selectedDestinationStation else { return "選擇目的地後查看轉乘路徑" }
        let exit = travelState?.currentArrivalInfo?.preferredExitName
            ?? destination.exitInfo.first
            ?? "1 號出口"
        if destination.name == "台北車站" {
            return "月台 → 站內連通道 → 台鐵／高鐵大廳"
        }
        if let estimate = bestRouteEstimate, estimate.transferCount > 0 {
            return "月台 → \(estimate.lineName)轉乘指標 → \(exit) → 地面層"
        }
        return "月台 → \(exit) → 地面層"
    }

    var routeSummary: String {
        bestRouteEstimate?.message ?? "點選地圖上的車站，查看乘車與轉乘建議"
    }

    func selectDestination(_ station: Station) {
        selectedDestinationStation = station
        refreshRouteEstimate()
        travelState?.updateDestination(station)
        presentedStation = station
        activeTab = .rideInfo
    }

    /// Updates the route origin from the route header without opening the station sheet.
    func selectCurrentStation(_ station: Station) {
        userCurrentStation = station
        travelState?.updateCurrentStation(station)
        refreshRouteEstimate()
    }

    /// Updates the route destination from the route header without opening the station sheet.
    func selectDestinationFromHeader(_ station: Station) {
        selectedDestinationStation = station
        travelState?.updateDestination(station)
        refreshRouteEstimate()
    }

    func setDestination(_ station: Station) {
        travelState?.updateDestination(station)
        selectedDestinationStation = station
        refreshRouteEstimate()
        presentedStation = nil
    }

    func bind(to travelState: TravelState) {
        self.travelState = travelState
        syncWithTravelState()
    }

    func syncWithTravelState() {
        userCurrentStation = travelState?.currentStation
        selectedDestinationStation = travelState?.selectedDestination
        refreshRouteEstimate()
    }

    func cancelStationSelection() {
        selectedDestinationStation = travelState?.selectedDestination
        refreshRouteEstimate()
        presentedStation = nil
    }

    func dismissTransferApproachNotification() {
        transferApproachNotification = nil
    }

    private func refreshRouteEstimate() {
        bestRouteEstimate = Self.calculateRouteTime(
            from: userCurrentStation,
            to: selectedDestinationStation
        )
        configureTransferArrivalUpdate()
    }

    private func configureTransferArrivalUpdate() {
        transferTimer?.invalidate()
        transferTimer = nil
        transferApproachNotification = nil

        guard
            let estimate = bestRouteEstimate,
            estimate.transferCount > 0,
            let stationName = estimate.transferStationNames.first,
            let nextLineName = estimate.nextTransferLineName
        else {
            transferArrivalUpdate = nil
            return
        }

        let seconds = max(55, min(80, estimate.stationCount * 6 + 18))
        transferArrivalUpdate = TransferArrivalUpdate(
            stationName: stationName,
            nextLineName: nextLineName,
            secondsUntilArrival: seconds,
            stopsAway: max(1, min(3, estimate.stationCount / 4))
        )
        transferTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.advanceTransferArrivalUpdate()
            }
        }
    }

    private func advanceTransferArrivalUpdate() {
        guard var update = transferArrivalUpdate else { return }
        update.secondsUntilArrival = max(0, update.secondsUntilArrival - 1)
        update.stopsAway = max(0, Int(ceil(Double(update.secondsUntilArrival) / 25)))
        transferArrivalUpdate = update

        if update.secondsUntilArrival <= 45, transferApproachNotification == nil {
            transferApproachNotification = TransferApproachNotification(
                stationName: update.stationName,
                message: "即將抵達\(update.stationName)，請準備依\(update.nextLineName)轉乘指標前往月台。"
            )
        }
        if update.secondsUntilArrival == 0 {
            transferTimer?.invalidate()
            transferTimer = nil
        }
    }

    private func recommendedCarNumber(for destination: Station) -> Int {
        guard let currentCar = userCarriageLocation?.carNumber else { return 3 }
        let destinationBias = destination.name.count % 2 == 0 ? 1 : -1
        return min(6, max(1, currentCar + destinationBias))
    }

    private struct RouteEdge {
        let destination: String
        let line: MetroLine
    }

    private struct SearchState: Hashable {
        let stationID: String
        let line: MetroLine?
    }

    private struct SearchRecord {
        let state: SearchState
        let stationCount: Int
        let transferCount: Int
    }

    private static func calculateRouteTime(from origin: Station?, to destination: Station?) -> RouteTimeEstimate? {
        guard let origin, let destination else { return nil }
        guard origin.id != destination.id else {
            return RouteTimeEstimate(
                origin: origin.name,
                destination: destination.name,
                lineName: lineTitle(origin.line),
                minutes: 0,
                stationCount: 0,
                transferCount: 0,
                transferStationNames: [],
                nextTransferLineName: nil
            )
        }

        let graph = makeGraph()
        let start = SearchState(stationID: origin.id, line: nil)
        var queue = [SearchRecord(state: start, stationCount: 0, transferCount: 0)]
        var bestCost: [SearchState: (stations: Int, transfers: Int)] = [start: (0, 0)]
        var previous: [SearchState: SearchState] = [:]
        var finalState: SearchState?

        while !queue.isEmpty {
            let currentIndex = queue.indices.min {
                let lhs = queue[$0]
                let rhs = queue[$1]
                return lhs.stationCount == rhs.stationCount
                    ? lhs.transferCount < rhs.transferCount
                    : lhs.stationCount < rhs.stationCount
            }!
            let current = queue.remove(at: currentIndex)

            if current.state.stationID == destination.id {
                finalState = current.state
                break
            }

            for edge in graph[current.state.stationID, default: []] {
                let nextState = SearchState(stationID: edge.destination, line: edge.line)
                let nextStations = current.stationCount + 1
                let nextTransfers = current.transferCount
                    + (current.state.line == nil || current.state.line == edge.line ? 0 : 1)
                let oldCost = bestCost[nextState]
                let isBetter = oldCost == nil
                    || nextStations < oldCost!.stations
                    || (nextStations == oldCost!.stations && nextTransfers < oldCost!.transfers)
                guard isBetter else { continue }
                bestCost[nextState] = (nextStations, nextTransfers)
                previous[nextState] = current.state
                queue.append(SearchRecord(state: nextState, stationCount: nextStations, transferCount: nextTransfers))
            }
        }

        guard let finalState else { return fallbackEstimate(from: origin, to: destination) }

        var path = [finalState]
        var cursor = finalState
        while let prior = previous[cursor] {
            path.append(prior)
            cursor = prior
        }
        path.reverse()

        let lines = path.compactMap(\.line).reduce(into: [MetroLine]()) { result, line in
            if result.last != line { result.append(line) }
        }
        let stationCount = max(0, path.count - 1)
        let transferCount = max(0, lines.count - 1)
        let minutes = stationCount == 0 ? 0 : stationCount * 2 + 2 + transferCount * 5
        let lineName = lines.map(lineTitle).joined(separator: "轉乘")
        var transferStationIDs: [String] = []
        var nextTransferLineName: String?
        for index in 1..<path.count {
            guard
                let previousLine = path[index - 1].line,
                let currentLine = path[index].line,
                previousLine != currentLine
            else { continue }
            transferStationIDs.append(path[index - 1].stationID)
            if nextTransferLineName == nil {
                nextTransferLineName = lineTitle(currentLine)
            }
        }
        let transferStationNames = transferStationIDs.map { stationID in
            Station.mockNetwork.first(where: { $0.id == stationID })?.name ?? stationID
        }

        return RouteTimeEstimate(
            origin: origin.name,
            destination: destination.name,
            lineName: lineName.isEmpty ? lineTitle(destination.line) : lineName,
            minutes: minutes,
            stationCount: stationCount,
            transferCount: transferCount,
            transferStationNames: transferStationNames,
            nextTransferLineName: nextTransferLineName
        )
    }

    private static func makeGraph() -> [String: [RouteEdge]] {
        var graph: [String: [RouteEdge]] = [:]
        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                for (first, second) in zip(segment, segment.dropFirst()) {
                    graph[first, default: []].append(RouteEdge(destination: second, line: route.line))
                    graph[second, default: []].append(RouteEdge(destination: first, line: route.line))
                }
            }
        }
        return graph
    }

    private static func fallbackEstimate(from origin: Station, to destination: Station) -> RouteTimeEstimate {
        let latitudeDelta = abs(origin.coordinates.latitude - destination.coordinates.latitude)
        return RouteTimeEstimate(
            origin: origin.name,
            destination: destination.name,
            lineName: lineTitle(destination.line),
            minutes: max(3, Int(latitudeDelta * 100) + 3),
            stationCount: 0,
            transferCount: 0,
            transferStationNames: [],
            nextTransferLineName: nil
        )
    }

    private static func lineTitle(_ line: MetroLine) -> String {
        switch line {
        case .blue: "藍線"
        case .green: "綠線"
        case .orange: "橘線"
        case .brown: "棕線"
        case .yellow: "黃線"
        case .red: "紅線"
        }
    }
}
