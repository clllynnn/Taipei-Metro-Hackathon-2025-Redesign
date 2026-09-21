import SwiftUI

struct MultiLangAndAudioBar: View {
    @Binding var language: TourismLanguage
    @Binding var isAudioGuideEnabled: Bool
    @Binding var isElevatorNotificationEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "globe.americas.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(TourismPalette.navy, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                Text(TourismCopy.text(.language, language: language))
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(TourismPalette.text)
                Spacer(minLength: 0)
                Menu {
                    ForEach(TourismLanguage.allCases) { option in
                        Button {
                            language = option
                        } label: {
                            if option == language {
                                Label(option.displayName, systemImage: "checkmark")
                            } else {
                                Text(option.displayName)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(language.displayName)
                            .font(.headline.weight(.bold))
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.heavy))
                    }
                    .foregroundStyle(TourismPalette.navy)
                    .padding(.horizontal, 14)
                    .frame(minHeight: 52)
                    .background(TourismPalette.paleSurface, in: Capsule())
                    .overlay(Capsule().stroke(TourismPalette.action.opacity(0.25), lineWidth: 1))
                }
                .accessibilityLabel("\(TourismCopy.text(.language, language: language)): \(language.displayName)")
                .accessibilityHint("Choose English, Japanese, or Korean")
            }

            VStack(spacing: 0) {
                settingRow(
                    title: TourismCopy.text(.arrivalAnnouncements, language: language),
                    symbol: "speaker.wave.2.fill",
                    value: $isAudioGuideEnabled
                )
                Divider().overlay(TourismPalette.line)
                settingRow(
                    title: TourismCopy.text(.elevatorAlerts, language: language),
                    symbol: "bell.badge.fill",
                    value: $isElevatorNotificationEnabled
                )
            }
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(TourismPalette.line, lineWidth: 1))
    }

    private func settingRow(title: String, symbol: String, value: Binding<Bool>) -> some View {
        Toggle(isOn: value) {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(TourismPalette.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .tint(TourismPalette.action)
        .frame(minHeight: 60)
        .accessibilityLabel(title)
        .accessibilityHint("Turn this travel announcement setting on or off")
    }
}

#Preview {
    @Previewable @State var language: TourismLanguage = .english
    @Previewable @State var audio = true
    @Previewable @State var alerts = true
    MultiLangAndAudioBar(language: $language, isAudioGuideEnabled: $audio, isElevatorNotificationEnabled: $alerts)
        .padding()
        .background(TourismPalette.canvas)
}
