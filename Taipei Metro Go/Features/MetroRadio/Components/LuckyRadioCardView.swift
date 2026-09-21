import SwiftUI

struct LuckyRadioCardView: View {
    @ObservedObject var viewModel: MetroRadioViewModel
    @State private var isShowingCheckIn = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let song = viewModel.currentSong {
                HStack(spacing: 8) {
                    Text(viewModel.timeMood.playerKicker)
                        .font(.system(.caption, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.76))
                    Spacer(minLength: 6)
                    Circle()
                        .fill(song.isPlaying ? Color.metroRadioTeal : Color.metroRadioSky)
                        .frame(width: 7, height: 7)
                    Text(song.isPlaying ? "同步播放" : "已暫停")
                        .font(.system(.caption, weight: .semibold))
                }

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(song.title)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        HStack(spacing: 5) {
                            Text(song.artist)
                            Text("·")
                            Text(song.stationName)
                                .lineLimit(1)
                        }
                        .font(.system(.caption, weight: .medium))
                        .opacity(0.82)
                    }
                    Spacer(minLength: 0)
                    Button(action: viewModel.togglePlay) {
                        Image(systemName: song.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Color.metroRadioPlum)
                            .frame(width: 42, height: 42)
                            .background(Color.metroRadioCream, in: Circle())
                            .shadow(color: Color.metroRadioPlum.opacity(0.18), radius: 8, y: 4)
                    }
                    .accessibilityLabel(song.isPlaying ? "暫停播放" : "開始播放")
                }

                MetroAudioWaveformView(isPlaying: song.isPlaying, height: 26)

                VStack(alignment: .leading, spacing: 4) {
                    Text("這首歌的陪伴")
                        .font(.system(.caption, weight: .semibold))
                        .foregroundStyle(Color.metroRadioSky.opacity(0.94))
                    Text("「\(song.requesterStory)」")
                        .font(.system(.footnote))
                        .lineSpacing(2)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button {
                    viewModel.prepareSongDraftForPresentation()
                    isShowingCheckIn = true
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(viewModel.checkInButtonTitle)
                                .font(.system(.subheadline, weight: .semibold))
                            Text(viewModel.checkInButtonSubtitle)
                                .font(.system(.caption))
                                .foregroundStyle(Color.metroRadioMutedInk)
                        }
                        Spacer()
                        Text(viewModel.didCheckInToday ? "已登記" : "+\(viewModel.nextCheckInReward) 點")
                            .font(.system(.caption, weight: .semibold))
                            .foregroundStyle(Color.metroRadioBlue)
                    }
                    .foregroundStyle(Color.metroRadioPlum)
                    .padding(.horizontal, 15)
                    .frame(minHeight: 52)
                    .background(Color.metroRadioCream, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
            }
        }
        .foregroundStyle(.white)
        .padding(16)
        .background(
            LinearGradient(
                colors: viewModel.timeMood.playerColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        }
        .shadow(color: Color.metroRadioBerry.opacity(0.20), radius: 13, y: 7)
        .sheet(isPresented: $isShowingCheckIn) {
            DailyCheckInModalSheet(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    LuckyRadioCardView(viewModel: MetroRadioViewModel())
        .padding()
        .background(Color.metroRadioCanvas)
}
