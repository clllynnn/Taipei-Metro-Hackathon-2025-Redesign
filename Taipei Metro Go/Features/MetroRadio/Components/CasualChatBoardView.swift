import SwiftUI

struct CasualChatBoardView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    @State private var draftMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.selectedCategory.title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.metroRadioInk)
                    Text("跨線聊天室 · 路線識別 · 出站自動封存")
                        .font(.system(.caption))
                        .foregroundStyle(Color.metroRadioMutedInk)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ChatCategory.allCases) { category in
                            Button { viewModel.selectedCategory = category } label: {
                                Text(category.title)
                                    .font(.system(.caption, weight: .semibold))
                                    .foregroundStyle(viewModel.selectedCategory == category ? .white : Color.metroRadioMutedInk)
                                    .padding(.horizontal, 12)
                                    .frame(minHeight: 36)
                                    .background(viewModel.selectedCategory == category ? Color.metroRadioIndigo : Color.metroRadioLilac, in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            Divider()

            if viewModel.isCheckedOut {
                VStack(alignment: .leading, spacing: 6) {
                    Text("聊天室已封存")
                        .font(.system(.headline, weight: .semibold))
                        .foregroundStyle(Color.metroRadioInk)
                    Text("您已出站。重新進站後只會看到新的交流內容。")
                        .font(.system(.subheadline))
                        .foregroundStyle(Color.metroRadioMutedInk)
                }
                .padding(18)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if viewModel.visibleCasualMessages.isEmpty {
                            VStack(spacing: 6) {
                                Text("還沒有話題")
                                    .font(.system(.subheadline, weight: .semibold))
                                    .foregroundStyle(Color.metroRadioInk)
                                Text("成為第一位分享搭乘心情的人吧。")
                                    .font(.system(.footnote))
                                    .foregroundStyle(Color.metroRadioMutedInk)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 70)
                        } else {
                            ForEach(Array(viewModel.visibleCasualMessages.enumerated()), id: \.element.id) { index, message in
                                chatRow(message)
                                if index < viewModel.visibleCasualMessages.count - 1 {
                                    Divider().padding(.leading, 18)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color(uiColor: .systemBackground))

                Divider()
                composer
            }
        }
    }

    private var composer: some View {
        HStack(spacing: 9) {
            TextField("傳送到「\(viewModel.selectedCategory.title)」", text: $draftMessage)
                .font(.system(.subheadline))
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .background(Color.metroRadioLilac, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
            Button("送出", action: sendMessage)
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(.white)
                .frame(minWidth: 58, minHeight: 44)
                .background(Color.metroRadioIndigo, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                .disabled(draftMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    private func chatRow(_ message: CasualChatMessage) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: message.lineColorHex))
                    .frame(width: 5, height: 15)
                Text("[\(message.lineName)]")
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(Color(hex: message.lineColorHex))
                Text(message.timestamp, style: .relative)
                    .font(.system(.caption))
                    .foregroundStyle(Color.metroRadioMutedInk)
                Spacer()
            }
            Text(message.message)
                .font(.system(.subheadline))
                .foregroundStyle(Color.metroRadioInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }

    private func sendMessage() {
        viewModel.sendCasualMessage(draftMessage)
        draftMessage = ""
    }
}

private extension Color {
    init(hex: String) {
        let value = UInt64(hex, radix: 16) ?? 0
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}

#Preview {
    CasualChatBoardView(viewModel: MetroRadioViewModel())
        .frame(height: 700)
        .background(Color.metroRadioCanvas)
}
