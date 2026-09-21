import SwiftUI

struct AccessibilityHeaderView: View {
    let contrastMode: HighContrastMode
    var onReturnToNormalMode: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Text("無障礙陪伴")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(contrastMode.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            Button(action: onReturnToNormalMode) {
                Text("返回一般模式")
                    .font(.system(size: 16, weight: .heavy))
                    .lineLimit(1)
                    .padding(.horizontal, 16)
                    .frame(minHeight: 56)
                    .foregroundStyle(.black)
                    .background(contrastMode.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(AccessibilityButtonStyle())
            .accessibilityLabel("返回一般模式")
        }
        .frame(maxWidth: .infinity, minHeight: 56)
    }
}

#Preview {
    AccessibilityHeaderView(contrastMode: .grayOnBlack, onReturnToNormalMode: {})
        .padding()
        .background(.black)
}
