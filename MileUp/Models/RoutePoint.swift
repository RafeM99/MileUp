//
//  RoutePoint.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class RoutePoint {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var speed: Double        // m/s, -1 if invalid
    var altitude: Double
    var horizontalAccuracy: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
        self.speed = location.speed
        self.altitude = location.altitude
        self.horizontalAccuracy = location.horizontalAccuracy
    }
}
