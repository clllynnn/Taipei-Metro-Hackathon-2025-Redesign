import SwiftUI

struct GlobalSearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.primaryAction)

            TextField("搜尋功能、服務或關鍵字", text: $searchText)
                .font(.system(.subheadline, weight: .medium))
                .foregroundStyle(Color.primaryText)
                .focused($isSearchFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    isSearchFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.secondaryText.opacity(0.7))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("清除搜尋")
            }
        }
        .padding(.horizontal, 15)
        .frame(minHeight: 50)
        .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.line.opacity(0.8), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    GlobalSearchBarView(searchText: .constant("到站"))
        .padding()
        .background(Color.pageBackground)
}
