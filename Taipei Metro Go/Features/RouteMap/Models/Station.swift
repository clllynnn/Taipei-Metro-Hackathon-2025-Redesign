import CoreLocation
import Foundation

struct Station: Identifiable, Hashable {
    let id: String
    let name: String
    let line: MetroLine
    let interchangeLines: [MetroLine]
    let coordinates: StationCoordinates
    let exitInfo: [String]

    var lines: [MetroLine] { [line] + interchangeLines }

    func mapName(for language: AppLanguage) -> String {
        language == .english ? (Self.englishNames[name] ?? name) : name
    }

    init(
        id: String,
        name: String,
        line: MetroLine,
        coordinates: StationCoordinates,
        exitInfo: [String],
        interchangeLines: [MetroLine] = []
    ) {
        self.id = id
        self.name = name
        self.line = line
        self.interchangeLines = interchangeLines
        self.coordinates = coordinates
        self.exitInfo = exitInfo
    }
}

private extension Station {
    static let englishNames: [String: String] = [
        "動物園": "Taipei Zoo", "木柵": "Muzha", "萬芳社區": "Wanfang Community", "萬芳醫院": "Wanfang Hospital",
        "辛亥": "Xinhai", "麟光": "Linguang", "六張犁": "Liuzhangli", "科技大樓": "Technology Building",
        "大安": "Daan", "忠孝復興": "Zhongxiao Fuxing", "南京復興": "Nanjing Fuxing", "中山國中": "Zhongshan Junior High School",
        "松山機場": "Songshan Airport", "大直": "Dazhi", "劍南路": "Jiannan Rd.", "西湖": "Xihu", "港墘": "Gangqian",
        "文德": "Wende", "內湖": "Neihu", "大湖公園": "Dahu Park", "葫洲": "Huzhou", "東湖": "Donghu",
        "南港軟體園區": "Nangang Software Park", "南港展覽館": "Taipei Nangang Exhibition Center",
        "廣慈/奉天宮": "Guangci/Fengtian Temple", "象山": "Xiangshan",
        "台北101/世貿": "Taipei 101/World Trade Center", "信義安和": "Xinyi Anhe",
        "大安森林公園": "Daan Park", "東門": "Dongmen", "中正紀念堂": "Chiang Kai-Shek Memorial Hall", "台大醫院": "NTU Hospital",
        "台北車站": "Taipei Main Station", "中山": "Zhongshan", "雙連": "Shuanglian", "民權西路": "Minquan W. Rd.",
        "圓山": "Yuanshan", "劍潭": "Jiantan", "士林": "Shilin", "芝山": "Zhishan", "明德": "Mingde", "石牌": "Shipai",
        "唭哩岸": "Qilian", "奇岩": "Qiyan", "北投": "Beitou", "新北投": "Xinbeitou", "復興崗": "Fuxinggang", "忠義": "Zhongyi",
        "關渡": "Guandu", "竹圍": "Zhuwei", "紅樹林": "Hongshulin", "淡水": "Tamsui",
        "新店": "Xindian", "新店區公所": "Xindian District Office", "七張": "Qizhang", "小碧潭": "Xiaobitan", "大坪林": "Dapinglin",
        "景美": "Jingmei", "萬隆": "Wanlong", "公館": "Gongguan", "台電大樓": "Taipower Building", "古亭": "Guting",
        "小南門": "Xiaonanmen", "西門": "Ximen", "北門": "Beimen", "松江南京": "Songjiang Nanjing", "台北小巨蛋": "Taipei Arena",
        "南京三民": "Nanjing Sanmin", "松山": "Songshan", "南勢角": "Nanshijiao", "景安": "Jingan", "永安市場": "Yongan Market",
        "頂溪": "Dingxi", "忠孝新生": "Zhongxiao Xinsheng", "行天宮": "Xingtian Temple", "中山國小": "Zhongshan Elementary School",
        "大橋頭": "Daqiaotou", "台北橋": "Taipei Bridge", "菜寮": "Cailiao", "三重": "Sanchong", "先嗇宮": "Xianse Temple",
        "頭前庄": "Touqianzhuang", "新莊": "Xinzhuang", "輔大": "Fu Jen University", "丹鳳": "Danfeng", "迴龍": "Huilong",
        "三重國小": "Sanchong Elementary School", "三和國中": "Sanhe Junior High School", "徐匯中學": "St. Ignatius High School",
        "三民高中": "Sanmin Senior High School", "蘆洲": "Luzhou", "頂埔": "Dingpu", "永寧": "Yongning", "土城": "Tucheng",
        "海山": "Haishan", "亞東醫院": "Far Eastern Hospital", "府中": "Fuzhong", "板橋": "Banqiao", "新埔": "Xinpu",
        "江子翠": "Jiangzicui", "龍山寺": "Longshan Temple", "善導寺": "Shandao Temple", "忠孝敦化": "Zhongxiao Dunhua",
        "國父紀念館": "Sun Yat-Sen Memorial Hall", "市政府": "Taipei City Hall", "永春": "Yongchun", "後山埤": "Houshanpi",
        "昆陽": "Kunyang", "南港": "Nangang", "十四張": "Shisizhang", "秀朗橋": "Xiulang Bridge", "景平": "Jingping",
        "中和": "Zhonghe", "橋和": "Qiahe", "中原": "Zhongyuan", "板新": "Banxin", "新埔民生": "Xinpu Minsheng",
        "幸福": "Xingfu", "新北產業園區": "New Taipei Industrial Park"
    ]
}

enum MetroLine: String, CaseIterable, Hashable {
    case brown = "BR"
    case red = "R"
    case green = "G"
    case orange = "O"
    case blue = "BL"
    case yellow = "Y"
}

enum MetroStationID {
    /// The Circular line's Banqiao platform is drawn as a separate node from
    /// Bannan line Banqiao because the two station buildings are offset.
    static let circularBanqiao = "Y-板橋"
}

struct MetroRoute: Identifiable {
    let line: MetroLine
    let stationIDSegments: [[String]]

    var id: String { line.rawValue }

    static let mockNetwork: [MetroRoute] = MetroNetwork.definitions.map { definition in
        MetroRoute(line: definition.line, stationIDSegments: definition.segments)
    }
}

extension Station {
    static let mockNetwork: [Station] = MetroNetwork.stations
}

struct StationCoordinates: Hashable {
    /// Geographic source coordinates used to lay out and estimate distances between stations.
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }

}

enum StationInfoTab: String, CaseIterable, Identifiable {
    case rideInfo
    case stationFacilities
    case transferInfo

    var id: String { rawValue }

    var title: String {
        switch self {
        case .rideInfo: "乘車資訊"
        case .stationFacilities: "站內設施"
        case .transferInfo: "轉乘資訊"
        }
    }
}

struct CarriageLocation: Equatable {
    let carNumber: Int
    let doorNumber: Int
}

enum StationFacilityKind: String, CaseIterable, Hashable {
    case restroom
    case escalator
    case elevator
    case serviceDesk
    case wayfinding

    var title: String {
        switch self {
        case .restroom: "廁所"
        case .escalator: "手扶梯"
        case .elevator: "電梯"
        case .serviceDesk: "服務台"
        case .wayfinding: "引導標示"
        }
    }

    var symbol: String {
        switch self {
        case .restroom: "toilet"
        case .escalator: "escalator"
        case .elevator: "figure.roll"
        case .serviceDesk: "person.crop.square"
        case .wayfinding: "signpost.right.fill"
        }
    }
}

struct StationExitGuide: Identifiable, Hashable {
    let id: String
    let name: String
    let facilities: [StationFacilityKind]
    let guidance: String

    init(name: String, facilities: [StationFacilityKind], guidance: String) {
        self.id = name
        self.name = name
        self.facilities = facilities
        self.guidance = guidance
    }
}

extension Station {
    /// Exit-level facility data used by the station information sheet. Stations
    /// with known interchange layouts override the default guide below.
    var exitGuides: [StationExitGuide] {
        if let override = Self.exitGuideOverrides[name] { return override }
        return exitInfo.enumerated().map { index, exit in
            StationExitGuide(
                name: exit,
                facilities: index == 0
                    ? [.restroom, .escalator, .elevator, .serviceDesk, .wayfinding]
                    : [.restroom, .escalator, .wayfinding],
                guidance: index == 0 ? "靠近主要大廳與無障礙動線" : "沿月台指標前往出口"
            )
        }
    }

    private static let exitGuideOverrides: [String: [StationExitGuide]] = [
        "台北車站": [
            StationExitGuide(name: "M4／台鐵高鐵", facilities: [.escalator, .elevator, .wayfinding], guidance: "前往台鐵、高鐵與地下街連通道"),
            StationExitGuide(name: "M8／服務中心", facilities: [.restroom, .escalator, .serviceDesk, .wayfinding], guidance: "前往站務服務與地下街主要大廳")
        ],
        "板橋": [
            StationExitGuide(name: "3 號出口／板橋車站", facilities: [.escalator, .elevator, .wayfinding], guidance: "通往台鐵、高鐵與公車轉運站"),
            StationExitGuide(name: "2 號出口／府中商圈", facilities: [.restroom, .escalator, .serviceDesk, .wayfinding], guidance: "通往府中商圈與站外服務")
        ],
        "南港": [
            StationExitGuide(name: "1 號出口／台鐵高鐵", facilities: [.escalator, .elevator, .wayfinding], guidance: "沿連通道前往台鐵、高鐵南港站"),
            StationExitGuide(name: "2 號出口／公車", facilities: [.escalator, .serviceDesk, .wayfinding], guidance: "前往南港轉運與公車站牌")
        ],
        "忠孝復興": [
            StationExitGuide(name: "1 號出口／轉乘通道", facilities: [.escalator, .elevator, .wayfinding], guidance: "依指標轉乘文湖線與板南線"),
            StationExitGuide(name: "4 號出口／商圈", facilities: [.restroom, .escalator, .wayfinding], guidance: "通往忠孝商圈地面層")
        ]
    ]
}

private struct RouteDefinition {
    let line: MetroLine
    let segments: [[String]]
}

private enum MetroNetwork {
    // Each branch is a separate connected path; interchange stations are shared nodes.
    static let definitions: [RouteDefinition] = [
        RouteDefinition(line: .brown, segments: [[
            "動物園", "木柵", "萬芳社區", "萬芳醫院", "辛亥", "麟光", "六張犁", "科技大樓", "大安",
            "忠孝復興", "南京復興", "中山國中", "松山機場", "大直", "劍南路", "西湖", "港墘", "文德",
            "內湖", "大湖公園", "葫洲", "東湖", "南港軟體園區", "南港展覽館"
        ]]),
        RouteDefinition(line: .red, segments: [
            [
                "廣慈/奉天宮", "象山", "台北101/世貿", "信義安和", "大安", "大安森林公園", "東門", "中正紀念堂", "台大醫院",
                "台北車站", "中山", "雙連", "民權西路", "圓山", "劍潭", "士林", "芝山", "明德", "石牌",
                "唭哩岸", "奇岩", "北投", "復興崗", "忠義", "關渡", "竹圍", "紅樹林", "淡水"
            ],
            ["北投", "新北投"]
        ]),
        RouteDefinition(line: .green, segments: [
            [
                "新店", "新店區公所", "七張", "大坪林", "景美", "萬隆", "公館", "台電大樓", "古亭",
                "中正紀念堂", "小南門", "西門", "北門", "中山", "松江南京", "南京復興", "台北小巨蛋",
                "南京三民", "松山"
            ],
            ["七張", "小碧潭"]
        ]),
        RouteDefinition(line: .orange, segments: [
            ["南勢角", "景安", "永安市場", "頂溪", "古亭", "東門", "忠孝新生", "松江南京", "行天宮", "中山國小", "民權西路", "大橋頭"],
            ["大橋頭", "三重國小", "三和國中", "徐匯中學", "三民高中", "蘆洲"],
            ["大橋頭", "台北橋", "菜寮", "三重", "先嗇宮", "頭前庄", "新莊", "輔大", "丹鳳", "迴龍"]
        ]),
        RouteDefinition(line: .blue, segments: [[
            "頂埔", "永寧", "土城", "海山", "亞東醫院", "府中", "板橋", "新埔", "江子翠", "龍山寺", "西門",
            "台北車站", "善導寺", "忠孝新生", "忠孝復興", "忠孝敦化", "國父紀念館", "市政府", "永春",
            "後山埤", "昆陽", "南港", "南港展覽館"
        ]]),
        RouteDefinition(line: .yellow, segments: [[
            "大坪林", "十四張", "秀朗橋", "景平", "景安", "中和", "橋和", "中原", "板新", MetroStationID.circularBanqiao,
            "新埔民生", "頭前庄", "幸福", "新北產業園區"
        ]])
    ]

    static let stations: [Station] = {
        let orderedNames = definitions.flatMap { $0.segments.flatMap { $0 } }
        var uniqueNames: [String] = []
        var seen = Set<String>()
        for name in orderedNames where seen.insert(name).inserted {
            uniqueNames.append(name)
        }

        return uniqueNames.map { stationID in
            let servedLines = definitions.compactMap { route in
                route.segments.contains(where: { $0.contains(stationID) }) ? route.line : nil
            }
            let orderedLines = linePriority.filter(servedLines.contains)
            let primaryLine = orderedLines.first ?? .red
            guard let coordinates = coordinatesByName[stationID] else {
                preconditionFailure("Missing geographic coordinates for station: \(stationID)")
            }
            return Station(
                id: stationID,
                name: displayNamesByID[stationID] ?? stationID,
                line: primaryLine,
                coordinates: coordinates,
                exitInfo: ["1 號出口", "2 號出口"],
                interchangeLines: Array(orderedLines.dropFirst())
            )
        }
    }()

    private static let linePriority: [MetroLine] = [.red, .blue, .green, .orange, .brown, .yellow]

    private static let displayNamesByID: [String: String] = [
        MetroStationID.circularBanqiao: "板橋"
    ]

    // Station entrances/station-center coordinates are geographic rather than hand-laid.
    // Most coordinates are from the Taipei Metro station coordinates CSV; the newer
    // Circular Line locations use OpenStreetMap station records.
    private static let coordinatesByName: [String: StationCoordinates] = [
        "動物園": .init(24.998197, 121.579338), "木柵": .init(24.998241, 121.573145),
        "萬芳社區": .init(24.998585, 121.568102), "萬芳醫院": .init(24.999386, 121.558152),
        "辛亥": .init(25.005475, 121.557107), "麟光": .init(25.018535, 121.558791),
        "六張犁": .init(25.023777, 121.553115), "科技大樓": .init(25.026125, 121.543437),
        "大安": .init(25.032943, 121.543551), "忠孝復興": .init(25.041629, 121.543767),
        "南京復興": .init(25.052319, 121.544011), "中山國中": .init(25.060849, 121.544227),
        "松山機場": .init(25.063, 121.551996), "大直": .init(25.079477, 121.546895),
        "劍南路": .init(25.084853, 121.555592), "西湖": .init(25.082133, 121.567213),
        "港墘": .init(25.080028, 121.575081), "文德": .init(25.078532, 121.584761),
        "內湖": .init(25.083661, 121.594408), "大湖公園": .init(25.083845, 121.602141),
        "葫洲": .init(25.072701, 121.607158), "東湖": .init(25.067147, 121.611445),
        "南港軟體園區": .init(25.059905, 121.615953), "南港展覽館": .init(25.055288, 121.6175001),

        "廣慈/奉天宮": .init(25.03825, 121.57955),
        "象山": .init(25.03283, 121.569576), "台北101/世貿": .init(25.033102, 121.563292),
        "信義安和": .init(25.033326, 121.553526), "大安森林公園": .init(25.033396, 121.534882),
        "東門": .init(25.033847, 121.528739), "中正紀念堂": .init(25.032729, 121.51827),
        "台大醫院": .init(25.041256, 121.51604), "台北車站": .init(25.046255, 121.517532),
        "中山": .init(25.052685, 121.520392), "雙連": .init(25.057805, 121.520627),
        "民權西路": .init(25.062905, 121.51932), "圓山": .init(25.071353, 121.520118),
        "劍潭": .init(25.084873, 121.525078), "士林": .init(25.093535, 121.52623),
        "芝山": .init(25.10306, 121.522514), "明德": .init(25.109721, 121.518848),
        "石牌": .init(25.114523, 121.515559), "唭哩岸": .init(25.120872, 121.506252),
        "奇岩": .init(25.125491, 121.501132), "北投": .init(25.131841, 121.498633),
        "新北投": .init(25.136933, 121.50253), "復興崗": .init(25.137474, 121.485444),
        "忠義": .init(25.130969, 121.47341), "關渡": .init(25.125633, 121.467102),
        "竹圍": .init(25.13694, 121.459479), "紅樹林": .init(25.154042, 121.458872),
        "淡水": .init(25.167818, 121.445561),

        "新店": .init(24.957855, 121.537584), "新店區公所": .init(24.967393, 121.54131),
        "七張": .init(24.975169, 121.542942), "小碧潭": .init(24.971907, 121.530339),
        "大坪林": .init(24.982899, 121.541352), "景美": .init(24.9921276, 121.5406037),
        "萬隆": .init(25.001853, 121.539051), "公館": .init(25.014908, 121.534216),
        "台電大樓": .init(25.020725, 121.528168), "古亭": .init(25.026357, 121.522873),
        "小南門": .init(25.035547, 121.510857), "西門": .init(25.04209, 121.508303),
        "北門": .init(25.049554, 121.510184), "松江南京": .init(25.052015, 121.533075),
        "台北小巨蛋": .init(25.051836, 121.55153), "南京三民": .init(25.051652, 121.564708),
        "松山": .init(25.049283, 121.578012),

        "南勢角": .init(24.990045, 121.509237), "景安": .init(24.993905, 121.505113),
        "永安市場": .init(25.002876, 121.511231), "頂溪": .init(25.013821, 121.515485),
        "忠孝新生": .init(25.042356, 121.532905), "行天宮": .init(25.059718, 121.533185),
        "中山國小": .init(25.062694, 121.526419), "大橋頭": .init(25.063256, 121.51272),
        "台北橋": .init(25.063274, 121.500762), "菜寮": .init(25.060274, 121.492156),
        "三重": .init(25.055791, 121.484725), "先嗇宮": .init(25.046493, 121.471916),
        "頭前庄": .init(25.039705, 121.461746), "新莊": .init(25.036125, 121.452468),
        "輔大": .init(25.032718, 121.43547), "丹鳳": .init(25.0288671, 121.4227079),
        "迴龍": .init(25.021862, 121.41127), "三重國小": .init(25.070319, 121.496904),
        "三和國中": .init(25.076859, 121.486347), "徐匯中學": .init(25.080728, 121.479673),
        "三民高中": .init(25.085456, 121.473389), "蘆洲": .init(25.091554, 121.464471),

        "頂埔": .init(24.96012, 121.4205), "永寧": .init(24.966726, 121.436072),
        "土城": .init(24.973094, 121.444362), "海山": .init(24.985339, 121.448786),
        "亞東醫院": .init(24.998037, 121.452514), "府中": .init(25.008619, 121.459409),
        "板橋": .init(25.013618, 121.462302), "新埔": .init(25.023738, 121.468361),
        "江子翠": .init(25.03001, 121.47239), "龍山寺": .init(25.03528, 121.499826),
        "善導寺": .init(25.044823, 121.523208), "忠孝敦化": .init(25.041478, 121.551098),
        "國父紀念館": .init(25.041349, 121.557802), "市政府": .init(25.041171, 121.565228),
        "永春": .init(25.040859, 121.576293), "後山埤": .init(25.045055, 121.582522),
        "昆陽": .init(25.050461, 121.593268), "南港": .init(25.052116, 121.606686),

        // Circular line station records (OpenStreetMap).
        "十四張": .init(24.98454, 121.52712),
        "秀朗橋": .init(24.99033, 121.5249), "景平": .init(24.99216, 121.51638),
        "中和": .init(25.00236, 121.49621), "橋和": .init(25.0046, 121.49025),
        "中原": .init(25.00818, 121.48427), "板新": .init(25.01453, 121.47242),
        MetroStationID.circularBanqiao: .init(25.01513, 121.46473),
        "新埔民生": .init(25.02613, 121.46667), "幸福": .init(25.04999, 121.45997),
        "新北產業園區": .init(25.06125, 121.45968)
    ]
}
