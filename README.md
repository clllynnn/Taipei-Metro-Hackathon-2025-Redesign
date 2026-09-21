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
