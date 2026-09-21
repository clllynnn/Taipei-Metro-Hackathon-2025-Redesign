import Foundation

struct SongRequest: Identifiable, Equatable, Codable {
    var id: UUID = UUID()
    var title: String
    var artist: String
    var requesterStory: String
    var stationName: String
    var isPlaying: Bool
    var checkInStreak: Int
}

struct MutualHelpMessage: Identifiable, Equatable {
    var id: UUID = UUID()
    var stationName: String
    var carriageNumber: String
    var content: String
    var timestamp: Date
    var isDirectMessage: Bool = false
    var trainID: String = "BL-1452"
    var lineName: String = "板南線"
    var publicAlias: String? = nil
}

struct CasualChatMessage: Identifiable, Equatable {
    var id: UUID = UUID()
    var lineName: String
    var lineColorHex: String
    var message: String
    var timestamp: Date
    var category: ChatCategory
}

enum LuckyCheckInStatus: Equatable {
    case available
    case submitted
    case carriedOver
    case winner
    case notSelected
}

enum LuckyDrawOutcome: Equatable {
    case winner
    case notSelected
}

enum ChatCategory: String, CaseIterable, Identifiable {
    case officeWorker
    case student
    case anime
    case pets
    case memes

    var id: String { rawValue }

    var title: String {
        switch self {
        case .officeWorker: "上班族"
        case .student: "學生"
        case .anime: "二次元愛好者"
        case .pets: "寵物友善"
        case .memes: "迷因"
        }
    }

}
