import SwiftUI

/// Read-only context header. Location simulation is intentionally kept out of this banner.
struct LocationContextBanner: View {
    let state: SmartTravelState
    let language: AppLanguage
    var isCompact = false

    var body: some View {
        HStack {
            Text("\(HomeCopy.text(.location, language: language))：\(HomeCopy.stationName(state.currentStation, language: language))")
                .font(.subheadline.weight(.bold))
            Spacer(minLength: 0)
        }
        .foregroundStyle(Color.secondaryText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(HomeCopy.text(.location, language: language))：\(HomeCopy.stationName(state.currentStation, language: language))")
    }
}

#Preview {
    LocationContextBanner(
        state: HomeViewModel(travelState: TravelState.mock).smartTravelState,
        language: .traditionalChinese
    )
        .padding()
        .background(Color.pageBackground)
}
