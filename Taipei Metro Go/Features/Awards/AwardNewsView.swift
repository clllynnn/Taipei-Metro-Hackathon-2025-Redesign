import SwiftUI

struct AwardRecognitionCard: View {
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.primaryAction, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text("2025 捷運盃黑客松・季軍")
                        .font(.system(.caption, weight: .bold))
                        .foregroundStyle(Color.secondaryText)
                    Text("要不要搭捷運")
                        .font(.system(.title3, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                    Text("以情緒設計串起 AI 動態推薦與 metroTogether")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(Color.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.secondaryText)
                    .padding(.top, 5)
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color.white, Color.primaryAction.opacity(0.06)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.primaryAction.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityHint("查看得獎新聞稿與競賽重點")
    }
}

struct AwardNewsView: View {
    @Environment(\.dismiss) private var dismiss

    private let highlights = [
        "情緒設計：讓捷運不只是移動工具，也成為通勤時的情緒陪伴。",
        "AI 動態推薦：依照旅程情境快速提供個人化的乘車資訊。",
        "桌面小工具：在不開啟 App 的情況下，也能掌握重要通勤資訊。",
        "metroTogether：透過音樂、聊天室與情緒陪伴，營造溫馨的候車體驗。"
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    awardHero
                    summarySection
                    highlightsSection
                    competitionSection
                    sourcesSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
            .background(Color.pageBackground.ignoresSafeArea())
            .navigationTitle("得獎專題")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }

    private var awardHero: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("2025 捷運盃黑客松")
                        .font(.system(.subheadline, weight: .bold))
                        .foregroundStyle(.white.opacity(0.78))
                    Text("季軍")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "trophy.fill")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundStyle(.yellow)
                    .padding(13)
                    .background(.white.opacity(0.13), in: Circle())
            }
            Text("要不要搭捷運")
                .font(.system(.title2, weight: .bold))
                .foregroundStyle(.white)
            Text("獎金 NT$20,000")
                .font(.system(.footnote, weight: .semibold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(red: 0.14, green: 0.14, blue: 0.16), Color(red: 0.31, green: 0.24, blue: 0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }

    private var summarySection: some View {
        AwardNewsSection(title: "新聞稿摘要", symbol: "newspaper.fill") {
            Text("「要不要搭捷運」團隊在 2025 捷運盃黑客松決賽中，以情緒設計為核心，結合 AI 動態推薦與桌面小工具，快速提供通勤資訊；並以 metroTogether 串起音樂、聊天室與情緒陪伴，獲評審肯定，榮獲季軍。")
                .font(.subheadline)
                .foregroundStyle(Color.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var highlightsSection: some View {
        AwardNewsSection(title: "作品與競賽重點", symbol: "sparkles") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(highlights, id: \.self) { highlight in
                    Label {
                        Text(highlight)
                            .font(.subheadline)
                            .foregroundStyle(Color.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    } icon: {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.primaryAction)
                    }
                }
            }
        }
    }

    private var competitionSection: some View {
        AwardNewsSection(title: "競賽資訊", symbol: "flag.checkered") {
            VStack(alignment: .leading, spacing: 9) {
                AwardFactRow(label: "主題", value: "設計創新・AI 賦能")
                AwardFactRow(label: "參賽規模", value: "104 組報名，10 組晉級決賽")
                AwardFactRow(label: "決賽", value: "2025 年 8 月 30 日・捷運北投會館")
                AwardFactRow(label: "評選面向", value: "內容創新、UI/UX、功能可行性與使用者體驗")
            }
        }
    }

    private var sourcesSection: some View {
        AwardNewsSection(title: "官方新聞稿", symbol: "link") {
            VStack(alignment: .leading, spacing: 11) {
                Link(destination: URL(string: "https://www.gov.taipei/News_Content.aspx?n=F0DDAF49B89E9413&s=C6122A8A549FD692")!) {
                    Label("臺北市政府：決賽結果新聞稿", systemImage: "arrow.up.right.square")
                }
                Link(destination: URL(string: "https://www.metro.taipei/News_Content.aspx?n=30CCEFD2A45592BF&sms=72544237BBE4C5F6&s=8094C28B588FCBC9")!) {
                    Label("臺北捷運：競賽報名與主題說明", systemImage: "arrow.up.right.square")
                }
                Text("本頁為官方新聞稿的摘要整理，完整內容請以來源頁面為準。")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
            }
            .font(.subheadline.weight(.semibold))
            .tint(Color.primaryAction)
        }
    }
}

private struct AwardNewsSection<Content: View>: View {
    let title: String
    let symbol: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: symbol)
                .font(.system(.headline, weight: .bold))
                .foregroundStyle(Color.primaryText)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct AwardFactRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.secondaryText)
                .frame(width: 62, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Color.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    AwardNewsView()
}
