//
//  Taipei_Metro_GoApp.swift
//  Taipei Metro Go
//
//  Created by lynn on 2026/9/18.
//

import SwiftUI

@main
struct Taipei_Metro_GoApp: App {
    @StateObject private var travelState = TravelState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(travelState)
                .onAppear { travelState.startLocationUpdates() }
                .onDisappear { travelState.stopLocationUpdates() }
        }
    }
}
