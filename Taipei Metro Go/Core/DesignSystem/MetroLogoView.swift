import SwiftUI

struct MetroLogoView: View {
    var size: CGFloat = 24
    var foregroundColor: Color = .primaryText
    var backgroundColor: Color? = nil
    var borderColor: Color? = nil
    var cornerRadius: CGFloat = 6
    var padding: CGFloat = 0

    var body: some View {
        Image("TRTCLogo")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(foregroundColor)
            .frame(width: size, height: size)
            .padding(padding)
            .background {
                if let backgroundColor {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                }
            }
            .overlay {
                if let borderColor {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                }
            }
            .accessibilityLabel("台北捷運官方標誌")
    }
}

#Preview("標誌尺寸") {
    HStack(spacing: 20) {
        MetroLogoView(size: 16)
        MetroLogoView()
        MetroLogoView(size: 32)
    }
    .padding()
}

#Preview("白底微邊框") {
    MetroLogoView(
        size: 24,
        backgroundColor: .white,
        borderColor: .line,
        cornerRadius: 7,
        padding: 4
    )
    .padding()
    .background(Color.pageBackground)
}
