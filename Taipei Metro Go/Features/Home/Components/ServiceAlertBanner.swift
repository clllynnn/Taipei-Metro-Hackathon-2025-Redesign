import SwiftUI

struct ServiceAlertBanner: View {
    let alertMessage: String?
    let language: AppLanguage
    var isCompact = false
    var onDismiss: () -> Void
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Group {
            if let alertMessage, !alertMessage.isEmpty {
                HStack(alignment: .top, spacing: 11) {
                    Image(systemName: "tram.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(HomeCopy.text(.serviceAlert, language: language))
                                .font(.system(.footnote, weight: .bold))
                            Spacer()
                            Text(nowLabel)
                                .font(.caption2)
                                .foregroundStyle(Color.secondaryText)
                        }
                        Text(alertMessage)
                            .font(.system(.caption, weight: .medium))
                            .foregroundStyle(Color.primaryText)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(isCompact ? 11 : 13)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color.white.opacity(0.55), lineWidth: 1))
                .shadow(color: .black.opacity(0.18), radius: 18, y: 8)
                .offset(x: dragOffset.width, y: min(0, dragOffset.height))
                .opacity(dragOpacity)
                .gesture(dismissGesture)
                .accessibilityAction(named: dismissLabel, onDismiss)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: alertMessage)
        .task(id: alertMessage) {
            guard alertMessage != nil else { return }
            try? await Task.sleep(for: .seconds(6))
            guard !Task.isCancelled else { return }
            onDismiss()
        }
    }

    private var dragOpacity: Double {
        max(0.35, 1 - Double(max(abs(dragOffset.width), abs(min(0, dragOffset.height)))) / 220)
    }

    private var dismissGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in dragOffset = value.translation }
            .onEnded { value in
                let shouldDismiss = abs(value.translation.width) > 90 || value.translation.height < -45
                if shouldDismiss {
                    withAnimation(.easeOut(duration: 0.2)) {
                        dragOffset = CGSize(
                            width: value.translation.width == 0 ? 0 : (value.translation.width > 0 ? 420 : -420),
                            height: min(-100, value.translation.height)
                        )
                    }
                    onDismiss()
                } else {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) { dragOffset = .zero }
                }
            }
    }

    private var nowLabel: String {
        switch language {
        case .traditionalChinese: "現在"
        case .english: "now"
        case .japanese: "今"
        case .korean: "지금"
        }
    }

    private var dismissLabel: String {
        switch language {
        case .traditionalChinese: "關閉營運公告"
        case .english: "Dismiss service alert"
        case .japanese: "運行情報を閉じる"
        case .korean: "운행 안내 닫기"
        }
    }
}

#Preview {
    ServiceAlertBanner(
        alertMessage: "淡水信義線：台北車站月台人潮較多，請留意月台安全。",
        language: .traditionalChinese,
        onDismiss: {}
    )
    .padding()
    .background(Color.pageBackground)
}
