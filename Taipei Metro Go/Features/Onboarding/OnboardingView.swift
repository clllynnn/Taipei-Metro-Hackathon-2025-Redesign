import SwiftUI

@MainActor
struct OnboardingView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @StateObject private var viewModel: OnboardingViewModel

    init(previewMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(previewMode: previewMode))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.62)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack(spacing: 18) {
                        Spacer()
                        Button("跳過") { dismiss() }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.secondaryText)
                            .accessibilityLabel("跳過新手教學")

                        Button(action: dismiss) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.secondaryText)
                                .frame(minWidth: 44, minHeight: 44)
                                .background(Color.pageBackground, in: Circle())
                        }
                        .accessibilityLabel("關閉新手教學")
                    }
                    .padding(.bottom, 4)

                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.pageCount, id: \.self) { page in
                            OnboardingCardView(page: page)
                                .tag(page)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxHeight: .infinity)

                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.pageCount, id: \.self) { page in
                            Capsule()
                                .fill(page == viewModel.currentPage ? Color.primaryAction : Color.primaryAction.opacity(0.18))
                                .frame(width: page == viewModel.currentPage ? 24 : 7, height: 7)
                                .animation(.spring(response: 0.3, dampingFraction: 0.75), value: viewModel.currentPage)
                        }
                    }
                    .padding(.top, 4)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("第 \(viewModel.currentPage + 1) 頁，共 \(viewModel.pageCount) 頁")

                    Button(action: advance) {
                        HStack(spacing: 8) {
                            Text(viewModel.currentPage == viewModel.pageCount - 1 ? "🚀 開始體驗 App" : "下一步")
                            if viewModel.currentPage < viewModel.pageCount - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.footnote.weight(.bold))
                            }
                        }
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 54)
                        .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 20)
                }
                .padding(20)
                .frame(
                    width: min(geometry.size.width - 32, 480),
                    height: dynamicTypeSize.isAccessibilitySize
                        ? geometry.size.height - 32
                        : min(geometry.size.height - 64, 760)
                )
                .background(.white, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func advance() {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
            viewModel.advanceOrDismiss()
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
            viewModel.dismissOnboarding()
        }
    }
}

#Preview("首次開啟・新手教學") {
    OnboardingView(previewMode: true)
}

#Preview("新手教學・最大輔助使用字級") {
    OnboardingView(previewMode: true)
        .environment(\.dynamicTypeSize, .accessibility5)
}
