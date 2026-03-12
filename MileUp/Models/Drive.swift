//
//  Drive.swift
//  MileUp
//
//  Created by Rafe Marriott on 26/02/2026.
//

import Foundation
import SwiftData

@Model
class Drive {
    var id = UUID()
    var startDate: Date
    var endDate: Date?
    var totalDistanceMeters: Double = 0.0
    
    @Relationship(deleteRule: .cascade)
        var points: [RoutePoint] = []
    
    var durationSeconds: TimeInterval? {
        guard let end = endDate else { return nil }
        return end.timeIntervalSince(startDate)
    }
        
    var totalDistanceMiles: Double {
        totalDistanceMeters / 1609.344
    }
        
    init(title: String = "Drive") {
        self.startDate = Date()
    }
}
