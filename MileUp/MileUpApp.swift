//
//  MileUpApp.swift
//  MileUp
//
//  Created by Rafe Marriott on 22/01/2026.
//

import SwiftUI
import SwiftData

@main
struct MileUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Drive.self, RoutePoint.self])
    }
}
