import Foundation

struct LockerInfoModel: Identifiable, Equatable {
    var id: String { stationName }
    var stationName: String
    var largeLockerCount: Int
    var mediumLockerCount: Int
    var smallLockerCount: Int
    var supportsHandCarryService: Bool
    var locationNavigation: String
}
