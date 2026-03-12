//
//  ContentView.swift
//  MileUp
//
//  Created by Rafe Marriott on 22/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var locationManager = LocationManager()
    @State private var tracker: DriveTracker?

    var body: some View {
        Group {
            if let tracker {
                TabView {
                    HomeView()
                        .environment(tracker)
                        .environment(locationManager)
                        .tabItem {
                            Image(systemName: "house")
                        }
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .onAppear {
            if tracker == nil {
                tracker = DriveTracker(locationManager: locationManager, modelContext: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Drive.self, RoutePoint.self], inMemory: true)
}
