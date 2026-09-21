import SwiftUI

enum AccessibilitySheet: String, Identifiable {
    case passWallet, lockerInfo
    var id: String { rawValue }
}

struct AccessibilityFacilitySection: View {
    let contrastMode: HighContrastMode
    let voiceGuide: AIVoiceGuideState
    var onOpenSheet: (AccessibilitySheet) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            sectionTitle("設施與行程輔助", symbol: "figure.roll")
            facilityCard
            luggageCard
            HStack(spacing: 8) {
                miniButton("🎟️", "觀光 Pass\n票券錢包") { onOpenSheet(.passWallet) }
                miniButton("🛅", "Locker 寄物櫃\n與托運") { onOpenSheet(.lockerInfo) }
            }
        }
        .padding(12)
        .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(contrastMode.borderColor, lineWidth: 2))
    }

    private var facilityCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            Label("100% 全段電梯導航", systemImage: "figure.roll")
                .font(.headline.weight(.heavy))
                .foregroundStyle(contrastMode.foregroundColor)
            Text("無障礙電梯專用路線")
                .font(.caption.weight(.bold))
                .foregroundStyle(contrastMode.accentColor)
            Text(voiceGuide.nearbyElevatorInfo)
                .font(.caption.weight(.medium))
                .foregroundStyle(contrastMode.secondaryColor)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 106, alignment: .leading)
        .padding(10)
        .background(Color.black, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(contrastMode.accentColor, lineWidth: 1.5))
    }

    private var luggageCard: some View {
        HStack(spacing: 9) {
            Text("🧳").font(.title2)
            VStack(alignment: .leading, spacing: 3) {
                Text("車廂行李推薦").font(.subheadline.weight(.heavy))
                Text("輪椅／大行李友善：第 1、6 車廂")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(contrastMode.accentColor)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(contrastMode.foregroundColor)
        .padding(10)
        .frame(minHeight: 68, alignment: .leading)
        .background(contrastMode.backgroundColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(contrastMode.borderColor, lineWidth: 1))
    }

    private func sectionTitle(_ title: String, symbol: String) -> some View {
        Label(title, systemImage: symbol)
            .font(.headline.weight(.heavy))
            .foregroundStyle(contrastMode.foregroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .accessibilityAddTraits(.isHeader)
    }

    private func miniButton(_ emoji: String, _ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 5) {
                Text(emoji).font(.title3)
                Text(title)
                    .font(.caption.weight(.heavy))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(contrastMode.foregroundColor)
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(contrastMode.accentColor)
            }
            .padding(9)
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .topLeading)
            .background(contrastMode.backgroundColor, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 11).stroke(contrastMode.borderColor, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityHint("開啟詳細資訊")
    }
}
