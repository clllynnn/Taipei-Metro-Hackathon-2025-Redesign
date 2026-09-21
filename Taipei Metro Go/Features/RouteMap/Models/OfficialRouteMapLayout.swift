import SwiftUI

enum OfficialRouteMapLayout {
    // These normalized anchors follow the official network artwork's composition.
    // They are used only to place native SwiftUI paths, labels, and tap targets.
    static let aspectRatio: CGFloat = 5670.29 / 9213.6

    // The two Circular-line stations retain Blue-line y alignment. Their
    // closer x positions make the continuous Zhonghe–Touqianzhuang run steeper
    // while Blue line still passes between the separate tap targets.
    private static let fixedCircularBanqiao = p(0.335189, 0.754731)
    private static let fixedXinpuMinsheng = p(0.275189, 0.722935)

    private static let printedLabelAnchors: [String: CGPoint] = [
        "淡水": p(0.13325, 0.11265), "紅樹林": p(0.12618, 0.14893), "竹圍": p(0.12264, 0.18169),
        "新北投": p(0.27830, 0.20567), "忠義": p(0.14387, 0.25434), "復興崗": p(0.21698, 0.27174),
        "北投": p(0.26887, 0.27102), "奇岩": p(0.31958, 0.27174), "唭哩岸": p(0.40802, 0.24196),
        "石牌": p(0.42453, 0.27911), "明德": p(0.42453, 0.31110), "蘆洲": p(0.25236, 0.31612),
        "三民高中": p(0.23585, 0.34736), "西湖": p(0.64151, 0.35753), "大湖公園": p(0.87736, 0.35610),
        "港墘": p(0.69693, 0.35606), "文德": p(0.75118, 0.35606), "徐匯中學": p(0.23585, 0.37934),
        "劍潭": p(0.42571, 0.40411), "三和國中": p(0.23703, 0.40913), "圓山": p(0.42689, 0.43461),
        "大直": p(0.65448, 0.43890), "三重國小": p(0.23132, 0.44039), "南港軟體園區": p(0.84434, 0.44477),
        "大橋頭": p(0.32547, 0.46219), "民權西路": p(0.44104, 0.45640), "中山國小": p(0.51887, 0.46076),
        "台北橋": p(0.20991, 0.46736), "南港展覽館": p(0.84080, 0.47678), "菜寮": p(0.21462, 0.49566),
        "中山國中": p(0.67335, 0.49272), "幸福": p(0.11203, 0.57195), "三重": p(0.21580, 0.51526),
        "雙連": p(0.36557, 0.51017), "松江南京": p(0.55896, 0.52035), "南京復興": p(0.67217, 0.52174),
        "南京三民": p(0.76297, 0.52762), "松山": p(0.83137, 0.52690), "先嗇宮": p(0.22052, 0.56250),
        "昆陽": p(0.93868, 0.54358), "台北小巨蛋": p(0.70637, 0.56032), "頭前庄": p(0.13208, 0.59736),
        "西門": p(0.27241, 0.59161), "台北車站": p(0.44222, 0.58067), "忠孝新生": p(0.55778, 0.57997),
        "忠孝復興": p(0.67335, 0.57994), "北門": p(0.27476, 0.57054), "新莊": p(0.15448, 0.62936),
        "龍山寺": p(0.25472, 0.61917), "善導寺": p(0.45519, 0.62064), "忠孝敦化": p(0.69929, 0.62064),
        "國父紀念館": p(0.75825, 0.57994), "台大醫院": p(0.35259, 0.63590), "大安": p(0.56368, 0.64026),
        "東門": p(0.48349, 0.65042), "輔大": p(0.11557, 0.65339), "小南門": p(0.32075, 0.67947),
        "台北101/世貿": p(0.76533, 0.68677), "迴龍": p(0.08019, 0.70054), "新埔民生": p(0.15330, 0.69695),
        "古亭": p(0.49057, 0.70201), "科技大樓": p(0.59198, 0.70343), "麟光": p(0.72995, 0.73696),
        "辛亥": p(0.79481, 0.73768), "台電大樓": p(0.54009, 0.72753), "板橋": p(0.29363, 0.72310),
        "萬芳醫院": p(0.81958, 0.77180), "府中": p(0.19811, 0.76599), "中原": p(0.29127, 0.77469),
        "永安市場": p(0.41392, 0.76745), "公館": p(0.56722, 0.75287), "景安": p(0.47524, 0.79076),
        "木柵": p(0.81722, 0.80594), "景平": p(0.54009, 0.80233), "亞東醫院": p(0.18042, 0.80446),
        "景美": p(0.64387, 0.80093), "中和": p(0.37264, 0.81323), "十四張": p(0.59434, 0.82554),
        "大坪林": p(0.70165, 0.84161), "南勢角": p(0.41156, 0.84161), "海山": p(0.19693, 0.84375),
        "萬隆": p(0.60495, 0.77543), "七張": p(0.68042, 0.88083), "新店區公所": p(0.70283, 0.91279),
        "小碧潭": p(0.58844, 0.89896), "新店": p(0.67925, 0.94627), "永寧": p(0.19693, 0.92077),
        "頂埔": p(0.20401, 0.94551), "廣慈/奉天宮": p(0.925, 0.68677),
        "信義安和": p(0.71934, 0.65117), "市政府": p(0.82075, 0.62066),
        "永春": p(0.87972, 0.62064), "南港": p(0.93868, 0.51157), "大安森林公園": p(0.523, 0.646),
        "新北產業園區": p(0.12618, 0.50145)
    ]

    static let stationPositions: [String: CGPoint] = makeStationPositions()

    private static func makeStationPositions() -> [String: CGPoint] {
        var sums: [String: CGPoint] = [:]
        var counts: [String: CGFloat] = [:]

        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                let known = segment.enumerated().compactMap { index, name -> (Int, CGPoint)? in
                    printedLabelAnchors[name].map { (index, $0) }
                }
                guard !known.isEmpty else { continue }

                for index in segment.indices where printedLabelAnchors[segment[index]] == nil {
                    guard let position = interpolatedPosition(at: index, in: known) else { continue }
                    let name = segment[index]
                    let total = sums[name] ?? .zero
                    sums[name] = CGPoint(x: total.x + position.x, y: total.y + position.y)
                    counts[name, default: 0] += 1
                }
            }
        }

        var result = printedLabelAnchors
        for (name, total) in sums {
            guard let count = counts[name], count > 0 else { continue }
            result[name] = CGPoint(x: total.x / count, y: total.y / count)
        }
        let schematic = straightenRouteRuns(equalizeStationSpacing(result))
        let redScaffold = enforceRedCentralSpine(schematic)
        let greenAligned = enforceGreenSouthRun(redScaffold)
        let orangeAligned = enforceOrangeSouthRun(greenAligned)
        let branched = enforceOrangeBranches(orangeAligned)
        let yellowAligned = enforceYellowMiddleRun(branched)
        let blueAligned = enforceBlueRoute(yellowAligned)
        let redAligned = enforceRedRoute(blueAligned)
        let brownAligned = enforceBrownRoute(redAligned)
        let finalGreenAligned = enforceGreenRoute(brownAligned)
        let finalOrangeAligned = enforceOrangeRoute(finalGreenAligned)
        return enforceYellowRoute(finalOrangeAligned)
    }

    /// The Bannan line uses one horizontal trunk with a vertical leg at each
    /// end. Jiangzicui and Kunyang are the only bends, so the renderer can
    /// round those two corners without introducing intermediate zig-zags.
    private static func enforceBlueRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let westVertical = [
            "江子翠", "新埔", "板橋", "府中", "亞東醫院",
            "海山", "土城", "永寧", "頂埔"
        ]
        let horizontal = [
            "江子翠", "龍山寺", "西門", "台北車站", "善導寺",
            "忠孝新生", "忠孝復興", "忠孝敦化", "國父紀念館",
            "市政府", "永春", "後山埤", "昆陽"
        ]
        let eastVertical = ["昆陽", "南港", "南港展覽館"]

        guard
            let westCorner = base["江子翠"],
            let eastCorner = base["昆陽"],
            let westTerminal = base["頂埔"],
            let eastTerminal = base["南港展覽館"],
            let memorialHall = base["中正紀念堂"]
        else { return base }

        // 藍線主幹下移後，台北車站的新高度會重新分配紅線中山站，
        // 並成為綠線南京復興的最終高度。解開這段依賴關係後，這個
        // 高度會讓忠孝復興精確位於大安與南京復興的中點。
        let futureZhongshanY = memorialHall.y - 0.092
        let trunkY = (memorialHall.y + futureZhongshanY) / 2
        // Pull the whole western vertical slightly farther west. Jiangzicui
        // then reads clearly to the left of the Orange-line Cailiao station,
        // while all nine Bannan stations remain on one vertical axis.
        let westX = westCorner.x - 0.035
        var result = base

        let cornerClearance: CGFloat = 0.028
        for (index, station) in westVertical.enumerated() {
            let progress = CGFloat(index) / CGFloat(westVertical.count - 1)
            result[station] = CGPoint(
                x: westX,
                y: trunkY + cornerClearance
                    + (westTerminal.y - trunkY - cornerClearance) * progress
            )
        }

        for (index, station) in horizontal.dropFirst().dropLast().enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(horizontal.count - 1)
            result[station] = CGPoint(
                x: westX + (eastCorner.x - westX) * progress,
                y: trunkY
            )
        }
        // Give the red-line Daan–Guangci run enough room to use one exact,
        // even station interval while Xinyi Anhe remains left of Zhongxiao
        // Dunhua. Daan follows this shared interchange in enforceBrownRoute.
        if var zhongxiaoFuxing = result["忠孝復興"] {
            zhongxiaoFuxing.x -= 0.002
            result["忠孝復興"] = zhongxiaoFuxing
        }

        for (index, station) in eastVertical.enumerated() {
            let progress = CGFloat(index) / CGFloat(eastVertical.count - 1)
            result[station] = CGPoint(
                x: eastCorner.x,
                y: trunkY - cornerClearance
                    + (eastTerminal.y - trunkY + cornerClearance) * progress
            )
        }

        return result
    }

    private static func enforceGreenSouthRun(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let stations = [
            "中正紀念堂", "古亭", "台電大樓", "公館", "萬隆",
            "景美", "大坪林", "七張", "新店區公所", "新店"
        ]
        guard let start = base[stations[0]], let end = base[stations[stations.count - 1]] else {
            return base
        }
        var result = base
        for (index, station) in stations.enumerated() {
            result[station] = interpolate(start, end, CGFloat(index) / CGFloat(stations.count - 1))
        }
        return result
    }

    private static func enforceOrangeSouthRun(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let stations = ["南勢角", "景安", "永安市場", "頂溪", "古亭"]
        guard let start = base[stations[0]], let end = base[stations[stations.count - 1]] else {
            return base
        }
        var result = base
        for (index, station) in stations.enumerated() where index > 0 && index < stations.count - 1 {
            result[station] = interpolate(start, end, CGFloat(index) / CGFloat(stations.count - 1))
        }
        return result
    }

    private static func enforceOrangeBranches(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let branches = [
            ["大橋頭", "三重國小", "三和國中", "徐匯中學", "三民高中", "蘆洲"],
            ["大橋頭", "台北橋", "菜寮", "三重", "先嗇宮", "頭前庄", "新莊", "輔大", "丹鳳", "迴龍"]
        ]
        var result = base
        for branch in branches {
            guard let start = base[branch[0]], let end = base[branch[branch.count - 1]] else { continue }
            for (index, station) in branch.enumerated() where index > 0 {
                result[station] = interpolate(start, end, CGFloat(index) / CGFloat(branch.count - 1))
            }
        }
        return result
    }

    private static func enforceYellowMiddleRun(_ base: [String: CGPoint]) -> [String: CGPoint] {
        guard let interchange = base["景安"] else { return base }
        var result = base
        result["中和"] = CGPoint(x: interchange.x - 0.072, y: interchange.y)
        result["景平"] = CGPoint(x: interchange.x + 0.072, y: interchange.y)
        return result
    }

    /// Keeps the central interchange spine stable while the other route
    /// specific passes are calculated. The final red pass below then applies
    /// the requested terminal and corner geometry.
    private static func enforceRedCentralSpine(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let centralStations = [
            "石牌", "明德", "芝山", "士林", "劍潭", "圓山",
            "民權西路", "雙連", "中山", "台北車站", "台大醫院", "中正紀念堂"
        ]
        guard let spineX = base["台北車站"]?.x else { return base }

        let existingY = centralStations.compactMap { base[$0]?.y }
        guard let firstY = existingY.first, let lastY = existingY.last else { return base }
        let minimumStep: CGFloat = 0.038
        let requiredSpan = minimumStep * CGFloat(centralStations.count - 1)
        let originalSpan = max(lastY - firstY, 0)
        let span = max(originalSpan, requiredSpan)
        let midpoint = (firstY + lastY) / 2
        let startY = min(max(midpoint - span / 2, 0.06), 0.94 - span)
        let step = span / CGFloat(centralStations.count - 1)

        var result = base
        for (index, station) in centralStations.enumerated() {
            guard var position = result[station] else { continue }
            position.x = spineX
            position.y = startY + CGFloat(index) * step
            result[station] = position
        }
        return result
    }

    /// The Tamsui-Xinyi line is a four-run schematic. Chiang Kai-Shek
    /// Memorial Hall is the one intentionally sharp corner; Shipai and Guandu
    /// remain the two rounded bends rendered by the route path.
    private static func enforceRedRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let southHorizontal = [
            "廣慈/奉天宮", "象山", "台北101/世貿", "信義安和",
            "大安", "大安森林公園", "東門", "中正紀念堂"
        ]
        let centralVertical = [
            "中正紀念堂", "台大醫院", "台北車站", "中山", "雙連",
            "民權西路", "圓山", "劍潭", "士林", "芝山", "明德", "石牌"
        ]
        let northHorizontal = [
            "石牌", "唭哩岸", "奇岩", "北投", "復興崗", "忠義", "關渡"
        ]
        let northVertical = ["關渡", "竹圍", "紅樹林", "淡水"]

        guard
            base["廣慈/奉天宮"] != nil,
            let memorialHall = base["中正紀念堂"],
            let taipeiMain = base["台北車站"],
            let yongchun = base["永春"],
            let zhongxiaoFuxing = base["忠孝復興"],
            let qilian = base["唭哩岸"],
            let zhongyi = base["忠義"],
            let guandu = base["關渡"],
            let tamsui = base["淡水"]
        else { return base }

        let southY = memorialHall.y
        let centralX = taipeiMain.x
        // 廣慈／奉天宮仍位於永春與後山埤之間，並以大安為另一端，
        // 精確均分這五座車站。
        let southTerminalX = yongchun.x + 0.002
        let daanX = zhongxiaoFuxing.x
        // 將石牌至中山的北段收短；北側水平段回到唭哩岸與忠義
        // 原始高度的中點，仍保留足夠的站點點擊間距。
        let northY = (qilian.y + zhongyi.y) / 2 + 0.025
        let northX = guandu.x
        var result = base

        let terminalSection = Array(southHorizontal.prefix(5))
        for (index, station) in terminalSection.enumerated() {
            let progress = CGFloat(index) / CGFloat(terminalSection.count - 1)
            result[station] = CGPoint(
                x: southTerminalX + (daanX - southTerminalX) * progress,
                y: southY
            )
        }
        let innerSection = Array(southHorizontal.suffix(4))
        for (index, station) in innerSection.enumerated() {
            let progress = CGFloat(index) / CGFloat(innerSection.count - 1)
            result[station] = CGPoint(
                x: daanX + (centralX - daanX) * progress,
                y: southY
            )
        }

        let taipeiMainIndex = centralVertical.firstIndex(of: "台北車站") ?? 2
        let zhongshanIndex = centralVertical.firstIndex(of: "中山") ?? 3
        let shortenedZhongshanY = 2 * taipeiMain.y - memorialHall.y
        for (index, station) in centralVertical.enumerated() {
            var y: CGFloat
            if index <= taipeiMainIndex {
                let progress = CGFloat(index) / CGFloat(taipeiMainIndex)
                y = southY + (taipeiMain.y - southY) * progress
            } else {
                let remainingCount = centralVertical.count - 1 - zhongshanIndex
                let progress = CGFloat(index - zhongshanIndex) / CGFloat(remainingCount)
                y = shortenedZhongshanY + (northY - shortenedZhongshanY) * progress
            }
            if station == "圓山", let nearby = base["中山國小"], abs(y - nearby.y) < 0.016 {
                y = nearby.y + (y < nearby.y ? -0.016 : 0.016)
            }
            result[station] = CGPoint(x: centralX, y: y)
        }

        for (index, station) in northHorizontal.enumerated() {
            let progress = CGFloat(index) / CGFloat(northHorizontal.count - 1)
            result[station] = CGPoint(
                x: centralX + (northX - centralX) * progress,
                y: northY
            )
        }

        // 石牌、關渡都退離折角，讓實際折點保留在線上而非壓在
        // 可點擊站點之下。
        let cornerClearance: CGFloat = 0.057
        result["石牌"] = CGPoint(x: centralX, y: northY + cornerClearance)
        result["關渡"] = CGPoint(x: northX, y: northY - cornerClearance)
        result["明德"] = CGPoint(x: centralX, y: northY + 0.030)
        result["芝山"] = CGPoint(x: centralX, y: northY + 0.084)
        for (index, station) in northVertical.dropFirst().enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(northVertical.count - 1)
            result[station] = CGPoint(
                x: northX,
                y: (northY - cornerClearance)
                    + (tamsui.y - (northY - cornerClearance)) * progress
            )
        }

        // 新北投支線貼近北投，並以同一條垂直軸呈現。
        if let beitou = result["北投"] {
            result["新北投"] = CGPoint(x: beitou.x, y: beitou.y - 0.036)
        }

        return result
    }

    /// The Wenhu line alternates between three horizontal and three vertical
    /// runs. Their shared endpoints are the only five bends, so the route
    /// renderer produces one rounded corner at Muzha, Xinhai, Liuzhangli,
    /// Dazhi, and Dahu Park without introducing extra zig-zags.
    private static func enforceBrownRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let southVertical = ["木柵", "萬芳社區", "萬芳醫院", "辛亥"]
        let centralVertical = [
            "六張犁", "科技大樓", "大安", "忠孝復興", "南京復興",
            "中山國中", "松山機場", "大直"
        ]
        let eastVertical = ["葫洲", "東湖", "南港軟體園區", "南港展覽館"]

        guard
            let dapinglin = base["大坪林"],
            let xinhai = base["辛亥"],
            let taipei101 = base["台北101/世貿"],
            let xiangshan = base["象山"],
            let guangci = base["廣慈/奉天宮"],
            let daan = base["大安"],
            let zhongxiaoFuxing = base["忠孝復興"],
            let zhongshan = base["中山"],
            let jiantan = base["劍潭"],
            let houshanpi = base["後山埤"],
            let nangangExhibitionCenter = base["南港展覽館"]
        else { return base }

        // 辛亥的水平位置固定在台北 101 與象山之間，動物園則與
        // 廣慈／奉天宮使用近似的水平位置。
        let southVerticalX = (taipei101.x + xiangshan.x) / 2
        let zooX = guangci.x
        // Preserve Zhongxiao Fuxing's accepted Bannan-line spacing; moving the
        // shared vertical axis farther east would crowd Zhongxiao Dunhua.
        let centralX = zhongxiaoFuxing.x
        // 劍南路所在的水平段只比劍潭略高，避免兩段相距過遠。
        let northY = jiantan.y - 0.010
        // 南京復興到大直共有三段垂直站距；大直到劍南路再以相同
        // 的實際畫面距離水平延伸。
        // 綠線最終會把南京復興對齊中山，因此直接使用最終水平段高度。
        let finalNanjingFuxingY = zhongshan.y
        // 大直退離北側折角；南京復興至折角改為四個等距區間。
        let regularStep = (finalNanjingFuxingY - northY) / 4
        let requestedSouthY = dapinglin.y - 0.010
        let lowerY = min(
            max(xinhai.y, daan.y + 0.055),
            requestedSouthY - 0.067
        )
        let technologyBuildingY = (lowerY + daan.y) / 2
        let southY = requestedSouthY
        let eastX = nangangExhibitionCenter.x
        // 南港展覽館高於綠線松山；綠線稍後會以中山高度作為松山高度。
        let exhibitionCenterY = finalNanjingFuxingY - 0.024
        let cornerClearance: CGFloat = 0.028
        var result = base

        result["動物園"] = CGPoint(x: zooX, y: southY)
        // 木柵退到垂直段右側；木柵—萬芳社區間的折角由 renderer 的
        // 無站點錨點處理，因此木柵不再卡在折角中心。
        result["木柵"] = CGPoint(x: southVerticalX + cornerClearance + 0.010, y: southY)

        let xinhaiStationY = lowerY + cornerClearance
        for (index, station) in southVertical.dropFirst().enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(southVertical.count - 1)
            result[station] = CGPoint(
                x: southVerticalX,
                y: southY + (xinhaiStationY - southY) * progress
            )
        }

        // 辛亥先向上到無站點折角；六張犁則停在中央垂直線右側，
        // 兩者之間仍維持一條乾淨的水平線。
        let liuzhangliX = centralX + cornerClearance
        result["麟光"] = CGPoint(x: (southVerticalX + liuzhangliX) / 2, y: lowerY)
        result["六張犁"] = CGPoint(x: liuzhangliX, y: lowerY)
        result["科技大樓"] = CGPoint(x: centralX, y: technologyBuildingY)
        result["大安"] = CGPoint(x: centralX, y: daan.y)
        result["忠孝復興"] = CGPoint(x: centralX, y: zhongxiaoFuxing.y)
        result["南京復興"] = CGPoint(x: centralX, y: finalNanjingFuxingY)

        let upperCentral = ["中山國中", "松山機場", "大直"]
        for (index, station) in upperCentral.enumerated() {
            result[station] = CGPoint(
                x: centralX,
                y: finalNanjingFuxingY - regularStep * CGFloat(index + 1)
            )
        }
        for station in centralVertical.dropFirst() {
            guard let position = result[station] else { continue }
            result[station] = CGPoint(x: centralX, y: position.y)
        }

        // 大直與大湖公園都退離折角；兩個無站點折角之間的六座
        // 車站與兩端留白採相同間距。
        let northHorizontal = ["劍南路", "西湖", "港墘", "文德", "內湖", "大湖公園"]
        for (index, station) in northHorizontal.enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(northHorizontal.count + 1)
            result[station] = CGPoint(
                x: centralX + (eastX - centralX) * progress,
                y: northY
            )
        }

        // 葫洲至南港展覽館縮成三個清楚、均等的站距。
        let dazhiY = result["大直"]?.y ?? northY + 0.040
        let huluzhouY = max(northY + 0.012, dazhiY - 0.025)
        for (index, station) in eastVertical.enumerated() {
            let progress = CGFloat(index) / CGFloat(eastVertical.count - 1)
            result[station] = CGPoint(
                x: eastX,
                y: huluzhouY + (exhibitionCenterY - huluzhouY) * progress
            )
        }
        // 南港展覽館同時屬於藍線。文湖線縮短這一段後，重新均分
        // 藍線轉角後的三站，避免昆陽、南港與南港展覽館疊在一起。
        let kunyangY = houshanpi.y - 0.003
        result["昆陽"] = CGPoint(x: eastX, y: kunyangY)
        result["南港"] = CGPoint(x: eastX, y: (kunyangY + exhibitionCenterY) / 2)
        result["南港展覽館"] = CGPoint(x: eastX, y: exhibitionCenterY)

        return result
    }

    /// The Songshan-Xindian line keeps four readable runs: the Songshan end is
    /// horizontal, the old-city section is vertical, the south section shares
    /// one diagonal, and the Xindian end is vertical. Xiaonanmen and Beimen are
    /// the two main bends; Dapinglin keeps the requested subtle terminal bend.
    private static func enforceGreenRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let upperHorizontal = [
            "中山", "松江南京", "南京復興", "台北小巨蛋", "南京三民", "松山"
        ]
        let cityVertical = ["小南門", "西門", "北門"]
        let southDiagonal = [
            "中正紀念堂", "古亭", "台電大樓", "公館", "萬隆", "景美", "大坪林"
        ]
        let xindianVertical = ["大坪林", "七張", "新店區公所", "新店"]

        guard
            let memorialHall = base["中正紀念堂"],
            let ximen = base["西門"],
            let zhongshan = base["中山"],
            let liuzhangli = base["六張犁"],
            let wanfangCommunity = base["萬芳社區"],
            let yongchun = base["永春"]
        else { return base }

        let upperY = zhongshan.y
        let cityX = ximen.x
        var result = base

        // 大坪林固定在六張犁左側、萬芳社區稍下方。南段各站沿同一
        // 斜率重分配，縮短古亭—台電大樓，同時讓台電大樓高於頂溪。
        let extendedDapinglin = CGPoint(
            x: liuzhangli.x - 0.012,
            y: wanfangCommunity.y + 0.004
        )
        let southProgress: [CGFloat] = [0, 0.10, 0.24, 0.42, 0.60, 0.80, 1]
        for (station, progress) in zip(southDiagonal, southProgress) {
            result[station] = interpolate(memorialHall, extendedDapinglin, progress)
        }

        // 中正紀念堂至小南門改為水平進入舊城區；小南門本身
        // 是水平段轉入西門、北門垂直段的唯一折角。
        result["小南門"] = CGPoint(x: cityX, y: memorialHall.y)
        for station in cityVertical {
            guard let position = result[station] else { continue }
            result[station] = CGPoint(x: cityX, y: position.y)
        }
        result["西門"] = CGPoint(x: cityX, y: ximen.y)
        // 北門下移離開轉向點，轉向本身由無站點圓弧錨點處理。
        result["北門"] = CGPoint(x: cityX, y: (upperY + ximen.y) / 2)

        for station in upperHorizontal {
            guard let position = result[station] else { continue }
            result[station] = CGPoint(x: position.x, y: upperY)
        }
        if var songshan = result["松山"] {
            songshan.x = yongchun.x - 0.020
            result["松山"] = songshan
        }

        guard let alignedDapinglin = result["大坪林"] else { return base }
        for (index, station) in xindianVertical.enumerated() {
            result[station] = CGPoint(
                x: alignedDapinglin.x,
                y: alignedDapinglin.y + CGFloat(index) * 0.022
            )
        }

        // 小碧潭支線由七張水平向西延伸。
        if let qizhang = result["七張"], var xiaobitan = result["小碧潭"] {
            xiaobitan.x = qizhang.x - 0.060
            xiaobitan.y = qizhang.y
            result["小碧潭"] = xiaobitan
        }

        return result
    }

    /// The Zhonghe-Xinlu line uses one compact trunk and two clearly separated
    /// branches. Shared interchange coordinates remain single nodes while the
    /// orange runs snap to the requested horizontal, vertical, and diagonal
    /// axes. The renderer rounds each change in direction automatically.
    private static func enforceOrangeRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let centralVertical = ["東門", "忠孝新生", "松江南京", "行天宮"]
        let northHorizontal = ["中山國小", "民權西路", "大橋頭"]
        let luzhouVertical = ["三和國中", "徐匯中學", "三民高中", "蘆洲"]
        let huilongVertical = ["新莊", "輔大", "丹鳳", "迴龍"]

        guard
            let guting = base["古亭"],
            let daan = base["大安"],
            let dongmen = base["東門"],
            let zhongxiaoXinsheng = base["忠孝新生"],
            let songjiangNanjing = base["松江南京"],
            let minquanWestRoad = base["民權西路"],
            let shuanglian = base["雙連"],
            let blueJiangzicui = base["江子翠"],
            let blueBanqiao = base["板橋"],
            let fuxinggang = base["復興崗"],
            let zhongyi = base["忠義"],
            let zhishan = base["芝山"],
            let mingde = base["明德"],
            base["新莊"] != nil,
            base["迴龍"] != nil
        else { return base }

        var result = base

        // 古亭到頂溪先向左轉，再垂直接入南段。圓弧折角本身由
        // renderer 的無站點錨點繪製，兩端站點都留在直線段上。
        let southX = guting.x - 0.009
        let dingxiY = guting.y + 0.028
        let yonganY = dingxiY + 0.024
        let jinganY = yonganY + 0.024
        let nanshijiaoY = jinganY + 0.036
        result["頂溪"] = CGPoint(x: southX, y: dingxiY)
        result["永安市場"] = CGPoint(x: southX, y: yonganY)
        result["景安"] = CGPoint(x: southX, y: jinganY)
        result["南勢角"] = CGPoint(x: southX, y: nanshijiaoY)

        // 古亭—東門維持固定斜率，並讓東門成為中央垂直段的起點。
        result["古亭"] = guting

        // 東門—行天宮共用同一條垂直軸，避免中段產生任何水平偏移。
        let centralX = songjiangNanjing.x - 0.025
        let centralStep = zhongxiaoXinsheng.y - songjiangNanjing.y
        let centralY = [
            dongmen.y,
            zhongxiaoXinsheng.y,
            songjiangNanjing.y,
            songjiangNanjing.y - centralStep
        ]
        for (index, station) in centralVertical.enumerated() {
            result[station] = CGPoint(x: centralX, y: centralY[index])
        }
        if let taipeiMain = result["台北車站"] {
            result["善導寺"] = CGPoint(
                x: (taipeiMain.x + centralX) / 2,
                y: zhongxiaoXinsheng.y
            )
        }

        // 大安森林公園位於大安與東門的中點，避免紅線相鄰站點因
        // 轉乘站校正而擠在同一個點擊區內。
        result["大安森林公園"] = CGPoint(
            x: (daan.x + centralX) / 2,
            y: dongmen.y
        )

        // 行天宮轉向後，中山國小—大橋頭沿民權西路水平排列。
        // 讓民權西路—大橋頭的間距接近相鄰站距，把左側空間留給
        // 往迴龍方向的等距斜線。
        let horizontalY = minquanWestRoad.y
        let zhongshanElementaryX = (centralX + minquanWestRoad.x) / 2
        let adjustedDaqiaotouX = minquanWestRoad.x - 0.052
        let adjustedDaqiaotou = CGPoint(x: adjustedDaqiaotouX, y: horizontalY)
        let horizontalX = [zhongshanElementaryX, minquanWestRoad.x, adjustedDaqiaotouX]
        for (index, station) in northHorizontal.enumerated() {
            result[station] = CGPoint(x: horizontalX[index], y: horizontalY)
        }

        // 大橋頭的兩條分支先以較接近的斜率離開，縮小分岔夾角。
        // 蘆洲支線在三和國中後轉為垂直。
        let luzhouX = (zhongyi.x + fuxinggang.x) / 2
        let luzhouY = (zhishan.y + mingde.y) / 2
        let luzhouCorner = CGPoint(
            x: luzhouX,
            y: horizontalY - 0.095
        )
        let sanchongElementary = interpolate(adjustedDaqiaotou, luzhouCorner, 0.45)
        result["三重國小"] = sanchongElementary
        // 三和國中沿原斜線下移，折角留在站點後方。
        result["三和國中"] = interpolate(sanchongElementary, luzhouCorner, 0.72)
        for (index, station) in luzhouVertical.dropFirst().enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(luzhouVertical.count - 1)
            result[station] = CGPoint(
                x: luzhouX,
                y: luzhouCorner.y + (luzhouY - luzhouCorner.y) * progress
            )
        }

        // 新莊支線與黃線共用頭前庄。先用固定不動的新埔民生、環狀線
        // 板橋兩站建立黃線斜率，再把頭前庄放到江子翠稍上方。橘線由
        // 大橋頭一路沿單一斜率通過這個共享座標。
        let circularBanqiao = fixedCircularBanqiao
        let xinpuMinsheng = fixedXinpuMinsheng
        let yellowDX = circularBanqiao.x - xinpuMinsheng.x
        let yellowDY = circularBanqiao.y - xinpuMinsheng.y
        guard abs(yellowDY) > 0.000_001 else { return base }
        let touqianzhuangY = blueJiangzicui.y - 0.018
        let touqianzhuangX = xinpuMinsheng.x
            + (touqianzhuangY - xinpuMinsheng.y) * yellowDX / yellowDY
        let touqianzhuang = CGPoint(x: touqianzhuangX, y: touqianzhuangY)

        let taipeiBridgeY = minquanWestRoad.y
            + (shuanglian.y - minquanWestRoad.y) * 2 / 3
        let branchDY = touqianzhuang.y - adjustedDaqiaotou.y
        guard abs(branchDY) > 0.000_001 else { return base }
        let taipeiBridgeProgress = (taipeiBridgeY - adjustedDaqiaotou.y) / branchDY
        let branchStations = ["台北橋", "菜寮", "三重", "先嗇宮", "頭前庄"]
        for (index, station) in branchStations.enumerated() {
            let remainingProgress = CGFloat(index) / CGFloat(branchStations.count - 1)
            let progress = taipeiBridgeProgress
                + (1 - taipeiBridgeProgress) * remainingProgress
            result[station] = interpolate(adjustedDaqiaotou, touqianzhuang, progress)
        }

        // 新莊仍在同一條斜線上，但站點先停在折角前；實際轉入垂直線
        // 的圓弧由後方的無站點錨點形成。
        let xinzhuangProgress: CGFloat = 1.17
        let cornerProgress: CGFloat = 1.21
        result["新莊"] = interpolate(adjustedDaqiaotou, touqianzhuang, xinzhuangProgress)
        let xinzhuangCorner = interpolate(adjustedDaqiaotou, touqianzhuang, cornerProgress)
        let huilongX = xinzhuangCorner.x
        let huilongY = blueBanqiao.y + 0.040
        for (index, station) in huilongVertical.dropFirst().enumerated() {
            let progress = CGFloat(index + 1) / CGFloat(huilongVertical.count - 1)
            result[station] = CGPoint(
                x: huilongX,
                y: xinzhuangCorner.y + (huilongY - xinzhuangCorner.y) * progress
            )
        }

        return result
    }

    /// The Circular line uses four clean runs: a short horizontal at Dapinglin,
    /// a diagonal through Xiulang Bridge, a horizontal through Jingan, and one
    /// diagonal toward Touqianzhuang before the terminal vertical. This leaves
    /// exactly four direction changes at Shisizhang, Jingping, Zhonghe, and
    /// Touqianzhuang.
    private static func enforceYellowRoute(_ base: [String: CGPoint]) -> [String: CGPoint] {
        let terminalVertical = ["頭前庄", "幸福", "新北產業園區"]

        guard
            let dapinglin = base["大坪林"],
            let memorialHall = base["中正紀念堂"],
            let jingan = base["景安"],
            base["頭前庄"] != nil,
            let sanchong = base["三重"]
        else { return base }

        var result = base

        let middleY = jingan.y

        // 景平、景安、中和同高。景平的位置由綠線同高度的 x 軸
        // 推回左側，確保從景安到大坪林的整段都留在綠線左方。
        let greenProgressAtMiddleY = (middleY - memorialHall.y)
            / (dapinglin.y - memorialHall.y)
        let greenXAtMiddleY = memorialHall.x
            + (dapinglin.x - memorialHall.x) * greenProgressAtMiddleY
        let jingpingX = greenXAtMiddleY - 0.076
        let jingping = CGPoint(x: jingpingX, y: middleY)
        // 大坪林與十四張保持水平。景平到十四張、十四張到大坪林的
        // 兩個轉向皆使用站外折角，秀朗橋位於兩折角之間的斜線中段。
        let shisizhang = CGPoint(x: dapinglin.x - 0.050, y: dapinglin.y)
        result["十四張"] = shisizhang
        let firstBend = CGPoint(x: shisizhang.x - 0.030, y: shisizhang.y)
        let secondBend = CGPoint(x: jingping.x, y: jingping.y + 0.015)
        result["秀朗橋"] = interpolate(firstBend, secondBend, 0.50)

        // 中和—頭前庄維持單一斜率。黃線在藍線的新埔與板橋之間
        // 穿越，環狀線板橋與新埔民生分置交叉點兩側且各自保留節點。
        // 新埔民生與環狀線板橋分居藍線兩側，因此兩站之間的
        // 黃色線段會在藍線新埔—板橋之間實際穿越藍線。
        let circularBanqiao = fixedCircularBanqiao
        result[MetroStationID.circularBanqiao] = circularBanqiao
        result["新埔民生"] = fixedXinpuMinsheng

        guard
            let xinpuMinsheng = result["新埔民生"],
            let fixedTouqianzhuang = result["頭前庄"]
        else { return base }
        let fixedDX = circularBanqiao.x - xinpuMinsheng.x
        let fixedDY = circularBanqiao.y - xinpuMinsheng.y
        guard abs(fixedDY) > 0.000_001 else { return base }

        // 景平到中和維持水平；中和同時由固定斜率推導，讓後段
        // 頭前庄至中和全部落在單一斜率上。
        let zhongheX = xinpuMinsheng.x
            + (middleY - xinpuMinsheng.y) * fixedDX / fixedDY
        result["景平"] = jingping
        result["景安"] = jingan
        let adjustedZhonghe = CGPoint(x: zhongheX, y: middleY)
        result["中和"] = adjustedZhonghe
        let intermediateStations = ["橋和", "中原", "板新"]
        let intermediateProgress: [CGFloat] = [0.25, 0.50, 0.75]
        for (station, progress) in zip(intermediateStations, intermediateProgress) {
            result[station] = interpolate(adjustedZhonghe, circularBanqiao, progress)
        }
        // These three shared anchors stay exactly where the preceding passes
        // placed them; all seven stations are on the same infinite line.
        result[MetroStationID.circularBanqiao] = circularBanqiao
        result["新埔民生"] = xinpuMinsheng
        result["頭前庄"] = fixedTouqianzhuang

        // 頭前庄—新北產業園區：同一條垂直線。
        let newTaipeiIndustrialParkY = sanchong.y - 0.022
        for (index, station) in terminalVertical.enumerated() {
            let progress = CGFloat(index) / CGFloat(terminalVertical.count - 1)
            result[station] = CGPoint(
                x: fixedTouqianzhuang.x,
                y: fixedTouqianzhuang.y
                    + (newTaipeiIndustrialParkY - fixedTouqianzhuang.y) * progress
            )
        }

        return result
    }

    /// Converts the geographic-looking anchors into a schematic network. Each
    /// run between terminals, interchanges, or meaningful bends is a single
    /// straight segment, so every intermediate station shares one slope.
    /// Near-horizontal and near-vertical runs are snapped to their axis when a
    /// movable endpoint makes that possible.
    private static func straightenRouteRuns(_ base: [String: CGPoint]) -> [String: CGPoint] {
        var occurrences: [String: Int] = [:]
        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                for station in segment { occurrences[station, default: 0] += 1 }
            }
        }
        let sharedStations = Set(occurrences.compactMap { station, count in count > 1 ? station : nil })
        var candidates: [String: [CGPoint]] = [:]

        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                let points = segment.compactMap { base[$0] }
                guard points.count == segment.count, points.count > 1 else { continue }

                let mandatoryAnchors = Set(
                    segment.indices.filter {
                        $0 == segment.startIndex
                            || $0 == segment.index(before: segment.endIndex)
                            || sharedStations.contains(segment[$0])
                    }
                )
                let mandatory = mandatoryAnchors.sorted()
                var anchors = mandatoryAnchors
                for (start, end) in zip(mandatory, mandatory.dropFirst()) {
                    addSimplifiedAnchors(
                        points: points,
                        start: start,
                        end: end,
                        tolerance: 0.022,
                        result: &anchors
                    )
                }

                let orderedAnchors = anchors.sorted()
                var anchorPoints = orderedAnchors.map { points[$0] }
                for anchorOffset in 1..<anchorPoints.count {
                    let startIndex = orderedAnchors[anchorOffset - 1]
                    let endIndex = orderedAnchors[anchorOffset]
                    var start = anchorPoints[anchorOffset - 1]
                    var end = anchorPoints[anchorOffset]
                    let dx = end.x - start.x
                    let dy = end.y - start.y
                    let startIsFixed = sharedStations.contains(segment[startIndex])
                    let endIsFixed = sharedStations.contains(segment[endIndex])

                    if abs(dy) <= abs(dx) * 0.28 {
                        if !endIsFixed {
                            end.y = start.y
                        } else if !startIsFixed {
                            start.y = end.y
                            anchorPoints[anchorOffset - 1] = start
                        }
                    } else if abs(dx) <= abs(dy) * 0.28 {
                        if !endIsFixed {
                            end.x = start.x
                        } else if !startIsFixed {
                            start.x = end.x
                            anchorPoints[anchorOffset - 1] = start
                        }
                    }
                    anchorPoints[anchorOffset] = end
                }

                for anchorOffset in 1..<orderedAnchors.count {
                    let lowerIndex = orderedAnchors[anchorOffset - 1]
                    let upperIndex = orderedAnchors[anchorOffset]
                    let lowerPoint = anchorPoints[anchorOffset - 1]
                    let upperPoint = anchorPoints[anchorOffset]
                    let stationSpan = max(upperIndex - lowerIndex, 1)

                    for index in lowerIndex...upperIndex {
                        let progress = CGFloat(index - lowerIndex) / CGFloat(stationSpan)
                        let station = segment[index]
                        candidates[station, default: []].append(
                            interpolate(lowerPoint, upperPoint, progress)
                        )
                    }
                }
            }
        }

        var result = base
        for (station, values) in candidates where !values.isEmpty {
            if sharedStations.contains(station) {
                result[station] = base[station]
                continue
            }
            let total = values.reduce(CGPoint.zero) { partial, point in
                CGPoint(x: partial.x + point.x, y: partial.y + point.y)
            }
            result[station] = CGPoint(
                x: total.x / CGFloat(values.count),
                y: total.y / CGFloat(values.count)
            )
        }
        return result
    }

    /// Ramer-Douglas-Peucker simplification keeps only bends that materially
    /// change the network silhouette; the renderer rounds those corners later.
    private static func addSimplifiedAnchors(
        points: [CGPoint],
        start: Int,
        end: Int,
        tolerance: CGFloat,
        result: inout Set<Int>
    ) {
        guard end - start > 1 else { return }
        var farthestIndex: Int?
        var farthestDistance: CGFloat = 0
        for index in (start + 1)..<end {
            let distance = perpendicularDistance(
                points[index],
                from: points[start],
                to: points[end]
            )
            if distance > farthestDistance {
                farthestDistance = distance
                farthestIndex = index
            }
        }
        guard let farthestIndex, farthestDistance > tolerance else { return }
        result.insert(farthestIndex)
        addSimplifiedAnchors(
            points: points,
            start: start,
            end: farthestIndex,
            tolerance: tolerance,
            result: &result
        )
        addSimplifiedAnchors(
            points: points,
            start: farthestIndex,
            end: end,
            tolerance: tolerance,
            result: &result
        )
    }

    private static func perpendicularDistance(
        _ point: CGPoint,
        from start: CGPoint,
        to end: CGPoint
    ) -> CGFloat {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = hypot(dx, dy)
        guard length > 0 else { return hypot(point.x - start.x, point.y - start.y) }
        return abs(dy * point.x - dx * point.y + end.x * start.y - end.y * start.x) / length
    }

    /// The source artwork gives the map its familiar composition, while this
    /// pass makes each branch read like a transit diagram: stations are placed
    /// at even intervals along the existing route geometry. Shared stations
    /// remain anchored at their interchange position so the network does not
    /// drift or create a second interchange dot.
    private static func equalizeStationSpacing(_ base: [String: CGPoint]) -> [String: CGPoint] {
        var occurrences: [String: Int] = [:]
        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                for station in segment { occurrences[station, default: 0] += 1 }
            }
        }
        let interchangeStations = Set(occurrences.compactMap { key, count in count > 1 ? key : nil })
        var candidates: [String: [CGPoint]] = [:]

        for route in MetroRoute.mockNetwork {
            for segment in route.stationIDSegments {
                let points = segment.compactMap { base[$0] }
                guard points.count == segment.count, points.count > 2 else { continue }
                let resampled = resample(points: points)
                for (index, station) in segment.enumerated() where !interchangeStations.contains(station) {
                    candidates[station, default: []].append(resampled[index])
                }
            }
        }

        var result = base
        for (station, values) in candidates where !values.isEmpty {
            let total = values.reduce(CGPoint.zero) { partial, point in
                CGPoint(x: partial.x + point.x, y: partial.y + point.y)
            }
            result[station] = CGPoint(
                x: total.x / CGFloat(values.count),
                y: total.y / CGFloat(values.count)
            )
        }
        return result
    }

    private static func resample(points: [CGPoint]) -> [CGPoint] {
        guard points.count > 2 else { return points }
        var lengths = [CGFloat](repeating: 0, count: points.count)
        for index in 1..<points.count {
            lengths[index] = lengths[index - 1] + hypot(
                points[index].x - points[index - 1].x,
                points[index].y - points[index - 1].y
            )
        }
        guard let total = lengths.last, total > 0 else { return points }

        return points.indices.map { index in
            let target = total * CGFloat(index) / CGFloat(points.count - 1)
            guard let upper = lengths.firstIndex(where: { $0 >= target }), upper > 0 else {
                return points[0]
            }
            let lower = upper - 1
            let span = lengths[upper] - lengths[lower]
            let progress = span > 0 ? (target - lengths[lower]) / span : 0
            return CGPoint(
                x: points[lower].x + (points[upper].x - points[lower].x) * progress,
                y: points[lower].y + (points[upper].y - points[lower].y) * progress
            )
        }
    }

    private static func interpolatedPosition(at index: Int, in known: [(Int, CGPoint)]) -> CGPoint? {
        if let lower = known.last(where: { $0.0 < index }),
           let upper = known.first(where: { $0.0 > index }) {
            let progress = CGFloat(index - lower.0) / CGFloat(upper.0 - lower.0)
            return interpolate(lower.1, upper.1, progress)
        }

        let pair = index < known[0].0 ? Array(known.prefix(2)) : Array(known.suffix(2))
        guard pair.count == 2 else { return nil }
        let first = pair[0]
        let second = pair[1]
        let progress = CGFloat(index - first.0) / CGFloat(second.0 - first.0)
        return interpolate(first.1, second.1, progress)
    }

    private static func interpolate(_ start: CGPoint, _ end: CGPoint, _ progress: CGFloat) -> CGPoint {
        CGPoint(
            x: start.x + (end.x - start.x) * progress,
            y: start.y + (end.y - start.y) * progress
        )
    }

    private static func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x, y: y)
    }
}
