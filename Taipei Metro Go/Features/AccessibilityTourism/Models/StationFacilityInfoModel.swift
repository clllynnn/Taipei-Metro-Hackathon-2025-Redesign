import Foundation

enum ElevatorServiceStatus: String, Identifiable {
    case operating
    case maintenanceWarning

    var id: Self { self }
}

enum TourismCrowdingLevel: String, Identifiable {
    case comfortable
    case moderate
    case busy

    var id: Self { self }
}

struct StationFacilityInfoModel: Equatable {
    var stationName: String
    var elevatorStatus: ElevatorServiceStatus
    var elevatorStatusMessage: String
    var elevatorExitNumber: String
    var luggageFriendlyCars: [Int]
    var crowdingPrediction: TourismCrowdingLevel
    var luggageSpaceMessage: String
}
