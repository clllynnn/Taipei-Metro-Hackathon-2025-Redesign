import SwiftUI

struct MetroAudioWaveformView: View {
    let isPlaying: Bool
    var height: CGFloat = 34

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let barCount = 28

    var body: some View {
        Group {
            if isPlaying && !reduceMotion {
                TimelineView(.animation(minimumInterval: 0.05)) { context in
                    waveform(phase: context.date.timeIntervalSinceReferenceDate)
                }
            } else {
                waveform(phase: 0)
            }
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }

    private func waveform(phase: TimeInterval) -> some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 3
            let availableWidth = geometry.size.width - spacing * CGFloat(barCount - 1)
            let barWidth = max(2, availableWidth / CGFloat(barCount))

            HStack(alignment: .center, spacing: spacing) {
                ForEach(0..<barCount, id: \.self) { index in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.metroRadioSky, Color.metroRadioTeal],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(
                            width: barWidth,
                            height: barHeight(index: index, phase: phase, maximum: geometry.size.height)
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func barHeight(index: Int, phase: TimeInterval, maximum: CGFloat) -> CGFloat {
        let position = Double(index) / Double(max(barCount - 1, 1))
        let envelope = 0.56 + 0.44 * sin(position * .pi)

        if !isPlaying || reduceMotion {
            let restingShape = 0.18 + 0.12 * abs(sin(Double(index) * 0.72))
            return max(5, maximum * restingShape * envelope)
        }

        let primary = abs(sin(phase * 3.2 + Double(index) * 0.58))
        let secondary = abs(cos(phase * 1.8 - Double(index) * 0.31))
        let energy = 0.18 + 0.52 * primary + 0.30 * secondary
        return max(5, maximum * min(energy * envelope, 1))
    }
}

#Preview("播放中") {
    MetroAudioWaveformView(isPlaying: true)
        .padding()
        .background(Color.metroRadioNavy)
}

#Preview("已暫停") {
    MetroAudioWaveformView(isPlaying: false)
        .padding()
        .background(Color.metroRadioNavy)
}
