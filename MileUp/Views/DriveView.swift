//
//  DriveView.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import SwiftUI
import MapKit
import SwiftData

struct DriveView: View {
    @Binding var showDriveView: Bool
    @Environment(DriveTracker.self) var tracker
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    @State private var startTime: Date = Date.now
    @State private var timeElapsed: String = "00:00:00"
    @State private var timer: Timer?

    private let timeFormatter: DateComponentsFormatter

    init(showDriveView: Binding<Bool>) {
        self._showDriveView = showDriveView
        timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.unitsStyle = .positional
        timeFormatter.zeroFormattingBehavior = [.pad]
    }

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $position) {
                // Live route polyline
                if tracker.liveCoordinates.count > 1 {
                    MapPolyline(coordinates: tracker.liveCoordinates)
                        .stroke(.blue, lineWidth: 4)
                }

                // Start pin
                if let first = tracker.liveCoordinates.first {
                    Annotation("Start", coordinate: first) {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(.green)
                    }
                }

                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .overlay(alignment: .bottom) {
                statsOverlay
            }

            // End Drive button
            Button {
                timer?.invalidate()
                tracker.stopDrive()
                showDriveView = false
            } label: {
                Text("End Drive")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red, in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    .padding(.vertical, 20)
            }
        }
        .onAppear {
            // Timer starts automatically when the drive view appears
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let interval = Date().timeIntervalSince(startTime)
                timeElapsed = timeFormatter.string(from: interval) ?? "00:00:00"
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }

    private var statsOverlay: some View {
        HStack(spacing: 16) {
            StatCard(icon: "road.lanes", title: "Distance", valueView: {
                Text(String(format: "%.2f mi", tracker.liveDistance / 1609.344))
            })
            StatCard(icon: "timer", title: "Time", valueView: {
                Text(timeElapsed)
                    .monospacedDigit()
            })
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Drive.self, RoutePoint.self, configurations: config)
    let locationManager = LocationManager()
    let tracker = DriveTracker(locationManager: locationManager, modelContext: container.mainContext)

    DriveView(showDriveView: .constant(true))
        .environment(tracker)
}
