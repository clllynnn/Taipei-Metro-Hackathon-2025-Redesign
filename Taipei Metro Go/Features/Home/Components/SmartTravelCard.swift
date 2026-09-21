import SwiftUI

struct SmartTravelCard: View {
    @ScaledMetric(relativeTo: .largeTitle) private var countdownFontSize = 58
    let state: SmartTravelState
    let language: AppLanguage
    var isCompact = false
    var favoriteDestinations: [HomeFavoriteDestination] = []
    var selectableStations: [Station] = []
    var onAdjustRoute: () -> Void
    var onSwapRoute: () -> Void = {}
    var onSelectOrigin: (String) -> Void = { _ in }
    var onSelectDestination: (String) -> Void = { _ in }
    @State private var isDestinationPickerPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 10 : 14) {
            LocationContextBanner(state: state, language: language, isCompact: isCompact)

            routeSelection

            sectionDivider

            arrivalHero

            sectionDivider

            routeAction
        }
        .padding(isCompact ? 13 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(MetroColor.color(for: state.originLine), lineWidth: isCompact ? 2.5 : 3)
        }
        .shadow(color: .black.opacity(0.04), radius: 10, y: 4)
    }

    private var arrivalHero: some View {
        VStack(alignment: .leading, spacing: isCompact ? 8 : 10) {
            HStack(alignment: .bottom, spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(towardLabel)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.secondaryText)
                    Text(directionDestination)
                        .font(.system(size: isCompact ? 21 : 24, weight: .bold, design: .default))
                        .foregroundStyle(Color.primaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }
                .layoutPriority(1)

                Spacer(minLength: 6)

                VStack(alignment: .trailing, spacing: 2) {
                    updateTrustLabel

                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        let elapsed = max(0, Int(context.date.timeIntervalSince(state.arrivalInfo.updatedAt)))
                        let remaining = max(0, state.arrivalInfo.countdownSeconds - elapsed)
                        countdownPresentation(remaining: remaining)
                    }
                }
            }

            if state.arrivalInfo.status == .live {
                TrainCrowdednessView(arrivalInfo: state.arrivalInfo, language: language)
            }
        }
    }

    private var updateTrustLabel: some View {
        HStack(spacing: 5) {
            Image(systemName: "circle.fill")
                .font(.system(size: 7))
                .foregroundStyle(trustColor)
                .symbolEffect(.pulse, value: state.arrivalInfo.updatedAt)
            Text("\(HomeCopy.text(.updatedAt, language: language)) \(state.arrivalInfo.updatedAt.formatted(date: .omitted, time: .shortened))")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Color.secondaryText)
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
    }

    private var trustColor: Color {
        switch state.arrivalInfo.status {
        case .live: .crowdingLow
        case .loading: .crowdingModerate
        case .noNetwork, .serviceEnded: .secondaryText
        }
    }

    @ViewBuilder
    private func countdownPresentation(remaining: Int) -> some View {
        switch state.arrivalInfo.status {
        case .loading:
            unavailableCountdown(
                label: HomeCopy.text(.loadingTrainData, language: language),
                symbol: "arrow.triangle.2.circlepath"
            )
        case .noNetwork:
            unavailableCountdown(
                label: HomeCopy.text(.noNetwork, language: language),
                symbol: "wifi.slash"
            )
        case .serviceEnded:
            unavailableCountdown(
                label: HomeCopy.text(.serviceEnded, language: language),
                symbol: "moon.zzz.fill"
            )
        case .live where remaining == 0:
            Text(approachingDisplayText)
                .font(.system(size: countdownValueFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.70)
                .frame(minHeight: countdownValueHeight, alignment: .trailing)
                .accessibilityLabel(HomeCopy.text(.trainApproaching, language: language))
        case .live:
            Text(String(format: "%02d:%02d", remaining / 60, remaining % 60))
                .font(.system(size: countdownValueFontSize, weight: .bold, design: .monospaced))
                .monospacedDigit()
                .foregroundStyle(Color.black)
                .contentTransition(.numericText())
                .frame(minHeight: countdownValueHeight, alignment: .trailing)
                .accessibilityLabel("\(remaining / 60) \(HomeCopy.text(.minutes, language: language)) \(remaining % 60) \(HomeCopy.text(.seconds, language: language))")
        }
    }

    private func unavailableCountdown(label: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Text("—")
                .font(.system(size: 48, weight: .bold, design: .rounded))
            Label(label, systemImage: symbol)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
        }
        .foregroundStyle(Color.secondaryText)
        .frame(minHeight: 66)
        .accessibilityElement(children: .combine)
    }

    private var routeSelection: some View {
        HStack(spacing: 7) {
            stationMenu(
                title: HomeCopy.text(.origin, language: language),
                stationName: state.currentStation,
                line: state.originLine,
                routeCode: state.originStationCode,
                onSelect: onSelectOrigin
            )

            Button(action: onSwapRoute) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.primaryAction)
                    .frame(width: 44, height: 44)
                    .background(Color.softSurface, in: Circle())
                    .overlay {
                        Circle().stroke(Color.line.opacity(0.55), lineWidth: 1)
                    }
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(swapRouteLabel)

            stationMenu(
                title: HomeCopy.text(.destination, language: language),
                stationName: state.destinationStation,
                line: state.destinationLine,
                routeCode: state.destinationStationCode,
                onSelect: onSelectDestination
            )
        }
    }

    private func stationMenu(
        title: String,
        stationName: String,
        line: MetroLine,
        routeCode: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        Menu {
            ForEach(selectableStations) { station in
                Button {
                    onSelect(station.name)
                } label: {
                    Text(HomeCopy.stationName(station.name, language: language))
                }
            }
        } label: {
            HStack(spacing: 10) {
                MetroLineBadge(
                    line: line,
                    routeCode: routeCode,
                    showsLineName: false,
                    compact: false,
                    style: .solidVertical
                )
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.secondaryText)
                    Text(stationDisplayName(stationName))
                        .font(stationNameFont)
                        .foregroundStyle(Color.primaryText)
                        .lineLimit(stationLineLimit(stationName))
                        .minimumScaleFactor(0.68)
                }
                .layoutPriority(1)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, isCompact ? 6 : 10)
            .frame(maxWidth: .infinity, minHeight: isCompact ? 88 : 102, alignment: .leading)
            .background(Color.secondarySurface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.line.opacity(0.55), lineWidth: 1)
            }
        }
        .accessibilityLabel("\(title)：\(HomeCopy.stationName(stationName, language: language))")
    }

    private var routeAction: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                withAnimation(.easeInOut(duration: 0.18)) { isDestinationPickerPresented.toggle() }
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text(HomeCopy.text(.routeChange, language: language))
                    Spacer()
                    Image(systemName: isDestinationPickerPresented ? "chevron.up" : "chevron.right")
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.primaryAction)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(HomeCopy.text(.routeChange, language: language))

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                ForEach(favoriteDestinations) { destination in
                    Button {
                        if destination.opensRoutePlanner {
                            onAdjustRoute()
                        } else {
                            onSelectDestination(destination.station)
                        }
                    } label: {
                        Text(HomeCopy.favoriteTitle(destination.id, fallback: destination.title, language: language))
                            .lineLimit(1)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Color.primaryText)
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.secondarySurface, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.line.opacity(0.45), lineWidth: 1)
                            }
                    }
                    .buttonStyle(HomeShortcutButtonStyle())
                    .accessibilityLabel(favoriteAccessibilityLabel(destination))
                }
            }
        }
        .popover(
            isPresented: $isDestinationPickerPresented,
            attachmentAnchor: .rect(.bounds),
            arrowEdge: .top
        ) {
            DestinationSwitchSection(
                destinations: favoriteDestinations,
                language: language,
                isPresented: $isDestinationPickerPresented,
                onSelect: onSelectDestination,
                onOpenRoutePlanner: onAdjustRoute
            )
            .frame(width: 340)
            .padding(8)
            .presentationCompactAdaptation(.popover)
        }
    }

    private var swapRouteLabel: String {
        switch language {
        case .traditionalChinese: "交換起點與終點"
        case .english: "Swap origin and destination"
        case .japanese: "出発駅と目的地を入れ替える"
        case .korean: "출발지와 목적지 바꾸기"
        }
    }

    private var sectionDivider: some View {
        Rectangle()
            .fill(Color.line.opacity(0.48))
            .frame(height: 0.5)
    }

    private var towardLabel: String {
        switch language {
        case .traditionalChinese: "往"
        case .english: "Toward"
        case .japanese: "方面"
        case .korean: "방면"
        }
    }

    private var countdownValueFontSize: CGFloat {
        isCompact ? min(countdownFontSize, 44) : min(countdownFontSize, 50)
    }

    /// Both station selectors use the same fixed type scale so route direction
    /// never changes the visual weight of the origin or destination.
    private var stationNameFont: Font {
        .system(size: isCompact ? 24 : 28, weight: .bold, design: .default)
    }

    private var countdownValueHeight: CGFloat {
        isCompact ? 52 : 60
    }

    private var approachingDisplayText: String {
        switch language {
        case .traditionalChinese: "進站中"
        case .english: "Arriving"
        case .japanese: "到着中"
        case .korean: "진입 중"
        }
    }

    private var directionDestination: String {
        let direction = state.arrivalInfo.direction
        switch language {
        case .traditionalChinese:
            return direction.hasPrefix("往") ? String(direction.dropFirst()) : direction
        case .english:
            return direction.hasPrefix("Toward ") ? String(direction.dropFirst("Toward ".count)) : direction
        case .japanese:
            return direction.hasSuffix("方面") ? String(direction.dropLast(2)) : direction
        case .korean:
            return direction.hasSuffix(" 방면") ? String(direction.dropLast(3)) : direction
        }
    }

    private func stationDisplayName(_ stationName: String) -> String {
        let localizedName = HomeCopy.stationName(stationName, language: language)
        guard language == .traditionalChinese, localizedName.count > 3 else {
            return localizedName
        }
        if localizedName.hasSuffix("車站") {
            return "\(localizedName.dropLast(2))\n車站"
        }
        let splitOffset = (localizedName.count + 1) / 2
        let splitIndex = localizedName.index(localizedName.startIndex, offsetBy: splitOffset)
        return "\(localizedName[..<splitIndex])\n\(localizedName[splitIndex...])"
    }

    private func stationLineLimit(_ stationName: String) -> Int {
        let localizedName = HomeCopy.stationName(stationName, language: language)
        return language == .traditionalChinese && localizedName.count > 3 ? 2 : 1
    }

    private func favoriteAccessibilityLabel(_ destination: HomeFavoriteDestination) -> String {
        let title = HomeCopy.favoriteTitle(destination.id, fallback: destination.title, language: language)
        guard !destination.opensRoutePlanner else { return title }
        return "\(title)，\(HomeCopy.stationName(destination.station, language: language))"
    }
}

private struct HomeShortcutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.72 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

@MainActor
private struct SmartTravelCardInteractivePreview: View {
    @StateObject private var viewModel = HomeViewModel(travelState: TravelState.mock)

    var body: some View {
        SmartTravelCard(
            state: viewModel.smartTravelState,
            language: viewModel.currentLanguage,
            favoriteDestinations: viewModel.favoriteDestinations,
            selectableStations: viewModel.selectableStations,
            onAdjustRoute: {},
            onSwapRoute: viewModel.swapRoute,
            onSelectOrigin: viewModel.updateOrigin,
            onSelectDestination: viewModel.updateDestination
        )
        .padding(20)
        .background(Color.pageBackground)
    }
}

#Preview("倒數、起訖點與車廂推薦") {
    SmartTravelCardInteractivePreview()
}

#Preview("列車進站中") {
    let viewModel = HomeViewModel(travelState: TravelState())
    var state = viewModel.smartTravelState
    state.arrivalInfo.countdownSeconds = 0
    state.arrivalInfo.updatedAt = .now
    return SmartTravelCard(
        state: state,
        language: .traditionalChinese,
        favoriteDestinations: viewModel.favoriteDestinations,
        selectableStations: viewModel.selectableStations,
        onAdjustRoute: {}
    )
    .padding()
    .background(Color.pageBackground)
}

#Preview("無網路") {
    let viewModel = HomeViewModel(travelState: TravelState())
    var state = viewModel.smartTravelState
    state.arrivalInfo.status = .noNetwork
    return SmartTravelCard(
        state: state,
        language: .traditionalChinese,
        favoriteDestinations: viewModel.favoriteDestinations,
        selectableStations: viewModel.selectableStations,
        onAdjustRoute: {}
    )
    .padding()
    .background(Color.pageBackground)
}

#Preview("資料載入中") {
    let viewModel = HomeViewModel(travelState: TravelState())
    var state = viewModel.smartTravelState
    state.arrivalInfo.status = .loading
    return SmartTravelCard(
        state: state,
        language: .traditionalChinese,
        favoriteDestinations: viewModel.favoriteDestinations,
        selectableStations: viewModel.selectableStations,
        onAdjustRoute: {}
    )
    .padding()
    .background(Color.pageBackground)
}

#Preview("末班車已過") {
    let viewModel = HomeViewModel(travelState: TravelState())
    var state = viewModel.smartTravelState
    state.arrivalInfo.status = .serviceEnded
    return SmartTravelCard(
        state: state,
        language: .traditionalChinese,
        favoriteDestinations: viewModel.favoriteDestinations,
        selectableStations: viewModel.selectableStations,
        onAdjustRoute: {}
    )
    .padding()
    .background(Color.pageBackground)
}
