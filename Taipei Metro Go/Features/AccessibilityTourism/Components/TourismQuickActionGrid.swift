import SwiftUI

enum TourismQuickAction: String, Identifiable {
    case passWallet, locker, airport, assistance, aiRoute

    var id: String { rawValue }
}

struct TourismQuickActionState: Identifiable {
    let action: TourismQuickAction
    let title: String
    let subtitle: String
    let symbol: String

    var id: TourismQuickAction { action }
}

struct TourismQuickActionGrid: View {
    let actions: [TourismQuickActionState]
    var onSelect: (TourismQuickAction) -> Void

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
            spacing: 10
        ) {
            ForEach(actions) { item in
                Button { onSelect(item.action) } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: item.symbol)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Color.primaryAction)
                                .frame(width: 28, height: 28)
                                .background(Color.softSurface, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            Spacer(minLength: 4)
                            Image(systemName: "arrow.forward")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.primaryText.opacity(0.48))
                        }
                        Text(item.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.primaryText)
                            .lineLimit(2)
                            .minimumScaleFactor(0.78)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(item.subtitle)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color.primaryText.opacity(0.62))
                            .lineLimit(1)
                            .minimumScaleFactor(0.66)
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.line, lineWidth: 1))
                    .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityElement(children: .combine)
                .accessibilityHint("Open details")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
