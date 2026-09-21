import SwiftUI

extension View {
    func metroCardStyle(cornerRadius: CGFloat = 14) -> some View {
        self
            .background(Color.white, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
            }
    }
}
