import Foundation

struct AttractionExitInfoModel: Identifiable, Equatable {
    var id: String { attractionName }
    var attractionName: String
    var nearestStation: String
    var exitNumber: String
    var luggageFriendlyNote: String
}
