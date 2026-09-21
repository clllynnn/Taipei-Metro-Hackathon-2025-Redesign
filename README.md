# Taipei Metro Go

Taipei Metro Go is a SwiftUI portfolio prototype focused on a friendlier Taipei Metro experience. The repository also includes a static web prototype in `web-prototype/dist`.

## Portfolio release

The preserved portfolio version is marked by the annotated Git tag `portfolio-v1.0`. This tag is the stable reference for the screens and interactions represented by the prototype at the time of release.

## Included experiences

- Onboarding and app-level navigation
- Home dashboard and smart travel information
- Interactive route map and station information
- Service discovery and shortcuts
- Metro Radio community experience
- Accessibility and tourism assistance flows
- Account, preferences, notifications, security, and riding analytics
- Installable static web prototype

## 2025 捷運盃黑客松季軍

「要不要搭捷運」在 2025 捷運盃黑客松決賽獲得季軍，獎金新臺幣 2 萬元。作品以情緒設計為核心，結合 AI 動態推薦、桌面小工具，以及以音樂、聊天室與情緒陪伴組成的 `metroTogether`，打造更溫暖的候車體驗。

本屆競賽主題為「設計創新・AI 賦能」，鼓勵參賽者運用臺北捷運開放資料與 AI 技術，並以 UI/UX、功能可行性與使用者體驗為評選重點。官方新聞稿：

- [臺北市政府：2025 捷運盃黑客松決賽結果](https://www.gov.taipei/News_Content.aspx?n=F0DDAF49B89E9413&s=C6122A8A549FD692)
- [臺北捷運：競賽報名與主題說明](https://www.metro.taipei/News_Content.aspx?n=30CCEFD2A45592BF&sms=72544237BBE4C5F6&s=8094C28B588FCBC9)

## Run the iOS prototype

1. Open `Taipei Metro Go.xcodeproj` in Xcode.
2. Select the `Taipei Metro Go` scheme.
3. Choose a compatible iPhone simulator or connected device.
4. Build and run.

The project currently targets iOS 26.5 and uses Swift 5 language mode. Location permission is used to support nearby-station travel context.

## Reset the demo state

Some prototype state is stored locally with `UserDefaults`, including onboarding completion. Delete the app from the simulator or reset its app data to replay the first-launch experience.

## Web prototype

Serve `web-prototype/dist` with any static web server. The folder is self-contained and includes the page, styles, scripts, web manifest, and service worker.

## Preservation

Local release artifacts are generated in the ignored `Portfolio Backups` directory. The Git tag remains the source-of-truth snapshot; the offline Git bundle can restore the repository and its history without relying on a remote service.
