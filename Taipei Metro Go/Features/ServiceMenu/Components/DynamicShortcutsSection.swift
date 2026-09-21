import SwiftUI

struct DynamicShortcutsSection: View {
    let services: [ServiceItem]
    let recommendationLabel: String

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 9, weight: .bold))
                    Text("AI・\(recommendationLabel)")
                        .font(.system(.caption2, weight: .bold))
                }
                .foregroundStyle(Color.primaryAction)
                .padding(.horizontal, 9)
                .padding(.vertical, 7)
                .background(Color.softSurface, in: Capsule())
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(services) { service in
                    ShortcutCard(service: service)
                }
            }
        }
    }
}

private struct ShortcutCard: View {
    let service: ServiceItem

    var body: some View {
        Button {} label: {
            Text(service.name)
                .font(.system(.footnote, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(8)
            .frame(
                maxWidth: .infinity,
                minHeight: ServiceMenuLayout.cardHeight,
                maxHeight: ServiceMenuLayout.cardHeight,
                alignment: .center
            )
            .background(.white, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .stroke(Color.line.opacity(0.75), lineWidth: 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    DynamicShortcutsSection(services: [
        ServiceItem(id: "delay", name: "誤點證明", category: .instantInfo, iconName: "doc.text", description: "快速申請列車延誤證明", isDynamicShortcut: true),
        ServiceItem(id: "alight", name: "下車提醒", category: .commuterTools, iconName: "bell", description: "到站前提醒你下車", isDynamicShortcut: true),
        ServiceItem(id: "meet", name: "相約列車", category: .commuterTools, iconName: "person.2", description: "和朋友分享搭乘資訊", isDynamicShortcut: true),
        ServiceItem(id: "map", name: "Go! Map", category: .lifestyleMap, iconName: "map", description: "探索沿線景點", isDynamicShortcut: true)
    ], recommendationLabel: "通勤高峰推薦")
    .padding()
    .background(Color.pageBackground)
}
