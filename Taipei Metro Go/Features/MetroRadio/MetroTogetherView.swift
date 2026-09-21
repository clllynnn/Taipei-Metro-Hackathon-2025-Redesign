import SwiftUI

private enum MetroTogetherSection: String, CaseIterable, Identifiable {
    case mutualHelp = "共乘互助"
    case casualChat = "社群閒聊"

    var id: String { rawValue }

    var accent: Color {
        switch self {
        case .mutualHelp: .metroRadioBlue
        case .casualChat: .metroRadioMint
        }
    }
}

@MainActor
struct MetroTogetherView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    var language: AppLanguage = .traditionalChinese
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection: MetroTogetherSection = .mutualHelp

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(MetroRadioCopy.communityTitle(for: language))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.metroRadioInk)
                    Text("捷客電台 · 即時乘客頻道")
                        .font(.system(.caption))
                        .foregroundStyle(Color.metroRadioMutedInk)
                }
                Spacer()
                Button("返回電台") { dismiss() }
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(Color.metroRadioBlue)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            HStack(spacing: 0) {
                ForEach(MetroTogetherSection.allCases) { section in
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) { selectedSection = section }
                    } label: {
                        VStack(spacing: 9) {
                            Text(section.rawValue)
                                .font(.system(.subheadline, weight: selectedSection == section ? .semibold : .medium))
                                .foregroundStyle(selectedSection == section ? Color.metroRadioInk : Color.metroRadioMutedInk)
                            Capsule()
                                .fill(selectedSection == section ? section.accent : Color.clear)
                                .frame(height: 3)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)
            .background(Color(uiColor: .systemBackground))

            Divider()

            Group {
                switch selectedSection {
                case .mutualHelp:
                    MutualHelpBoardView(viewModel: viewModel)
                case .casualChat:
                    CasualChatBoardView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: 620, maxHeight: .infinity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.metroRadioCanvas.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
}

#Preview {
    MetroTogetherView(viewModel: MetroRadioViewModel())
}
