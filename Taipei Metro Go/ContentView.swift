import SwiftUI

private enum MainTab: Hashable {
    case home
    case routeMap
    case serviceMenu
    case metroRadio
    case account
}

struct ContentView: View {
    @EnvironmentObject private var travelState: TravelState
    @State private var selectedTab: MainTab = .home
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView(
                    travelState: travelState,
                    onOpenRouteMap: openRouteMap,
                    onSelectService: openServiceShortcut
                )
                    .tabItem { Label("首頁", systemImage: "house.fill") }
                    .tag(MainTab.home)

                RouteMapView()
                    .tabItem { Label("路線圖", systemImage: "point.topleft.down.curvedto.point.bottomright.up") }
                    .tag(MainTab.routeMap)

                MetroRadioView(language: travelState.currentLanguage)
                    .tabItem { Label(MetroRadioCopy.productName(for: travelState.currentLanguage), systemImage: "waveform.path") }
                    .tag(MainTab.metroRadio)

                ServiceMenuView()
                    .tabItem { Label("功能服務", systemImage: "square.grid.2x2.fill") }
                    .tag(MainTab.serviceMenu)

                AccountView()
                    .tabItem { Label("會員中心", systemImage: "person.crop.circle.fill") }
                    .tag(MainTab.account)
            }
            .tint(Color.primaryAction)
        }
        .sheet(isPresented: Binding(
            get: { !hasSeenOnboarding },
            set: { _ in }
        )) {
            OnboardingModalView()
                .presentationDetents([.large])
                .interactiveDismissDisabled()
        }
    }

    private func openRouteMap() {
        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .routeMap }
    }

    private func openAccount() {
        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .account }
    }

    private func openServiceShortcut(_ shortcut: MetroServiceShortcut) {
        switch shortcut {
        case .metroMall:
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .serviceMenu }
        case .metroRadio:
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .metroRadio }
        case .points:
            openAccount()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TravelState.mock)
}
