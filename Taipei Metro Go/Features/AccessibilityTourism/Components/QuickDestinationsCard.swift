import SwiftUI

struct QuickDestinationsCard: View {
    let destinations: [QuickDestination]
    var compact = false
    let contrastMode: HighContrastMode
    var onSelect: (QuickDestination) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 10 : 12) {
            Text("常用目的地")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(contrastMode.accentColor)
                .accessibilityAddTraits(.isHeader)
            HStack(alignment: .center, spacing: 12) {
                ForEach(destinations.prefix(2)) { destination in
                    Button { onSelect(destination) } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                Image(systemName: destination.iconName)
                                    .font(.system(size: compact ? 20 : 22, weight: .bold))
                                    .frame(width: compact ? 38 : 40, height: compact ? 38 : 40)
                                    .background(Color.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                                Text(destination.title)
                                    .font(.system(size: compact ? 18 : 19, weight: .heavy))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                            Text(destination.targetStation)
                                .font(.system(size: 16, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .padding(.leading, compact ? 48 : 50)
                        }
                        .frame(maxWidth: .infinity, minHeight: compact ? 68 : 74, alignment: .leading)
                        .foregroundStyle(contrastMode.foregroundColor)
                        .padding(.vertical, compact ? 8 : 10)
                        .padding(.horizontal, compact ? 10 : 12)
                        .background(contrastMode.surfaceColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(contrastMode.accentColor.opacity(0.78), lineWidth: 1.5)
                        }
                    }
                    .buttonStyle(AccessibilityButtonStyle())
                    .frame(maxWidth: .infinity)
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .accessibilityLabel("\(destination.title)，\(destination.targetStation)")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
