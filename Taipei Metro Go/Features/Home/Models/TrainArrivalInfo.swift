import Foundation

enum TrainDataStatus: String, Equatable {
    case live
    case loading
    case noNetwork
    case serviceEnded
}

enum CrowdingLevel: String, CaseIterable, Identifiable {
    case low
    case moderate
    case high

    var id: Self { self }

    func title(language: AppLanguage) -> String {
        switch (self, language) {
        case (.low, .traditionalChinese): "舒適"
        case (.moderate, .traditionalChinese): "人潮適中"
        case (.high, .traditionalChinese): "較擁擠"
        case (.low, .english): "Comfortable"
        case (.moderate, .english): "Moderate"
        case (.high, .english): "Busy"
        case (.low, .japanese): "快適"
        case (.moderate, .japanese): "普通"
        case (.high, .japanese): "混雑"
        case (.low, .korean): "여유로움"
        case (.moderate, .korean): "보통"
        case (.high, .korean): "혼잡"
        }
    }

    var colorName: String {
        switch self {
        case .low: "crowdingLow"
        case .moderate: "crowdingModerate"
        case .high: "crowdingHigh"
        }
    }
}

struct CarriageCrowdingInfo: Identifiable, Equatable {
    let number: Int
    var crowdingLevel: CrowdingLevel
    var recommendationRank: Int?

    var id: Int { number }
}

struct TrainArrivalInfo: Identifiable, Equatable {
    let id: UUID
    var direction: String
    var countdownSeconds: Int
    var crowdingLevel: CrowdingLevel
    var carriageCrowding: [CarriageCrowdingInfo]
    var preferredExitName: String?
    var status: TrainDataStatus
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        direction: String,
        countdownSeconds: Int,
        crowdingLevel: CrowdingLevel,
        carriageCrowding: [CarriageCrowdingInfo] = [],
        preferredExitName: String? = nil,
        status: TrainDataStatus = .live,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.direction = direction
        self.countdownSeconds = countdownSeconds
        self.crowdingLevel = crowdingLevel
        self.carriageCrowding = carriageCrowding
        self.preferredExitName = preferredExitName
        self.status = status
        self.updatedAt = updatedAt
    }
}
