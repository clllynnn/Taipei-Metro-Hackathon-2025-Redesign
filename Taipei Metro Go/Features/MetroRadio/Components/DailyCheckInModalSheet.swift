import SwiftUI

struct DailyCheckInModalSheet: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    @Environment(\.dismiss) private var dismiss

    private var canSubmit: Bool {
        !viewModel.songDraftTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.songDraftStory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.didCheckInToday
    }

    private var weeklyProgress: Double {
        viewModel.weeklyProgress
    }

    private var daysUntilBonus: Int {
        viewModel.daysUntilWeeklyBonus
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("把今天的旅程，點播成一首歌")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundStyle(Color.metroRadioInk)
                        Text("寫下歌曲陪伴你的時刻，讓通勤路上多一點共鳴。")
                            .font(.system(.subheadline))
                            .foregroundStyle(Color.metroRadioMutedInk)
                    }

                    streakProgressCard

                    VStack(alignment: .leading, spacing: 8) {
                        Text("歌曲名稱")
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(Color.metroRadioInk)
                        TextField("輸入歌名", text: $viewModel.songDraftTitle)
                            .font(.system(.subheadline))
                            .textInputAutocapitalization(.never)
                            .padding(13)
                            .background(Color.metroRadioCream, in: RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("乘車路上，這首歌代表什麼？")
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(Color.metroRadioInk)
                        TextField("分享一段回憶、心情，或陪你通勤的理由…", text: $viewModel.songDraftStory, axis: .vertical)
                            .font(.system(.subheadline))
                            .lineLimit(3...5)
                            .padding(13)
                            .background(Color.metroRadioCream, in: RoundedRectangle(cornerRadius: 12))
                    }

                    Button(action: submit) {
                        HStack {
                            Text(viewModel.didCheckInToday ? "今日已完成簽到" : "登記點播並簽到")
                                .fontWeight(.bold)
                            Spacer()
                            Text("+\(viewModel.nextCheckInReward) 點")
                                .font(.system(.caption2, weight: .bold))
                        }
                        .font(.system(.subheadline))
                        .foregroundStyle(.white)
                        .padding(15)
                        .background(Color.metroRadioCoral, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1 : 0.55)

                    if viewModel.previousSongRequest != nil {
                        Button {
                            viewModel.submitSongCheckIn(reusePrevious: true)
                            closeWhenCheckedIn()
                        } label: {
                            HStack(spacing: 9) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("沿用上次點播紀錄，一鍵簽到")
                                        .font(.system(.subheadline, weight: .semibold))
                                    Text("若今日未中選，帶著上次的歌和故事再來一次")
                                        .font(.system(.footnote))
                                        .foregroundStyle(Color.metroRadioMutedInk)
                                }
                                Spacer(minLength: 0)
                            }
                            .foregroundStyle(Color.metroRadioPlum)
                            .padding(13)
                            .background(Color.metroRadioLilac.opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(viewModel.didCheckInToday)
                        .opacity(viewModel.didCheckInToday ? 0.55 : 1)
                    }

                    Text("簽到會把你的歌曲加入下一次幸運點播抽選。連續簽到天數會提高抽獎權重，最高累積至 50%。")
                        .font(.system(.footnote))
                        .foregroundStyle(Color.metroRadioMutedInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
            }
            .background(Color.metroRadioCanvas)
            .navigationTitle("每日點播簽到")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var streakProgressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("連續簽到")
                    .font(.system(.caption, weight: .semibold))
                    .foregroundStyle(Color.metroRadioCoral)
                Spacer()
                Text("第 \(viewModel.streakDays) 天")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.metroRadioInk)
            }
            ProgressView(value: weeklyProgress)
                .tint(Color.metroRadioCoral)
            HStack {
                Text("目前 \(viewModel.metroPoints) 捷運點")
                Spacer()
                Text("再連續 \(daysUntilBonus) 天領週獎勵")
            }
            .font(.system(.caption2, weight: .medium))
            .foregroundStyle(Color.metroRadioMutedInk)
        }
        .padding(14)
        .background(Color.metroRadioRoseSurface.opacity(0.72), in: RoundedRectangle(cornerRadius: 15))
    }

    private func submit() {
        viewModel.submitSongCheckIn()
        closeWhenCheckedIn()
    }

    private func closeWhenCheckedIn() {
        if viewModel.didCheckInToday { dismiss() }
    }
}

#Preview {
    DailyCheckInModalSheet(viewModel: MetroRadioViewModel())
}
