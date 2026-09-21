import SwiftUI

struct OnboardingModalView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var page = 0
    @State private var isAnimating = false

    private let pages: [(title: String, detail: String, symbol: String, tint: Color)] = [
        ("一秒看懂，趕車免動手", "開啟首頁就能看到列車倒數與六節車廂擁擠度，快速決定要不要加速前往月台。", "tram.fill", .primaryAction),
        ("切換模式，貼心隨行", "一般、觀光客與無障礙模式各自整理最需要的資訊，依照今天的旅程一鍵切換。", "slider.horizontal.3", .statusSuccess),
        ("捷運生活，一指掌握", "捷運商城、捷客電台與捷運點活動，都在首頁下方的快捷入口。", "square.grid.2x2.fill", .rewardsAccent)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Metro Go")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.primaryText)
                Spacer()
                Button("跳過") { dismiss() }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.secondaryText)
                    .frame(minWidth: 60, minHeight: 44)
            }

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    onboardingPage(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.45, dampingFraction: 0.82), value: page)

            HStack(spacing: 7) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? Color.primaryAction : Color.line)
                        .frame(width: index == page ? 24 : 7, height: 7)
                }
            }
            .padding(.bottom, 18)

            Button {
                if page == pages.count - 1 { dismiss() } else {
                    withAnimation { page += 1 }
                }
            } label: {
                HStack {
                    Text(page == pages.count - 1 ? "開始使用 Metro Go" : "下一步")
                    Spacer()
                    Image(systemName: page == pages.count - 1 ? "checkmark" : "arrow.right")
                }
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(Color.pageBackground)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) { isAnimating = true }
        }
    }

    private func onboardingPage(_ page: (title: String, detail: String, symbol: String, tint: Color)) -> some View {
        VStack(spacing: 22) {
            Spacer(minLength: 20)
            ZStack {
                Circle()
                    .fill(page.tint.opacity(0.12))
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimating ? 1.04 : 0.96)
                Image(systemName: page.symbol)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(page.tint)
            }
            Text(page.title)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(Color.primaryText)
                .multilineTextAlignment(.center)
            Text(page.detail)
                .font(.body)
                .foregroundStyle(Color.secondaryText)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
            Spacer(minLength: 20)
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) { hasSeenOnboarding = true }
    }
}

#Preview {
    OnboardingModalView()
        .frame(height: 650)
}
