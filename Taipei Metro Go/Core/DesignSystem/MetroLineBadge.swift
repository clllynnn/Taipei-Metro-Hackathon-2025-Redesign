import SwiftUI

enum MetroLineBadgeStyle {
    case outlined
    case solidVertical
}

/// Platform-sign style route identifier. Route color is the only non-grayscale UI color.
struct MetroLineBadge: View {
    let line: MetroLine
    var routeCode: String? = nil
    var showsLineName = true
    var compact = false
    var style: MetroLineBadgeStyle = .outlined

    var body: some View {
        Group {
            switch style {
            case .outlined:
                HStack(spacing: compact ? 4 : 6) {
                    Text(code)
                        .font(.system(compact ? .caption : .subheadline, design: .rounded, weight: .heavy))
                    if showsLineName {
                        Text(line.displayName)
                            .font(.system(compact ? .caption2 : .caption, weight: .bold))
                            .lineLimit(1)
                    }
                }
                .foregroundStyle(Color.primaryText)
                .padding(.horizontal, compact ? 7 : 9)
                .padding(.vertical, compact ? 4 : 6)
                .background(Color.white, in: RoundedRectangle(cornerRadius: compact ? 6 : 7, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: compact ? 6 : 7, style: .continuous)
                        .stroke(MetroColor.color(for: line), lineWidth: 2)
                }
            case .solidVertical:
                VStack(spacing: -1) {
                    Text(codePrefix)
                    Text(codeNumber)
                }
                .font(.system(size: compact ? 15 : 20, weight: .heavy, design: .monospaced))
                .foregroundStyle(Color.black)
                .frame(width: compact ? 40 : 52, height: compact ? 48 : 64)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(MetroColor.color(for: line), lineWidth: 2)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(code) \(line.displayName)\n捷運路線")
    }

    private var code: String { routeCode ?? line.rawValue }
    private var codePrefix: String {
        let value = String(code.prefix { $0.isLetter })
        return value.isEmpty ? line.rawValue : value
    }
    private var codeNumber: String {
        let value = String(code.drop { $0.isLetter })
        return value.isEmpty ? "•" : value
    }
}

extension MetroLine {
    var displayName: String {
        switch self {
        case .brown: "文湖線"
        case .red: "淡水信義線"
        case .green: "松山新店線"
        case .orange: "中和新蘆線"
        case .blue: "板南線"
        case .yellow: "環狀線"
        }
    }
}

#Preview("路線膠囊") {
    VStack(spacing: 12) {
        MetroLineBadge(line: .red)
        MetroLineBadge(line: .blue)
        MetroLineBadge(line: .brown, showsLineName: false, compact: true)
    }
    .padding()
    .background(Color.pageBackground)
}
