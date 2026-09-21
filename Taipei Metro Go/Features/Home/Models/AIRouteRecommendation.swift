import Foundation

struct AIRouteRecommendation: Identifiable, Equatable {
    let id: UUID
    var originStation: String
    var destinationStation: String
    var contextMessage: String

    init(
        id: UUID = UUID(),
        originStation: String,
        destinationStation: String,
        contextMessage: String
    ) {
        self.id = id
        self.originStation = originStation
        self.destinationStation = destinationStation
        self.contextMessage = contextMessage
    }
}
