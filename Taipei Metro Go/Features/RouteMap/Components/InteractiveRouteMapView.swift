import SwiftUI

/// Lightweight, native route map. It recreates the official network geometry with
/// SwiftUI paths and keeps every station as an independently tappable node.
struct InteractiveMapView: View {
    let stations: [Station]
    let currentStation: Station?
    let destinationStation: Station?
    var language: AppLanguage = .traditionalChinese
    var onSelectStation: (Station) -> Void

    @State private var zoom: CGFloat = 0.66
    @State private var zoomBase: CGFloat = 0.66
    @State private var resetZoom: CGFloat = 0.66
    @State private var resetOffset: CGSize = .zero
    @State private var hasConfiguredViewport = false
    @State private var mapOffset: CGSize = .zero
    @GestureState private var dragTranslation: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            let viewport = geometry.size
            let mapSize = mapCanvasSize(for: viewport)
            let positions = OfficialRouteMapLayout.stationPositions
            let routeInverseZoom = 1 / max(zoom, 0.01)
            // Keep the accepted route geometry untouched. Only station chrome
            // becomes slightly smaller at overview scales to add breathing room.
            let contentInverseZoom = 1 / max(zoom, MapContentMetrics.fullSizeZoom)
            let labelPositions = makeLabelPositions(
                size: mapSize,
                positions: positions,
                inverseScale: contentInverseZoom
            )

            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()

                mapSurface(
                    size: mapSize,
                    positions: positions,
                    labelPositions: labelPositions,
                    routeInverseZoom: routeInverseZoom,
                    contentInverseZoom: contentInverseZoom
                )
                .frame(width: mapSize.width, height: mapSize.height)
                .scaleEffect(zoom)
                .offset(
                    x: mapOffset.width + dragTranslation.width,
                    y: mapOffset.height + dragTranslation.height
                )
                .frame(width: viewport.width, height: viewport.height)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 12)
                        .updating($dragTranslation) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            mapOffset.width += value.translation.width
                            mapOffset.height += value.translation.height
                        }
                )
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged {
                            zoom = min(max($0 * zoomBase, MapContentMetrics.minimumZoom), MapContentMetrics.maximumZoom)
                        }
                        .onEnded { _ in zoomBase = zoom }
                )

                mapControls
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(14)
                    .zIndex(3)
            }
            .frame(width: viewport.width, height: viewport.height)
            .clipped()
            .animation(.easeInOut(duration: 0.18), value: destinationStation)
            .onAppear {
                configureViewport(viewport: viewport, mapSize: mapSize)
            }
            .onChange(of: viewport) { _, newViewport in
                configureViewport(viewport: newViewport, mapSize: mapCanvasSize(for: newViewport), force: true)
            }
        }
        .accessibilityLabel("可拖曳與縮放的台北捷運路線圖")
    }

    private func mapSurface(
        size: CGSize,
        positions: [String: CGPoint],
        labelPositions: [String: CGPoint],
        routeInverseZoom: CGFloat,
        contentInverseZoom: CGFloat
    ) -> some View {
        ZStack {
            Canvas { context, canvasSize in
                for route in MetroRoute.mockNetwork {
                    for segment in route.stationIDSegments {
                        let points = routeDrawingPoints(
                            for: segment,
                            line: route.line,
                            positions: positions,
                            canvasSize: canvasSize
                        )
                        guard points.count > 1 else { continue }
                        // Orange contains several compact line-only corners.
                        // Keep its full point list so simplification cannot
                        // turn those vertical-horizontal bends into diagonals.
                        let routePoints = route.line == .orange
                            ? points
                            : simplifiedPolyline(points)
                        // 折角若位於車站，路線必須穿過節點正中央；只有沒有
                        // 站點的轉向錨點使用一般圓弧。圓角線帽仍會讓站點下方
                        // 的轉向保持圓潤，不會讓節點落在弧線內側。
                        let stationCorners = stationCornerPoints(
                            in: routePoints,
                            stationIDs: segment,
                            positions: positions,
                            canvasSize: canvasSize
                        )
                        let lineColor = route.line == .green && segment == ["七張", "小碧潭"]
                            ? MetroColor.G03A
                            : MetroColor.color(for: route.line)
                        context.stroke(
                            roundedPolyline(
                                routePoints,
                                radius: 18 * routeInverseZoom,
                                centeredStationCorners: stationCorners
                            ),
                            with: .color(lineColor.opacity(0.92)),
                            style: StrokeStyle(lineWidth: 5.2 * routeInverseZoom, lineCap: .round, lineJoin: .round)
                        )
                    }
                }
            }

            ForEach(stations) { station in
                if let position = positions[station.id] {
                    let center = CGPoint(x: position.x * size.width, y: position.y * size.height)

                    if let labelPosition = labelPositions[station.id] {
                        stationLabel(station)
                            .scaleEffect(contentInverseZoom)
                            .position(labelPosition)
                            .allowsHitTesting(false)
                            .zIndex(1)
                    }

                    stationNode(station)
                        .scaleEffect(contentInverseZoom)
                        .position(center)
                        .zIndex(2)
                }
            }
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            SpatialTapGesture()
                .onEnded { value in
                    selectStation(
                        nearestTo: value.location,
                        size: size,
                        positions: positions,
                        inverseZoom: routeInverseZoom
                    )
                }
        )
    }

    private func stationNode(_ station: Station) -> some View {
        let lines = servingLines(for: station)
        let isDestination = station.id == destinationStation?.id
        let isCurrent = station.id == currentStation?.id
        let colors = station.id == "小碧潭"
            ? [MetroColor.G03A]
            : lines.map { MetroColor.color(for: $0) }

        return ZStack {
            if colors.count > 1 {
                RoundedRectangle(cornerRadius: StationNodeMetrics.cornerRadius, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .frame(
                        width: StationNodeMetrics.markerSize.width,
                        height: StationNodeMetrics.markerSize.height
                    )
                    .overlay {
                        SplitStationMarker(
                            firstColor: colors[0],
                            secondColor: colors[1],
                            lineWidth: 2.5
                        )
                    }
            } else {
                RoundedRectangle(cornerRadius: StationNodeMetrics.cornerRadius, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .frame(
                        width: StationNodeMetrics.markerSize.width,
                        height: StationNodeMetrics.markerSize.height
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: StationNodeMetrics.cornerRadius, style: .continuous)
                            .stroke(colors.first ?? MetroColor.color(for: station.line), lineWidth: 2)
                    }
            }

            // Keep the current location visible without the old black halo.
            if isCurrent {
                Image(systemName: "location.fill")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Color(uiColor: .systemBlue))
                    .padding(2.5)
                    .background(Color(uiColor: .systemBackground), in: Circle())
                    .shadow(color: .black.opacity(0.16), radius: 2, y: 1)
                    .offset(x: 17, y: -14)
            }
            if isDestination {
                RoundedRectangle(cornerRadius: StationNodeMetrics.selectionCornerRadius, style: .continuous)
                    .stroke(colors.first ?? MetroColor.color(for: station.line), lineWidth: 2.5)
                    .frame(
                        width: StationNodeMetrics.selectionSize.width,
                        height: StationNodeMetrics.selectionSize.height
                    )
            }
        }
        .frame(width: StationNodeMetrics.tapSize.width, height: StationNodeMetrics.tapSize.height)
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("選擇\(station.name)，\(lines.map(\.rawValue).joined(separator: "、"))線")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { onSelectStation(station) }
    }

    /// A single hit-test layer assigns each tap to only the nearest station.
    /// This keeps the effective 44 x 44 point targets from stacking over one
    /// another around dense interchanges while retaining a comfortable target.
    private func selectStation(
        nearestTo location: CGPoint,
        size: CGSize,
        positions: [String: CGPoint],
        inverseZoom: CGFloat
    ) {
        let halfWidth = StationNodeMetrics.tapSize.width / 2 * inverseZoom
        let halfHeight = StationNodeMetrics.tapSize.height / 2 * inverseZoom
        let candidates = stations.compactMap { station -> (Station, CGFloat)? in
            guard let position = positions[station.id] else { return nil }
            let center = CGPoint(x: position.x * size.width, y: position.y * size.height)
            let dx = abs(location.x - center.x)
            let dy = abs(location.y - center.y)
            guard dx <= halfWidth, dy <= halfHeight else { return nil }
            return (station, hypot(dx / halfWidth, dy / halfHeight))
        }
        guard let station = candidates.min(by: { $0.1 < $1.1 })?.0 else { return }
        onSelectStation(station)
    }

    private func stationLabel(_ station: Station) -> some View {
        let isDestination = station.id == destinationStation?.id
        let isCurrent = station.id == currentStation?.id
        let routeColor = station.id == "小碧潭"
            ? MetroColor.G03A
            : MetroColor.color(for: servingLines(for: station).first ?? station.line)
        let weight: Font.Weight = isDestination || isCurrent ? .semibold : .regular

        return Text(station.mapName(for: language))
            .font(.system(size: 9, weight: weight, design: .rounded))
            .foregroundStyle(isDestination ? Color.white : isCurrent ? Color(uiColor: .systemBlue) : Color.primary)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 3)
            .padding(.vertical, 1)
            .background(
                isDestination ? routeColor : Color(uiColor: .systemBackground).opacity(0.97),
                in: RoundedRectangle(cornerRadius: 4, style: .continuous)
            )
    }

    private func servingLines(for station: Station) -> [MetroLine] {
        var result = station.lines
        for line in MetroRoute.mockNetwork
            .filter({ route in route.stationIDSegments.contains { $0.contains(station.id) } })
            .map(\.line)
            where !result.contains(line) {
            result.append(line)
        }
        return result
    }

    private func makeLabelPositions(
        size: CGSize,
        positions: [String: CGPoint],
        inverseScale: CGFloat
    ) -> [String: CGPoint] {
        let stationsWithCenters = stations.compactMap { station -> (Station, CGPoint)? in
            guard let point = positions[station.id] else { return nil }
            return (station, CGPoint(x: point.x * size.width, y: point.y * size.height))
        }
        let markerRects = stationsWithCenters.reduce(into: [String: CGRect]()) { result, item in
            result[item.0.id] = CGRect(
                x: item.1.x - StationNodeMetrics.labelClearanceSize.width / 2 * inverseScale,
                y: item.1.y - StationNodeMetrics.labelClearanceSize.height / 2 * inverseScale,
                width: StationNodeMetrics.labelClearanceSize.width * inverseScale,
                height: StationNodeMetrics.labelClearanceSize.height * inverseScale
            )
        }
        let ordered = stationsWithCenters.sorted { labelPriority(for: $0.0) > labelPriority(for: $1.0) }
        var occupied: [CGRect] = []
        var result: [String: CGPoint] = [:]

        for (station, center) in ordered {
            let width = max(CGFloat(station.mapName(for: language).count) * 9 + 6, 30) * inverseScale
            let labelSize = CGSize(width: width, height: 15 * inverseScale)
            // Follow one predictable rule without touching route geometry:
            // horizontal -> below; vertical or diagonal -> right.
            let side: LabelSide = isHorizontal(station, positions: positions) ? .bottom : .right
            // Keep each name on its prescribed side. When the default place
            // is busy, shift it along that side before considering the next
            // station: below a horizontal run, or to the right of a vertical
            // or diagonal run. No station name is omitted at overview scale.
            let offsets: [CGFloat] = [
                0, -12, 12, -24, 24, -36, 36, -50, 50, -66, 66, -84, 84,
                -104, 104, -128, 128
            ].map { $0 * inverseScale }

            var chosen: (center: CGPoint, rect: CGRect)?
            for offset in offsets {
                let candidate = side.center(
                    from: center,
                    labelSize: labelSize,
                    gap: 5 * inverseScale,
                    offset: offset,
                    scale: inverseScale
                )
                let rect = CGRect(
                    x: candidate.x - labelSize.width / 2 - 2,
                    y: candidate.y - labelSize.height / 2 - 2,
                    width: labelSize.width + 4,
                    height: labelSize.height + 4
                )
                let collides = occupied.contains { $0.intersects(rect) }
                    || markerRects.contains { $0.key != station.id && $0.value.intersects(rect) }
                if !collides {
                    chosen = (candidate, rect)
                    break
                }
            }

            if let chosen {
                result[station.id] = chosen.center
                occupied.append(chosen.rect)
            } else {
                // This preserves the all-stations-visible contract even if a
                // unusually dense custom map exhausts every offset above.
                let candidate = side.center(
                    from: center,
                    labelSize: labelSize,
                    gap: 5 * inverseScale,
                    scale: inverseScale
                )
                result[station.id] = candidate
                occupied.append(CGRect(
                    x: candidate.x - labelSize.width / 2 - 2,
                    y: candidate.y - labelSize.height / 2 - 2,
                    width: labelSize.width + 4,
                    height: labelSize.height + 4
                ))
            }
        }
        return result
    }

    private func labelPriority(for station: Station) -> Int {
        if station.id == destinationStation?.id { return 4 }
        if station.id == currentStation?.id { return 3 }
        if servingLines(for: station).count > 1 { return 2 }
        return 1
    }

    private func segmentIntersects(from start: CGPoint, to end: CGPoint, rect: CGRect) -> Bool {
        if rect.contains(start) || rect.contains(end) { return true }
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        return lineSegmentsIntersect(start, end, topLeft, topRight)
            || lineSegmentsIntersect(start, end, topRight, bottomRight)
            || lineSegmentsIntersect(start, end, bottomRight, bottomLeft)
            || lineSegmentsIntersect(start, end, bottomLeft, topLeft)
    }

    private func lineSegmentsIntersect(
        _ firstStart: CGPoint,
        _ firstEnd: CGPoint,
        _ secondStart: CGPoint,
        _ secondEnd: CGPoint
    ) -> Bool {
        func cross(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
            (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
        }
        func point(_ point: CGPoint, liesOn start: CGPoint, _ end: CGPoint) -> Bool {
            let epsilon: CGFloat = 0.001
            return abs(cross(start, end, point)) <= epsilon
                && point.x >= min(start.x, end.x) - epsilon
                && point.x <= max(start.x, end.x) + epsilon
                && point.y >= min(start.y, end.y) - epsilon
                && point.y <= max(start.y, end.y) + epsilon
        }
        let firstSideA = cross(firstStart, firstEnd, secondStart)
        let firstSideB = cross(firstStart, firstEnd, secondEnd)
        let secondSideA = cross(secondStart, secondEnd, firstStart)
        let secondSideB = cross(secondStart, secondEnd, firstEnd)
        let epsilon: CGFloat = 0.001

        if abs(firstSideA) <= epsilon, point(secondStart, liesOn: firstStart, firstEnd) { return true }
        if abs(firstSideB) <= epsilon, point(secondEnd, liesOn: firstStart, firstEnd) { return true }
        if abs(secondSideA) <= epsilon, point(firstStart, liesOn: secondStart, secondEnd) { return true }
        if abs(secondSideB) <= epsilon, point(firstEnd, liesOn: secondStart, secondEnd) { return true }

        let firstStraddles = (firstSideA > epsilon && firstSideB < -epsilon)
            || (firstSideA < -epsilon && firstSideB > epsilon)
        let secondStraddles = (secondSideA > epsilon && secondSideB < -epsilon)
            || (secondSideA < -epsilon && secondSideB > epsilon)
        return firstStraddles && secondStraddles
    }

    private func isHorizontal(_ station: Station, positions: [String: CGPoint]) -> Bool {
        guard let center = positions[station.id] else { return false }
        let neighbors = MetroRoute.mockNetwork.flatMap { route in
            route.stationIDSegments.compactMap { segment -> [String]? in
                guard let index = segment.firstIndex(of: station.id) else { return nil }
                return [index > 0 ? segment[index - 1] : nil, index + 1 < segment.count ? segment[index + 1] : nil].compactMap { $0 }
            }
        }.flatMap { $0 }.compactMap { positions[$0] }
        guard !neighbors.isEmpty else { return false }
        let dx = neighbors.map { abs($0.x - center.x) }.reduce(0, +) / CGFloat(neighbors.count)
        let dy = neighbors.map { abs($0.y - center.y) }.reduce(0, +) / CGFloat(neighbors.count)
        // A diagonal must use the right-side rule, so only clearly horizontal
        // runs qualify for the below-station placement.
        return dx > dy * 1.4
    }

    private func roundedPolyline(
        _ points: [CGPoint],
        radius: CGFloat,
        centeredStationCorners: [CGPoint] = []
    ) -> Path {
        guard let first = points.first else { return Path() }
        guard points.count > 2 else {
            var path = Path()
            path.move(to: first)
            if let last = points.last { path.addLine(to: last) }
            return path
        }

        var path = Path()
        path.move(to: first)
        for index in 1..<(points.count - 1) {
            let previous = points[index - 1]
            let corner = points[index]
            let next = points[index + 1]
            if centeredStationCorners.contains(where: { hypot($0.x - corner.x, $0.y - corner.y) < 0.5 }) {
                path.addLine(to: corner)
                continue
            }
            let incoming = hypot(corner.x - previous.x, corner.y - previous.y)
            let outgoing = hypot(next.x - corner.x, next.y - corner.y)
            guard incoming > 0, outgoing > 0 else { path.addLine(to: corner); continue }
            let cornerRadius = min(
                radius,
                incoming / 2,
                outgoing / 2
            )
            let incomingDirection = CGPoint(
                x: (corner.x - previous.x) / incoming,
                y: (corner.y - previous.y) / incoming
            )
            let outgoingDirection = CGPoint(
                x: (next.x - corner.x) / outgoing,
                y: (next.y - corner.y) / outgoing
            )
            let before = CGPoint(
                x: corner.x - incomingDirection.x * cornerRadius,
                y: corner.y - incomingDirection.y * cornerRadius
            )
            let after = CGPoint(
                x: corner.x + outgoingDirection.x * cornerRadius,
                y: corner.y + outgoingDirection.y * cornerRadius
            )
            path.addLine(to: before)
            path.addQuadCurve(to: after, control: corner)
        }
        if let last = points.last { path.addLine(to: last) }
        return path
    }

    /// Finds direction changes that occur at real stations. Those points use
    /// the route's rounded stroke join so the painted line remains centered
    /// beneath the station marker instead of cutting around it.
    private func stationCornerPoints(
        in points: [CGPoint],
        stationIDs: [String],
        positions: [String: CGPoint],
        canvasSize: CGSize
    ) -> [CGPoint] {
        guard points.count > 2 else { return [] }
        let stationPoints = stationIDs.compactMap { stationID -> CGPoint? in
            guard let position = positions[stationID] else { return nil }
            return CGPoint(
                x: position.x * canvasSize.width,
                y: position.y * canvasSize.height
            )
        }

        return (1..<(points.count - 1)).compactMap { index in
            let previous = points[index - 1]
            let current = points[index]
            let next = points[index + 1]
            let first = CGPoint(x: current.x - previous.x, y: current.y - previous.y)
            let second = CGPoint(x: next.x - current.x, y: next.y - current.y)
            let scale = hypot(first.x, first.y) * hypot(second.x, second.y)
            guard scale > 0.0001 else { return nil }
            let directionChange = abs(first.x * second.y - first.y * second.x) / scale
            guard directionChange > 0.01 else { return nil }
            return stationPoints.contains {
                hypot($0.x - current.x, $0.y - current.y) < 0.5
            } ? current : nil
        }
    }

    /// Adds line-only bend anchors that do not represent tappable stations.
    /// Selected stations sit a short distance away from each bend, leaving the
    /// rounded corner visible while every marker remains centered on a run.
    private func routeDrawingPoints(
        for stationIDs: [String],
        line: MetroLine,
        positions: [String: CGPoint],
        canvasSize: CGSize
    ) -> [CGPoint] {
        var points: [CGPoint] = []

        for (index, stationID) in stationIDs.enumerated() {
            guard let position = positions[stationID] else { continue }
            let current = CGPoint(
                x: position.x * canvasSize.width,
                y: position.y * canvasSize.height
            )

            points.append(current)

            guard
                index + 1 < stationIDs.count,
                let nextPosition = positions[stationIDs[index + 1]]
            else { continue }

            let next = CGPoint(
                x: nextPosition.x * canvasSize.width,
                y: nextPosition.y * canvasSize.height
            )

            switch (line, stationID, stationIDs[index + 1]) {
            case (.brown, "辛亥", "麟光"),
                 (.brown, "大直", "劍南路"):
                points.append(CGPoint(x: current.x, y: next.y))

            case (.brown, "木柵", "萬芳社區"):
                points.append(CGPoint(x: next.x, y: current.y))

            case (.brown, "六張犁", "科技大樓"),
                 (.brown, "大湖公園", "葫洲"),
                 (.blue, "後山埤", "昆陽"):
                points.append(CGPoint(x: next.x, y: current.y))

            case (.blue, "江子翠", "龍山寺"),
                 (.green, "北門", "中山"),
                 (.orange, "行天宮", "中山國小"):
                points.append(CGPoint(x: current.x, y: next.y))

            case (.orange, "古亭", "頂溪"):
                // Keep the left-turning bend unoccupied so both stations stay
                // on straight, comfortably tappable runs.
                points.append(CGPoint(x: next.x, y: current.y))

            case (.orange, "三和國中", "徐匯中學"),
                 (.orange, "新莊", "輔大"):
                guard
                    index + 2 < stationIDs.count,
                    let followingPosition = positions[stationIDs[index + 2]]
                else { continue }
                let followingY = followingPosition.y * canvasSize.height
                points.append(CGPoint(
                    x: next.x,
                    y: next.y * 2 - followingY
                ))

            case (.yellow, "十四張", "秀朗橋"):
                points.append(CGPoint(
                    x: current.x - 0.030 * canvasSize.width,
                    y: current.y
                ))

            case (.yellow, "秀朗橋", "景平"):
                points.append(CGPoint(
                    x: next.x,
                    y: next.y + 0.015 * canvasSize.height
                ))

            case (.red, "石牌", "唭哩岸"):
                points.append(CGPoint(x: current.x, y: next.y))

            case (.red, "忠義", "關渡"):
                points.append(CGPoint(x: next.x, y: current.y))

            default:
                break
            }
        }

        return points
    }

    /// Remove tiny zig-zags created by station anchors while preserving every
    /// meaningful interchange and branch turn. Nodes still use their exact
    /// anchors; only the painted backbone is simplified.
    private func simplifiedPolyline(_ points: [CGPoint]) -> [CGPoint] {
        guard points.count > 2 else { return points }
        var result = [points[0]]
        for index in 1..<(points.count - 1) {
            let previous = result.last ?? points[index - 1]
            let current = points[index]
            let next = points[index + 1]
            let first = CGPoint(x: current.x - previous.x, y: current.y - previous.y)
            let second = CGPoint(x: next.x - current.x, y: next.y - current.y)
            let cross = abs(first.x * second.y - first.y * second.x)
            let scale = max(hypot(first.x, first.y) * hypot(second.x, second.y), 0.0001)
            if cross / scale > 0.08 {
                result.append(current)
            }
        }
        if let last = points.last { result.append(last) }
        return result
    }

    private func mapCanvasSize(for viewport: CGSize) -> CGSize {
        let height = max(viewport.height * 1.18, 900)
        return CGSize(width: height * OfficialRouteMapLayout.aspectRatio, height: height)
    }

    private var mapControls: some View {
        HStack(spacing: 0) {
            mapControlButton("plus", label: "放大") { setZoom(zoom * 1.25) }
            Divider().frame(height: 24)
            mapControlButton("minus", label: "縮小") { setZoom(zoom / 1.25) }
            Divider().frame(height: 24)
            mapControlButton("location.north.line.fill", label: "重設地圖位置") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    zoom = resetZoom
                    zoomBase = resetZoom
                    mapOffset = resetOffset
                }
            }
        }
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.primary.opacity(0.08), lineWidth: 1))
        .shadow(color: .black.opacity(0.10), radius: 8, y: 3)
    }

    private func mapControlButton(_ symbol: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 42, height: 38)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    private func setZoom(_ value: CGFloat) {
        withAnimation(.easeInOut(duration: 0.2)) {
            zoom = min(max(value, MapContentMetrics.minimumZoom), MapContentMetrics.maximumZoom)
            zoomBase = zoom
        }
    }

    private func configureViewport(viewport: CGSize, mapSize: CGSize, force: Bool = false) {
        guard !hasConfiguredViewport || force else { return }
        // Open at a readable scale so labels can remain close to their nodes.
        // The map already supports pan and pinch gestures for the outer areas.
        let readingZoom = MapContentMetrics.initialZoom
        let focusOffset: CGSize
        if let currentStation,
           let position = OfficialRouteMapLayout.stationPositions[currentStation.id] {
            focusOffset = CGSize(
                width: (0.5 - position.x) * mapSize.width * readingZoom,
                height: (0.5 - position.y) * mapSize.height * readingZoom
            )
        } else {
            focusOffset = .zero
        }
        zoom = readingZoom
        zoomBase = readingZoom
        resetZoom = readingZoom
        mapOffset = focusOffset
        resetOffset = focusOffset
        hasConfiguredViewport = true
    }
}

private enum LabelSide {
    case right, left, top, bottom
    case topRight, topLeft, bottomRight, bottomLeft

    func center(
        from station: CGPoint,
        labelSize: CGSize,
        gap: CGFloat = 0,
        offset: CGFloat = 0,
        scale: CGFloat = 1
    ) -> CGPoint {
        switch self {
        case .right:
            CGPoint(
                x: station.x + StationNodeMetrics.tapSize.width / 2 * scale + gap + labelSize.width / 2,
                y: station.y + offset
            )
        case .left:
            CGPoint(
                x: station.x - StationNodeMetrics.tapSize.width / 2 * scale - gap - labelSize.width / 2,
                y: station.y + offset
            )
        case .top:
            CGPoint(
                x: station.x + offset,
                y: station.y - StationNodeMetrics.tapSize.height / 2 * scale - gap - labelSize.height / 2
            )
        case .bottom:
            CGPoint(
                x: station.x + offset,
                y: station.y + StationNodeMetrics.tapSize.height / 2 * scale + gap + labelSize.height / 2
            )
        case .topRight:
            CGPoint(
                x: station.x + StationNodeMetrics.tapSize.width / 2 * scale + gap + labelSize.width / 2,
                y: station.y - StationNodeMetrics.tapSize.height / 2 * scale - gap - labelSize.height / 2 + offset
            )
        case .topLeft:
            CGPoint(
                x: station.x - StationNodeMetrics.tapSize.width / 2 * scale - gap - labelSize.width / 2,
                y: station.y - StationNodeMetrics.tapSize.height / 2 * scale - gap - labelSize.height / 2 + offset
            )
        case .bottomRight:
            CGPoint(
                x: station.x + StationNodeMetrics.tapSize.width / 2 * scale + gap + labelSize.width / 2,
                y: station.y + StationNodeMetrics.tapSize.height / 2 * scale + gap + labelSize.height / 2 + offset
            )
        case .bottomLeft:
            CGPoint(
                x: station.x - StationNodeMetrics.tapSize.width / 2 * scale - gap - labelSize.width / 2,
                y: station.y + StationNodeMetrics.tapSize.height / 2 * scale + gap + labelSize.height / 2 + offset
            )
        }
    }
}

/// The marker is almost square so it stays easy to recognize on both vertical
/// and horizontal routes. A shared hit-test layer resolves a 44 x 44 point
/// target to one nearest station, so targets never stack at interchanges.
private enum StationNodeMetrics {
    static let markerSize = CGSize(width: 26, height: 24)
    static let selectionSize = CGSize(width: 34, height: 32)
    static let tapSize = CGSize(width: 44, height: 44)
    static let labelClearanceSize = CGSize(width: 42, height: 42)
    static let cornerRadius: CGFloat = 7
    static let selectionCornerRadius: CGFloat = 9
}

private enum MapContentMetrics {
    static let minimumZoom: CGFloat = 0.72
    static let initialZoom: CGFloat = 1.8
    static let fullSizeZoom: CGFloat = 2.4
    static let maximumZoom: CGFloat = 4.2
}

private struct SplitStationMarker: View {
    let firstColor: Color
    let secondColor: Color
    var lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: StationNodeMetrics.cornerRadius, style: .continuous)
                .trim(from: 0, to: 0.5)
                .stroke(firstColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
            RoundedRectangle(cornerRadius: StationNodeMetrics.cornerRadius, style: .continuous)
                .trim(from: 0.5, to: 1)
                .stroke(secondColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
        }
    }
}

#Preview("中文路線圖與站點試算") {
    InteractiveMapView(
        stations: Station.mockNetwork,
        currentStation: Station.mockNetwork.first(where: { $0.name == "台北車站" }),
        destinationStation: Station.mockNetwork.first(where: { $0.name == "淡水" }),
        onSelectStation: { _ in }
    )
}
