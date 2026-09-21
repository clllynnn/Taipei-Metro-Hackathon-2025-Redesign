import SwiftUI

enum MetroRadioTimeMood: String, CaseIterable, Identifiable {
    case morning
    case afternoon
    case evening
    case lateNight

    var id: String { rawValue }

    var title: String {
        switch self {
        case .morning: "早晨"
        case .afternoon: "午後"
        case .evening: "晚間"
        case .lateNight: "深夜"
        }
    }

    var timeRange: String {
        switch self {
        case .morning: "05:00–11:00"
        case .afternoon: "11:00–16:00"
        case .evening: "16:00–23:00"
        case .lateNight: "23:00–05:00"
        }
    }

    var moodLine: String {
        switch self {
        case .morning: "慢慢醒來，今天有一首開場曲"
        case .afternoon: "留一段光給自己，繼續走下去"
        case .evening: "回家的路，有一首歌陪你"
        case .lateNight: "城市安靜了，還有人在線"
        }
    }

    var playerKicker: String {
        switch self {
        case .morning: "今天的第一段陪伴"
        case .afternoon: "午後的幸運點播"
        case .evening: "回家路上的幸運點播"
        case .lateNight: "深夜仍在線的幸運點播"
        }
    }

    var headerColors: [Color] {
        switch self {
        case .morning: [.metroRadioBlue, .metroRadioTeal, .metroRadioSky]
        case .afternoon: [.metroRadioSky, .metroRadioBlue, .metroRadioIndigo]
        case .evening: [.metroRadioNavy, .metroRadioIndigo, .metroRadioBlue]
        case .lateNight: [.metroRadioNavy, Color(red: 0.07, green: 0.10, blue: 0.20), .metroRadioIndigo]
        }
    }

    var playerColors: [Color] {
        switch self {
        case .morning: [.metroRadioNavy, .metroRadioBlue, .metroRadioTeal]
        case .afternoon: [.metroRadioBlue, .metroRadioIndigo, .metroRadioNavy]
        case .evening: [.metroRadioNavy, .metroRadioIndigo, .metroRadioBlue]
        case .lateNight: [Color(red: 0.04, green: 0.08, blue: 0.17), .metroRadioNavy, .metroRadioIndigo]
        }
    }

    var canvasColors: [Color] {
        switch self {
        case .morning: [.metroRadioCanvas, .metroRadioBlueSurface.opacity(0.68)]
        case .afternoon: [.metroRadioCanvas, .metroRadioMintSurface.opacity(0.58)]
        case .evening: [.metroRadioCanvas, .metroRadioBlueSurface.opacity(0.72)]
        case .lateNight: [.metroRadioCanvas, .metroRadioCanvasDeep]
        }
    }

    var accent: Color {
        switch self {
        case .morning: .metroRadioTeal
        case .afternoon: .metroRadioBlue
        case .evening: .metroRadioIndigo
        case .lateNight: .metroRadioNavy
        }
    }

    static func from(date: Date, calendar: Calendar = .current) -> MetroRadioTimeMood {
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 5..<11: return .morning
        case 11..<16: return .afternoon
        case 16..<23: return .evening
        default: return .lateNight
        }
    }
}
