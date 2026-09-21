import Combine
import Foundation

@MainActor
final class MetroRadioViewModel: ObservableObject {
    @Published var currentSong: SongRequest?
    @Published var streakDays: Int
    @Published var metroPoints: Int
    @Published var selectedCategory: ChatCategory = .officeWorker
    @Published var isCheckedOut: Bool = false
    @Published var timeMood: MetroRadioTimeMood
    @Published private(set) var isTimeSimulated = false

    @Published private(set) var lotteryChancePercent = 5
    @Published private(set) var didCheckInToday = false
    @Published private(set) var checkInStatus: LuckyCheckInStatus = .available
    @Published private(set) var lastDrawOutcome: LuckyDrawOutcome?
    @Published private(set) var lastCheckInDate: Date?
    @Published private(set) var mySongRequest: SongRequest?
    @Published private(set) var previousSongRequest: SongRequest?
    @Published private(set) var helpMessages: [MutualHelpMessage]
    @Published private(set) var casualMessages: [CasualChatMessage]
    @Published private(set) var directMessageReplies: [UUID: [String]] = [:]
    @Published private(set) var archivedCasualMessageIDs: Set<UUID> = []
    @Published var songDraftTitle = ""
    @Published var songDraftStory = ""

    let currentTrainID = "BL-1452"
    let currentStationName = "台北車站"
    let currentCarriageNumber = "3-2"
    let currentLineName = "板南線"
    let currentLineColorHex = MetroColor.hex(for: .blue)

    private let calendar = Calendar.current
    private let storage: UserDefaults

    private enum StorageKey {
        static let streakDays = "metroRadio.streakDays"
        static let metroPoints = "metroRadio.metroPoints"
        static let lotteryChance = "metroRadio.lotteryChance"
        static let lastCheckInDate = "metroRadio.lastCheckInDate"
        static let previousSongRequest = "metroRadio.previousSongRequest"
    }

    init(timeMood: MetroRadioTimeMood? = nil, now: Date = .now, storage: UserDefaults = .standard) {
        self.storage = storage
        self.timeMood = timeMood ?? MetroRadioTimeMood.from(date: now)
        let savedStreak = storage.integer(forKey: StorageKey.streakDays)
        let savedPoints = storage.integer(forKey: StorageKey.metroPoints)
        let savedChance = storage.integer(forKey: StorageKey.lotteryChance)
        streakDays = savedStreak == 0 ? 1 : savedStreak
        metroPoints = savedPoints
        lastCheckInDate = storage.object(forKey: StorageKey.lastCheckInDate) as? Date
            ?? calendar.date(byAdding: .day, value: -1, to: now)
        if savedChance > 0 {
            lotteryChancePercent = min(savedChance, 50)
        }

        // This is the daily lucky passenger's selected song. It is separate from
        // the user's own request, which is submitted through the check-in sheet.
        currentSong = SongRequest(
            title: "稻香",
            artist: "周杰倫",
            requesterStory: "每次搭車回家聽到這首歌，就想起小時候和家人一起吃晚餐的日子。今天的幸運乘客把這段回憶送給沿線的你。",
            stationName: "台北車站 · 板南線",
            isPlaying: true,
            checkInStreak: 7
        )

        // Seeded history keeps the preview useful. A real account would load this
        // from its persisted request history.
        let samplePreviousSongRequest = SongRequest(
            title: "旅行的意義",
            artist: "陳綺貞",
            requesterStory: "回家的路上聽著這首歌，提醒自己慢一點也沒關係。",
            stationName: "市政府站 · 板南線",
            isPlaying: false,
            checkInStreak: 1
        )
        if let data = storage.data(forKey: StorageKey.previousSongRequest),
           let savedRequest = try? JSONDecoder().decode(SongRequest.self, from: data) {
            previousSongRequest = savedRequest
        } else {
            previousSongRequest = samplePreviousSongRequest
        }

        helpMessages = [
            MutualHelpMessage(stationName: "忠孝復興站", carriageNumber: "3-2", content: "請問有人也是往南港方向嗎？想確認轉乘月台。", timestamp: Date().addingTimeInterval(-240), trainID: currentTrainID, publicAlias: "藍線旅人"),
            MutualHelpMessage(stationName: "市政府站", carriageNumber: "2-1", content: "下一站下車，可以幫忙提醒一下嗎？謝謝！", timestamp: Date().addingTimeInterval(-510), trainID: currentTrainID),
            MutualHelpMessage(stationName: "國父紀念館站", carriageNumber: "1-3", content: "有輪椅乘客需要協助，請問哪個出口有電梯？", timestamp: Date().addingTimeInterval(-900), trainID: "BL-1448")
        ]
        casualMessages = [
            CasualChatMessage(lineName: "板南線", lineColorHex: MetroColor.hex(for: .blue), message: "今天下班列車冷氣好舒服，差點坐過站 😴", timestamp: Date().addingTimeInterval(-180), category: .officeWorker),
            CasualChatMessage(lineName: "淡水信義線", lineColorHex: MetroColor.hex(for: .red), message: "有人也在追本週的新番嗎？", timestamp: Date().addingTimeInterval(-420), category: .anime),
            CasualChatMessage(lineName: "松山新店線", lineColorHex: MetroColor.hex(for: .green), message: "剛剛看到超可愛的導盲犬，今天被療癒了 🐕", timestamp: Date().addingTimeInterval(-720), category: .pets),
            CasualChatMessage(lineName: "文湖線", lineColorHex: MetroColor.hex(for: .brown), message: "期中週的大家還好嗎？一起加油。", timestamp: Date().addingTimeInterval(-1_020), category: .student),
            CasualChatMessage(lineName: "板南線", lineColorHex: MetroColor.hex(for: .blue), message: "今天的通勤迷因：人到公司了，靈魂還在月台。", timestamp: Date().addingTimeInterval(-1_300), category: .memes)
        ]
        refreshCheckInState(now: now)
    }

    var visibleCasualMessages: [CasualChatMessage] {
        casualMessages.filter {
            $0.category == selectedCategory && !archivedCasualMessageIDs.contains($0.id)
        }
    }

    var activeHelpMessages: [MutualHelpMessage] {
        let activeWindow: TimeInterval = 30 * 60
        return helpMessages.filter {
            $0.lineName == currentLineName && Date().timeIntervalSince($0.timestamp) < activeWindow
        }
    }

    var nextCheckInReward: Int {
        5 + min((max(streakDays, 0) + 1) * 2, 25)
    }

    var weeklyProgress: Double {
        guard streakDays > 0 else { return 0 }
        let remainder = streakDays % 7
        return remainder == 0 ? 1 : Double(remainder) / 7
    }

    var daysUntilWeeklyBonus: Int {
        let remainder = streakDays % 7
        return remainder == 0 ? 0 : 7 - remainder
    }

    /// 正式規則以每日 20:00 開獎；深夜到清晨仍保留結果入口。
    var isDailyDrawOpen: Bool {
        if isTimeSimulated {
            return timeMood == .lateNight
        }
        let hour = calendar.component(.hour, from: Date())
        return hour >= 20 || hour < 5
    }

    var checkInButtonTitle: String {
        guard didCheckInToday else { return "我要點歌" }
        switch checkInStatus {
        case .available: return "查看今日點播"
        case .submitted, .carriedOver, .winner, .notSelected: return "查看今日點播"
        }
    }

    var checkInButtonSubtitle: String {
        guard didCheckInToday else { return "每日登記並累積捷運點" }
        switch checkInStatus {
        case .available: return "今日點播已完成登記"
        case .submitted: return "已送出，等待今日抽選"
        case .carriedOver: return "已沿用上次歌曲與故事"
        case .winner: return "你的歌曲已成為今日點播"
        case .notSelected: return "紀錄已保留，明天可一鍵沿用"
        }
    }

    func refreshCheckInState(now: Date = .now) {
        guard let lastCheckInDate else { return }
        if calendar.isDate(lastCheckInDate, inSameDayAs: now) {
            didCheckInToday = true
            if checkInStatus == .available, let previousSongRequest {
                mySongRequest = previousSongRequest
                checkInStatus = .submitted
            }
            return
        }

        didCheckInToday = false
        checkInStatus = .available
        lastDrawOutcome = nil
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else { return }
        if !calendar.isDate(lastCheckInDate, inSameDayAs: yesterday) {
            streakDays = 0
            persistCheckInProgress()
        }
    }

    func simulateTimeMood(_ mood: MetroRadioTimeMood) {
        timeMood = mood
        isTimeSimulated = true
    }

    func useCurrentTimeMood(now: Date = .now) {
        timeMood = MetroRadioTimeMood.from(date: now)
        isTimeSimulated = false
    }

    func togglePlay() {
        guard var song = currentSong else { return }
        song.isPlaying.toggle()
        currentSong = song
    }

    func prepareSongDraftForPresentation() {
        if didCheckInToday, let request = mySongRequest ?? previousSongRequest {
            songDraftTitle = request.title
            songDraftStory = request.requesterStory
        } else {
            songDraftTitle = ""
            songDraftStory = ""
        }
    }

    func submitSongCheckIn(reusePrevious: Bool = false, now: Date = .now) {
        refreshCheckInState(now: now)
        guard !didCheckInToday else { return }

        if reusePrevious, let previous = previousSongRequest {
            songDraftTitle = previous.title
            songDraftStory = previous.requesterStory
        }

        let title = songDraftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let story = songDraftStory.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty, !story.isEmpty else { return }

        let wasYesterday = lastCheckInDate.map { date in
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else { return false }
            return calendar.isDate(date, inSameDayAs: yesterday)
        } ?? false
        streakDays = wasYesterday ? max(streakDays, 0) + 1 : 1

        metroPoints += nextCheckInReward
        lotteryChancePercent = min(lotteryChancePercent + 1 + streakDays / 3, 50)
        lastCheckInDate = now
        didCheckInToday = true
        checkInStatus = reusePrevious ? .carriedOver : .submitted
        lastDrawOutcome = nil

        let request = SongRequest(
            title: title,
            artist: "捷客點播",
            requesterStory: story,
            stationName: "\(currentStationName) · \(currentLineName)",
            isPlaying: false,
            checkInStreak: streakDays
        )
        mySongRequest = request
        previousSongRequest = request
        persistCheckInProgress()
        persistPreviousSongRequest(request)
        // The user's request enters the draw pool. It does not replace today's
        // selected lucky passenger song immediately.
    }

    /// Simulates the daily draw. The chance is a real threshold for the demo:
    /// a roll below the accumulated percentage selects the user's request.
    func drawLottery(
        roll: Double = Double.random(in: 0..<100),
        forcedOutcome: LuckyDrawOutcome? = nil
    ) {
        guard let request = mySongRequest,
              checkInStatus == .submitted || checkInStatus == .carriedOver else { return }

        let didWin = forcedOutcome.map { $0 == .winner } ?? (roll < Double(lotteryChancePercent))
        if didWin {
            currentSong = SongRequest(
                id: request.id,
                title: request.title,
                artist: request.artist,
                requesterStory: request.requesterStory,
                stationName: request.stationName,
                isPlaying: true,
                checkInStreak: request.checkInStreak
            )
            checkInStatus = .winner
            lastDrawOutcome = .winner
        } else {
            checkInStatus = .notSelected
            lastDrawOutcome = .notSelected
        }
    }

    /// 建立一次不累積點數、不寫入 UserDefaults 的抽選預覽。
    func prepareLotterySimulation() {
        if mySongRequest == nil {
            mySongRequest = previousSongRequest ?? currentSong
        }
        checkInStatus = .submitted
        lastDrawOutcome = nil
    }

    func sendHelpMessage(_ content: String) {
        let cleanContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanContent.isEmpty, !isCheckedOut else { return }
        helpMessages.insert(
            MutualHelpMessage(
                stationName: currentStationName,
                carriageNumber: currentCarriageNumber,
                content: cleanContent,
                timestamp: Date(),
                trainID: currentTrainID,
                lineName: currentLineName
            ),
            at: 0
        )
    }

    func canStartDirectMessage(with message: MutualHelpMessage) -> Bool {
        !message.isDirectMessage && message.trainID == currentTrainID
    }

    func startDirectMessage(messageID: UUID) -> MutualHelpMessage? {
        guard let index = helpMessages.firstIndex(where: { $0.id == messageID }),
              helpMessages[index].trainID == currentTrainID else { return nil }
        helpMessages[index].isDirectMessage = true
        return helpMessages[index]
    }

    func sendDirectMessage(_ text: String, to messageID: UUID) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }
        directMessageReplies[messageID, default: []].append(cleanText)
    }

    func sendCasualMessage(_ text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty, !isCheckedOut else { return }
        casualMessages.append(
            CasualChatMessage(
                lineName: currentLineName,
                lineColorHex: currentLineColorHex,
                message: cleanText,
                timestamp: Date(),
                category: selectedCategory
            )
        )
    }

    func simulateCheckout() {
        archivedCasualMessageIDs.formUnion(casualMessages.map(\.id))
        isCheckedOut = true
    }

    func simulateCheckInAgain() {
        isCheckedOut = false
    }

    private func persistCheckInProgress() {
        storage.set(streakDays, forKey: StorageKey.streakDays)
        storage.set(metroPoints, forKey: StorageKey.metroPoints)
        storage.set(lotteryChancePercent, forKey: StorageKey.lotteryChance)
        storage.set(lastCheckInDate, forKey: StorageKey.lastCheckInDate)
    }

    private func persistPreviousSongRequest(_ request: SongRequest) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        storage.set(data, forKey: StorageKey.previousSongRequest)
    }

}
