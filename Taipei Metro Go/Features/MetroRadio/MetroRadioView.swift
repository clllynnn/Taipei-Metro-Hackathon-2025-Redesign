import SwiftUI

@MainActor
struct MetroRadioView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @StateObject private var viewModel: MetroRadioViewModel
    @State private var isShowingMetroTogether = false
    private let language: AppLanguage

    init(language: AppLanguage = .traditionalChinese) {
        self.language = language
        _viewModel = StateObject(wrappedValue: MetroRadioViewModel())
    }

    init(viewModel: MetroRadioViewModel, language: AppLanguage = .traditionalChinese) {
        self.language = language
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                radioHeader
                pointsSummary
                if viewModel.isDailyDrawOpen {
                    DailyLuckyDrawView(viewModel: viewModel, isCollapsible: true)
                }
                LuckyRadioCardView(viewModel: viewModel)
                togetherEntryCard
                if !viewModel.isDailyDrawOpen {
                    DailyLuckyDrawView(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 112)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
        .background(
            LinearGradient(
                colors: viewModel.timeMood.canvasColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.light)
        .onAppear { viewModel.refreshCheckInState() }
        .fullScreenCover(isPresented: $isShowingMetroTogether) {
            MetroTogetherView(viewModel: viewModel, language: language)
        }
    }

    private var radioHeader: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(MetroRadioCopy.productName(for: language))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .lineLimit(1)

                HStack(spacing: 8) {
                    timeMoodMenu
                        .fixedSize(horizontal: true, vertical: false)
                    Text(viewModel.timeMood.moodLine)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.82))
                        .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                        .minimumScaleFactor(0.82)
                        .allowsTightening(true)
                }
            }
            .foregroundStyle(.white)
            .layoutPriority(1)

            Spacer(minLength: 2)
            utilityMenu
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: dynamicTypeSize.isAccessibilitySize ? 112 : 76, alignment: .center)
        .background {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    colors: viewModel.timeMood.headerColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 92, height: 92)
                    .offset(x: 26, y: 34)
                    .blur(radius: 1)
                Circle()
                    .fill(Color.metroRadioSky.opacity(0.22))
                    .frame(width: 52, height: 52)
                    .offset(x: -92, y: -20)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
    }

    private var timeMoodMenu: some View {
        Menu {
            Section("模擬情緒時段") {
                ForEach(MetroRadioTimeMood.allCases) { mood in
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.simulateTimeMood(mood)
                        }
                    } label: { Text("\(mood.title) · \(mood.timeRange)") }
                }
            }
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.useCurrentTimeMood()
                }
            } label: { Text("依照現在時間") }
        } label: {
            Text(viewModel.isTimeSimulated ? "\(viewModel.timeMood.title) · 模擬" : viewModel.timeMood.title)
                .font(.system(.caption2, weight: .bold))
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(.white.opacity(0.17), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("情緒時段：\(viewModel.timeMood.title)")
    }

    private var utilityMenu: some View {
        Menu {
            Button { isShowingMetroTogether = true } label: {
                Label("開啟乘客交流", systemImage: "person.2.wave.2.fill")
            }
            Section("模擬工具") {
                Button(action: viewModel.simulateCheckout) {
                    Label("模擬刷卡出站", systemImage: "creditcard.fill")
                }
                Button(action: viewModel.simulateCheckInAgain) {
                    Label("重新進站", systemImage: "tram.fill")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 21, weight: .semibold))
                .foregroundStyle(Color.metroRadioCream)
                .accessibilityLabel("更多電台操作")
        }
        .buttonStyle(.plain)
    }

    private var pointsSummary: some View {
        HStack(spacing: 0) {
            summaryValue(value: "\(viewModel.streakDays) 天", title: "連續簽到")
            Divider().overlay(Color.metroRadioCoral.opacity(0.25)).frame(height: 38)
            summaryValue(value: "\(viewModel.metroPoints)", title: "捷運點")
            Divider().overlay(Color.metroRadioCoral.opacity(0.25)).frame(height: 38)
            summaryValue(value: "\(viewModel.lotteryChancePercent)%", title: "抽獎權重")
        }
        .padding(.vertical, 8)
        .background(Color.metroRadioCream.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.55), lineWidth: 1))
    }

    private func summaryValue(value: String, title: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 23, weight: .bold, design: .rounded))
                .foregroundStyle(Color.metroRadioInk)
            Text(title)
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(Color.metroRadioMutedInk)
        }
        .frame(maxWidth: .infinity)
    }

    private var togetherEntryCard: some View {
        Button { isShowingMetroTogether = true } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(MetroRadioCopy.communityTitle(for: language))
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.metroRadioInk)
                    Spacer()
                    Text("開啟")
                        .font(.system(.footnote, weight: .semibold))
                        .foregroundStyle(Color.metroRadioBlue)
                }

                Text("需要協助，或和正在搭車的人交換一點心情。")
                    .font(.system(.footnote))
                    .foregroundStyle(Color.metroRadioMutedInk)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text("共乘互助 · 同線即時")
                        .foregroundStyle(Color.metroRadioBlue)
                    Divider().frame(height: 13)
                    Text("社群閒聊 · 跨線主題")
                        .foregroundStyle(Color.metroRadioTeal)
                }
                .font(.system(.caption, weight: .semibold))
            }
            .padding(14)
            .background(
                LinearGradient(
                    colors: [Color.metroRadioBlueSurface.opacity(0.96), Color.metroRadioMintSurface.opacity(0.90)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.metroRadioBlue.opacity(0.18), lineWidth: 1)
            }
            .shadow(color: Color.metroRadioBlue.opacity(0.08), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityHint("開啟捷客電台的共乘互助與社群閒聊")
    }

}

#Preview {
    MetroRadioView()
}

#Preview("電台・早晨情緒") {
    MetroRadioView(viewModel: MetroRadioViewModel(timeMood: .morning))
}
