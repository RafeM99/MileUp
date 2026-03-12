//
//  DriveDetailView.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import SwiftUI
import MapKit

struct DriveDetailView: View {
    let session: Drive
    
    private var coordinates: [CLLocationCoordinate2D] {
        session.points
            .sorted { $0.timestamp < $1.timestamp }
            .map(\.coordinate)
    }
    
    var body: some View {
        Map {
            if coordinates.count > 1 {
                MapPolyline(coordinates: coordinates)
                    .stroke(.blue, lineWidth: 4)
            }
            if let start = coordinates.first {
                Annotation("Start", coordinate: start) {
                    Image(systemName: "flag.fill").foregroundStyle(.green)
                }
            }
            if let end = coordinates.last {
                Annotation("End", coordinate: end) {
                    Image(systemName: "checkered.flag").foregroundStyle(.red)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 16) {
                StatCard(icon: "road.lanes", title: "Distance", valueView: {
                    Text(String(format: "%.2f mi", session.totalDistanceMiles))
                })
                StatCard(icon: "timer", title: "Duration", valueView: {
                    if let duration = session.durationSeconds {
                        let h = Int(duration) / 3600
                        let m = (Int(duration) % 3600) / 60
                        Text(h > 0 ? "\(h)h \(m)m" : "\(m)m")
                    } else {
                        Text("--")
                    }
                })
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(.regularMaterial)
        }
    }
}
