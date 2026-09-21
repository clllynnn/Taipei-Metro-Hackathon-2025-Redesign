import Foundation

struct AIVoiceGuideState: Equatable {
    var isGuiding: Bool
    var currentInstruction: String
    var nearbyElevatorInfo: String
}
