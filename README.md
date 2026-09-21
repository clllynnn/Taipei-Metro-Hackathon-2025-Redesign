# Taipei Metro Go

## Project Overview

Taipei Metro Go is a **Taipei Metro Go App Redesign** concept built with SwiftUI and a web prototype. The redesign aims to make transit information easier to understand, help passengers complete everyday travel tasks, and provide more inclusive support for different needs.

I developed this project with friends from management, design, computer science, and electrical engineering studied at NTUST. We entered the 2025 Taipei Metro Hackathon under the team name **要不要搭捷運 / Should I Take the Metro?** and received 3rd place.

Our product concept used emotional design as a starting point and combined it with an **AI dynamic recommendation system** to reshape the rhythm of everyday travel decisions. The dual-mode interface addressed both commuter efficiency and the usability needs of older adults and passengers who need accessibility support. The innovative **MetroTogether** concept used music, chat, and emotional companionship to ease the anxiety and loneliness of commuting, turning waiting time into a more connected experience.

The competition version communicated the product concept through a final demo. After the competition, I used Codex to continue iterating the product, focusing on how the overall app information architecture is presented and on rapid MVP validation.

- [Taipei City Government: 2025 Taipei Metro Hackathon results](https://www.gov.taipei/News_Content.aspx?n=F0DDAF49B89E9413&s=C6122A8A549FD692)
- [Taipei Metro: competition brief and theme](https://www.metro.taipei/News_Content.aspx?n=30CCEFD2A45592BF&sms=72544237BBE4C5F6&s=8094C28B588FCBC9)

## Team collaboration and my contribution

I focused on team coordination, schedule planning, early exploration and research, and concept-prototype implementation.

My main contributions were:

- defining the product problem and translating research inputs into product requirements;
- shaping the UX/UI direction and product information structure;
- building the high-fidelity competition concept prototype for real-time journey information, Home, Route Map, station information, and service information;
- connecting the team’s technical direction with the product concept and prototype flows.

## Project timeline

While developing **Snoots!** during the 2026 iOS Summer Hackathon, I learned a rapid MVP validation approach. That experience led me to continue developing this project after the competition instead of treating the competition version as the final product. The current GitHub version is an extension of the award-winning work, not a replacement for the original competition submission.

| Period | Phase | Progress focus |
| --- | --- | --- |
| Before late May 2025 | UX Discovery and pre-proposal research | Completed the May 13–16 survey, passenger interviews, moodboard, problem definition, and initial solution direction. |
| Late May 2025 | Initial selection deadline | Translated the UX insights into a competition proposal and presentable product direction. |
| Early July 2025 | Finalist announcement | Selected as 1 of 10 teams from 104 submissions and refined the concept for the final demo. |
| Late August 2025 | Final demo | Presented the competition version through a Figma prototype, storyboard, and technical explanation. |
| After the competition | Codex iteration | Focused on presenting the information architecture clearly, refining task flow, and validating a rapid MVP. |

## Technical implementation

### Current prototype

- **iOS**: SwiftUI prototype in `Taipei Metro Go/`.
- **Web**: installable static prototype in `web-prototype/dist/`.
- **Development approach**: Codex-assisted implementation for fast changes to navigation, UI structure, and prototype flows.
- **Current navigation structure**: Home, Route Map, MetroTogether, Services, and Account.

### Competition AI architecture

The AI architecture was mainly handled by other team members. On the product side, I coordinated how these capabilities could become part of the user experience and competition prototype.

The competition concept included:

- **Firebase / Firestore** for behavior and location-related data;
- **AWS Lambda** for connecting data, recommendation logic, dynamic location, route planning, and UI recommendations;
- **AWS Bedrock LLM** for station prediction and AI-assisted support conversations.

Technical overview: [AI technical overview](https://www.canva.com/design/DAGw1sl83c4/K83wtoP41e_NU1fRmC4lpg/view?utm_content=DAGw1sl83c4&utm_campaign=designshare&utm_medium=link&utm_source=viewer)

## Project links

- [UX Process & Insights](UX_INSIGHTS.en.md): research, design thinking, product structure, and AI-assisted iteration.
- [Product Overview](PRODUCT_OVERVIEW.en.md): product characteristics, user flows, and technical feasibility.
- [Competition Figma final-demo prototype](https://www.figma.com/proto/467ZwEnIUOrVpREiduKbd5/%E8%A6%81%E4%B8%8D%E8%A6%81%E6%90%AD%E6%8D%B7%E9%81%8B?node-id=1-2&t=4C8RnnGyL7Vt3QZN-1)
- Codex MVP validation: current iOS prototype in this repository.

## Run the iOS prototype

1. Open `Taipei Metro Go.xcodeproj` in Xcode.
2. Select the `Taipei Metro Go` scheme.
3. Choose a compatible iPhone Simulator or connected device.
4. Build and run.

The project currently targets iOS 26.5 and uses Swift 5 language mode. Location permission supports nearby-station travel context.

## Run the web prototype

Serve `web-prototype/dist` with any static web server. The folder is self-contained and includes the page, styles, scripts, web manifest, and service worker.

---

### 專案介紹

Taipei Metro Go 是一個以 SwiftUI 與 Web prototype 製作的 **台北捷運 Go App Redesign** 概念專案，Redesign 的目標是讓乘客更容易理解交通資訊、完成日常通勤任務，也能在不同需求下獲得更包容的協助。

這個作品是我與來自管理、設計、資工與電機的大學同學(國立臺灣科技大學）一同組隊參加 2025 捷運盃黑客松共同發想的。我們以「要不要搭捷運」為隊名參賽，最後獲得季軍。

我們提出的產品概念以情緒設計為起點，結合 **AI 動態推薦系統**，重新整理日常通勤的決策節奏，滿足乘客對即時資訊與效率的需求。雙模式介面同時回應通勤族的效率需求，以及中高齡與需要無障礙協助乘客的使用便利。創新內容 **MetroTogether** 透過音樂、聊天室與情緒陪伴，緩解通勤中的焦躁與孤獨，將等待轉化為更有連結感的體驗。

競賽版本以決賽 demo 呈現產品概念；競賽後我使用 Codex 持續建立更完整的產品 prototype。

- [台北市政府：2025 捷運盃黑客松得獎結果](https://www.gov.taipei/News_Content.aspx?n=F0DDAF49B89E9413&s=C6122A8A549FD692)
- [台北捷運：競賽說明與主題](https://www.metro.taipei/News_Content.aspx?n=30CCEFD2A45592BF&sms=72544237BBE4C5F6&s=8094C28B588FCBC9)

### 團隊分工

我在團隊中主要負責協調合作、進度規劃、前期探索與研究，以及概念原型實作。

我主要參與：

- 定義產品問題，將研究輸入轉化為產品需求。
- 形成 UX/UI 方向與產品資訊結構。
- 負責競賽版本中即時旅程資訊、首頁、路線圖、車站與服務資訊的高擬真概念原型製作。
- 將團隊的技術方向與產品概念、prototype flow 連接起來。

競賽後，我使用 Codex 持續迭代產品，專注於整體 App 的資訊架構呈現與快速 MVP 驗證。

### 專案時程

我在參與 2026 iOS Summer Hackathon 開發 **Snoots!** 時學到快速 MVP 驗證的方法，因此選擇在競賽後繼續推進，而不是把競賽版本視為最終產品。目前 GitHub 版本是競賽成果的延伸，不取代原本的得獎作品。

| 時間 | 階段 | 推進重點 |
| --- | --- | --- |
| 2025 年 5 月底前 | UX Discovery 與提案前研究 | 完成 5 月 13–16 日問卷、乘客訪談、moodboard、問題定義與初版解法。 |
| 2025 年 5 月底 | 初選提案截止 | 將 UX 洞察整理成競賽提案與可展示的產品方向。 |
| 2025 年 7 月初 | 複賽入選 | 104 組取 10 組，將概念細化為決賽 demo。 |
| 2025 年 8 月底 | 決賽 demo | 以 Figma prototype、storyboard 與技術說明呈現競賽版本。 |
| 競賽後 | Codex 迭代 | 專注於資訊架構的呈現、任務流程與快速 MVP 驗證。 |

### 技術實作

#### 目前 prototype

- **iOS**：`Taipei Metro Go/` 中的 SwiftUI prototype。
- **Web**：`web-prototype/dist/` 中的可安裝 static prototype。
- **開發方式**：使用 Codex 協助快速調整導覽、UI 結構與 prototype flow。
- **目前導覽結構**：Home、Route Map、MetroTogether、Services、Account。

#### 競賽 AI 技術架構

AI 技術架構主要由團隊其他成員負責。我在產品面協調這些能力如何被放進使用者體驗與競賽 prototype 中。

競賽概念包含 AI 賦能的產品能力，提案中的架構使用：

- **Firebase / Firestore**：儲存行為與位置相關資料。
- **AWS Lambda**：串接資料、推薦邏輯、動態定位、路線規劃與 UI 推薦。
- **AWS Bedrock LLM**：支援站點預測與 AI 客服對話。

詳細技術說明：[AI technical overview](https://www.canva.com/design/DAGw1sl83c4/K83wtoP41e_NU1fRmC4lpg/view?utm_content=DAGw1sl83c4&utm_campaign=designshare&utm_medium=link&utm_source=viewer)

### 專案連結

- [UX Process & Insights](UX_INSIGHTS.md)：研究、設計思考、產品結構與 AI 協作迭代。
- [Product Overview](PRODUCT_OVERVIEW.md)：產品特色、操作流程與技術可行性。
- [競賽 Figma 決賽 prototype](https://www.figma.com/proto/467ZwEnIUOrVpREiduKbd5/%E8%A6%81%E4%B8%8D%E8%A6%81%E6%90%AD%E6%8D%B7%E9%81%8B?node-id=1-2&t=4C8RnnGyL7Vt3QZN-1)
- Codex MVP 驗證的目前 iOS prototype。

### 執行 iOS prototype

1. 使用 Xcode 開啟 `Taipei Metro Go.xcodeproj`。
2. 選擇 `Taipei Metro Go` scheme。
3. 選擇相容的 iPhone Simulator 或連接的實機。
4. Build and run。

目前專案以 iOS 26.5 為目標，使用 Swift 5 language mode。Location permission 支援附近車站的旅程情境。

### 執行 Web prototype

使用任意 static web server 服務 `web-prototype/dist`。該資料夾包含頁面、樣式、腳本、web manifest 與 service worker。
