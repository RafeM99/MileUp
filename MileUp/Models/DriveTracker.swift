//
//  DriveTracker.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import CoreLocation
import SwiftData

@Observable
class DriveTracker {
    private(set) var isTracking = false
    private(set) var currentSession: Drive?
    private(set) var liveCoordinates: [CLLocationCoordinate2D] = []
    private(set) var liveDistance: Double = 0.0  // meters
    
    private var lastLocation: CLLocation?
    private let locationManager: LocationManager
    private var modelContext: ModelContext
    
    init(locationManager: LocationManager, modelContext: ModelContext) {
        self.locationManager = locationManager
        self.modelContext = modelContext
    }
    
    func startDrive(title: String = "Drive") {
        let session = Drive()
        modelContext.insert(session)
        currentSession = session
        liveCoordinates = []
        liveDistance = 0.0
        lastLocation = nil
        isTracking = true
        
        locationManager.onLocationUpdate = { [weak self] location in
            self?.handleLocationUpdate(location)
        }
        locationManager.startTracking()
    }
    
    func stopDrive() {
        locationManager.stopTracking()
        locationManager.onLocationUpdate = nil
        
        currentSession?.endDate = Date()
        currentSession?.totalDistanceMeters = liveDistance
        
        try? modelContext.save()
        
        isTracking = false
        currentSession = nil
        lastLocation = nil
    }
    
    private func handleLocationUpdate(_ location: CLLocation) {
        guard let session = currentSession else { return }
        
        // append point to SwiftData
        let point = RoutePoint(from: location)
        session.points.append(point)
        
        // update polyline
        liveCoordinates.append(location.coordinate)
        
        // accumulate distance
        if let last = lastLocation {
            let delta = location.distance(from: last)
            // ignore if implying >200mph
            let elapsed = location.timestamp.timeIntervalSince(last.timestamp)
            let impliedSpeed = elapsed > 0 ? delta / elapsed : 0
            if impliedSpeed < 89 {  // ~200mph in m/s
                liveDistance += delta
            }
        }
        lastLocation = location
    }
}
