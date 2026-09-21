import SwiftUI

/// A prominent strip of luggage-friendly attraction exits. It intentionally contains
/// only wayfinding information; locker capacity belongs to the Locker service card.
struct AttractionExitsBar: View {
    let exits: [AttractionExitInfoModel]
    let language: TourismLanguage
    let localizedAttraction: (String) -> String

    var body: some View {
        HStack(spacing: 8) {
            ForEach(exits.prefix(3)) { exit in
                exitTag(exit)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            exits.prefix(3)
                .map { "\(localizedAttraction($0.attractionName))，\(localizedExitNumber($0.exitNumber)) \(TourismHomeCopy.text(.elevatorExit, language: language))" }
                .joined(separator: "；")
        )
    }

    private func exitTag(_ exit: AttractionExitInfoModel) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(localizedAttraction(exit.attractionName))
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.76)
            Text("\(localizedExitNumber(exit.exitNumber)) \(TourismHomeCopy.text(.elevatorExit, language: language))")
                .font(.system(size: language == .traditionalChinese ? 14 : 12, weight: .semibold))
                .foregroundStyle(Color.primaryText.opacity(0.72))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.line, lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(localizedAttraction(exit.attractionName)) \(exit.exitNumber)")
    }

    private func localizedExitNumber(_ rawValue: String) -> String {
        let number = rawValue
            .replacingOccurrences(of: "出口", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return switch language {
        case .traditionalChinese: "出口 \(number)"
        case .english: "Exit \(number)"
        case .japanese: "\(number)番出口"
        case .korean: "\(number)번 출구"
        }
    }
}
