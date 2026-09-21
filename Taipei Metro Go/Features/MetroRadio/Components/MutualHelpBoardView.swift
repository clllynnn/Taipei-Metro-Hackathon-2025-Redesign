import SwiftUI

struct MutualHelpBoardView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    @State private var selectedMessage: MutualHelpMessage?
    @State private var publicDraft = ""
    @State private var privateDraft = ""

    private let quickRequests = [
        ("路線詢問", "請問有人能幫我確認轉乘路線嗎？"),
        ("上下車提醒", "我下一站要下車，可以麻煩提醒一下嗎？"),
        ("輪椅 / 攜行協助", "需要輪椅或大件行李上下車協助，附近有人方便幫忙嗎？")
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("板南線即時互助")
                        .font(.system(.headline, weight: .semibold))
                        .foregroundStyle(Color.metroRadioInk)
                    Text("同線乘客公開交流 · 車站識別 · 保留 30 分鐘")
                        .font(.system(.caption))
                        .foregroundStyle(Color.metroRadioMutedInk)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(quickRequests, id: \.0) { request in
                            Button { viewModel.sendHelpMessage(request.1) } label: {
                                Text(request.0)
                                    .font(.system(.caption, weight: .semibold))
                                    .foregroundStyle(Color.metroRadioTeal)
                                    .padding(.horizontal, 12)
                                    .frame(minHeight: 36)
                                    .background(Color.metroRadioRoseSurface, in: Capsule())
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isCheckedOut)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            Divider()

            ScrollView {
                LazyVStack(spacing: 0) {
                    Text("私訊僅限同班列車；進入後改用車廂號碼識別，對話會保留。")
                        .font(.system(.caption))
                        .foregroundStyle(Color.metroRadioMutedInk)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)

                    ForEach(Array(viewModel.activeHelpMessages.enumerated()), id: \.element.id) { index, message in
                        helpRow(message)
                        if index < viewModel.activeHelpMessages.count - 1 {
                            Divider().padding(.leading, 18)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(uiColor: .systemBackground))

            Divider()
            publicComposer
        }
        .sheet(item: $selectedMessage, onDismiss: { privateDraft = "" }) { message in
            privateMessageSheet(for: message)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func helpRow(_ message: MutualHelpMessage) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(MetroColor.BL)
                    .frame(width: 4, height: 16)
                Text(message.stationName)
                    .foregroundStyle(MetroColor.BL)
                if let alias = message.publicAlias, !alias.isEmpty {
                    Text(alias)
                        .foregroundStyle(Color.metroRadioMutedInk)
                }
                Text("·")
                Text(message.timestamp, style: .relative)
                    .foregroundStyle(Color.metroRadioMutedInk)
                Spacer(minLength: 0)
                directMessageButton(for: message)
            }
            .font(.system(.caption, weight: .medium))
            Text(message.content)
                .font(.system(.subheadline))
                .foregroundStyle(Color.metroRadioInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
    }

    private var publicComposer: some View {
        HStack(spacing: 9) {
            TextField("傳送到板南線互助頻道", text: $publicDraft)
                .font(.system(.subheadline))
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .background(Color.metroRadioLilac, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
            Button("送出") { sendPublicMessage() }
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(.white)
                .frame(minWidth: 58, minHeight: 44)
                .background(Color.metroRadioBlue, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                .disabled(publicDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    private func directMessageButton(for message: MutualHelpMessage) -> some View {
        if message.isDirectMessage && message.trainID == viewModel.currentTrainID {
            Button { selectedMessage = message } label: {
                Text("私訊中")
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(Color.metroRadioMint)
            }
        } else if viewModel.canStartDirectMessage(with: message) {
            Button {
                selectedMessage = viewModel.startDirectMessage(messageID: message.id)
            } label: {
                Text("私訊")
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(Color.metroRadioBlue)
            }
        } else {
            Text("不同班車")
                .font(.system(.caption2, weight: .medium))
                .foregroundStyle(Color.metroRadioMutedInk)
        }
    }

    private func privateMessageSheet(for message: MutualHelpMessage) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 3) {
                Text("互助私訊")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text("對話會保留，不隨公開群組到期")
                    .font(.system(.subheadline))
                    .foregroundStyle(Color.metroRadioMutedInk)
            }

            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(MetroColor.BL)
                    .frame(width: 4, height: 16)
                Text("車廂 \(message.carriageNumber)")
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(MetroColor.BL)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(Color.metroRadioBlueSurface, in: Capsule())

            ScrollView {
                VStack(alignment: .leading, spacing: 9) {
                    privateBubble(message.content, isOutgoing: false)
                    ForEach(viewModel.directMessageReplies[message.id] ?? [], id: \.self) { reply in
                        privateBubble(reply, isOutgoing: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 8) {
                TextField("傳送一則關心…", text: $privateDraft)
                    .font(.system(.subheadline))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 11)
                    .background(Color.metroRadioCanvas, in: Capsule())
                Button { sendPrivateReply(for: message) } label: {
                    Text("送出")
                        .font(.system(.footnote, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 54, minHeight: 38)
                        .background(Color.metroRadioBlue, in: Capsule())
                }
                .disabled(privateDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            Spacer(minLength: 0)
        }
        .padding(22)
        .padding(.top, 8)
        .background(Color.metroRadioCanvas)
    }

    private func privateBubble(_ text: String, isOutgoing: Bool) -> some View {
        Text(text)
            .font(.system(.subheadline))
            .foregroundStyle(isOutgoing ? .white : Color.metroRadioInk)
            .padding(11)
            .background(isOutgoing ? Color.metroRadioBlue : Color.metroRadioCanvas, in: RoundedRectangle(cornerRadius: 13))
            .frame(maxWidth: .infinity, alignment: isOutgoing ? .trailing : .leading)
    }

    private func sendPrivateReply(for message: MutualHelpMessage) {
        let reply = privateDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !reply.isEmpty else { return }
        viewModel.sendDirectMessage(reply, to: message.id)
        privateDraft = ""
    }

    private func sendPublicMessage() {
        viewModel.sendHelpMessage(publicDraft)
        publicDraft = ""
    }
}

#Preview {
    MutualHelpBoardView(viewModel: MetroRadioViewModel())
        .frame(height: 700)
        .background(Color.metroRadioCanvas)
}
