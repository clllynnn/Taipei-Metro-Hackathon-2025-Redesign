import SwiftUI

extension Color {
    init(accountHex: String) {
        let cleanedHex = accountHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let value = UInt64(cleanedHex, radix: 16) ?? 0
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}

extension View {
    func accountCardStyle() -> some View {
        self
            .padding(16)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension Date {
    var accountDateText: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var accountTimestampText: String {
        formatted(.dateTime.month(.twoDigits).day(.twoDigits).hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }
}
