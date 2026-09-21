import Foundation

struct ElevatorRouteModel: Equatable {
    var originStation: String
    var destinationStation: String
    var transferStation: String
    var accessibleTransferMinutes: Int
    var estimatedTravelMinutes: Int
    var elevatorMovementInstructions: String
}
