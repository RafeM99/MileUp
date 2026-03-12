//
//  LocationManager.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import CoreLocation
import Combine

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var lastLocation: CLLocation?
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 5
        manager.activityType = .automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false

        // Only enable background updates if the Background Modes capability
        // for "Location updates" is present in the app's Info.plist.
        // Without this guard, the app will crash with NSInternalInconsistencyException.
        let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] ?? []
        if backgroundModes.contains("location") {
            manager.allowsBackgroundLocationUpdates = true
            manager.showsBackgroundLocationIndicator = true
        }
    }
    
    func requestPermission() {
        manager.requestAlwaysAuthorization()
    }
    
    func startTracking() {
        manager.startUpdatingLocation()
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
    }
    
    // CLLocation manager delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // filter out bad readings
        guard location.horizontalAccuracy >= 0, // negative = invalid
              location.horizontalAccuracy <= 50, // ignore >50m accuracy
              location.timestamp.timeIntervalSinceNow > -10 // not stale
        else { return }
        
        lastLocation = location
        onLocationUpdate?(location)
    }
}

