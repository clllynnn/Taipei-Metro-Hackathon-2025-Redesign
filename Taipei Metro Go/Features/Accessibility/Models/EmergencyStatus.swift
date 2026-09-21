import Foundation

enum EmergencyStatus: String, CaseIterable, Identifiable {
    case idle
    case calling
    case staffAssigned
    case staffArriving

    var id: Self { self }
}
