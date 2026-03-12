//
//  HistoryView.swift
//  MileUp
//
//  Created by Rafe Marriott on 11/03/2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Drive.startDate, order: .reverse) private var drives: [Drive]
    
    var body: some View {
        NavigationStack {
            List(drives, id: \.self) { drive in
                NavigationLink(destination: {
                    DriveDetailView(session: drive)
                }, label: {
                    Text("\(drive.totalDistanceMiles)")
                })
            }
        }
    }
}

#Preview {
    HistoryView()
}
