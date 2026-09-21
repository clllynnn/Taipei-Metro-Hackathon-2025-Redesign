import Foundation

struct EmergencyHelpInfo: Equatable {
    var status: EmergencyStatus
    var staffName: String
    var estimatedArrivalMinutes: Int
    var reassuranceMessage: String
}
