//
//  HomeView.swift
//  MileUp
//
//  Created by Rafe Marriott on 24/01/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(DriveTracker.self) private var tracker
    @Environment(LocationManager.self) private var locationManager
    @Query private var drives: [Drive]

    @State private var showDriveView = false

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private var totalDistanceMiles: Double {
        drives.reduce(0) { $0 + $1.totalDistanceMiles }
    }

    private var progressValue: Float {
        Float(min(totalDistanceMiles / 1000.0, 1.0))
    }

    private var totalTimeHours: Double {
        drives.compactMap(\.durationSeconds).reduce(0, +) / 3600
    }

    private var averageDistanceMiles: Double {
        drives.isEmpty ? 0 : totalDistanceMiles / Double(drives.count)
    }

    private var averageTimeHours: Double {
        drives.isEmpty ? 0 : totalTimeHours / Double(drives.count)
    }

    var body: some View {
        VStack {
            ZStack {
                ProgressBar(progress: .constant(progressValue))
                    .frame(width: 250, height: 250)

                VStack {
                    Text("\(totalDistanceMiles, specifier: "%.0f")")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("of 1000 miles")
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                }
                .offset(y: 60)
            }

            LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                StatCard(icon: "car", title: "Total Drives:", valueView: {
                    Text("\(drives.count)")
                })

                StatCard(icon: "timer", title: "Total Time:", valueView: {
                    let h = Int(totalTimeHours)
                    let m = Int((totalTimeHours - Double(h)) * 60)
                    Text("\(h)h \(m)m")
                })

                StatCard(icon: "map", title: "Avg distance:", valueView: {
                    Text("\(averageDistanceMiles, specifier: "%.1f") mi")
                })

                StatCard(icon: "chart.line.uptrend.xyaxis", title: "Avg time:", valueView: {
                    let h = Int(averageTimeHours)
                    let m = Int((averageTimeHours - Double(h)) * 60)
                    Text("\(h)h \(m)m")
                })
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .safeAreaPadding(.top)
        .safeAreaInset(edge: .bottom) {
            StartDriveButton {
                locationManager.requestPermission()
                tracker.startDrive()
                showDriveView = true
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
        }
        .fullScreenCover(isPresented: $showDriveView) {
            DriveView(showDriveView: $showDriveView)
                .environment(tracker)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Drive.self, RoutePoint.self, configurations: config)
    let locationManager = LocationManager()
    let tracker = DriveTracker(locationManager: locationManager, modelContext: container.mainContext)

    HomeView()
        .modelContainer(container)
        .environment(tracker)
        .environment(locationManager)
}
