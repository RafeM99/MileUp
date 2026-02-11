//
//  HomeView.swift
//  MileUp
//
//  Created by Rafe Marriott on 24/01/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var progressValue: Float = 0.0
    @State private var totalDrives: Int = 32
    @State private var totalTime: Double = 2.5
    @State private var averageDistance: Double = 0.0
    @State private var averageTime: Double = 0.0
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            ZStack {
                ProgressBar(progress: $progressValue)
                    .frame(width: 250, height: 250)
                    .onAppear() {
                        progressValue = 0.32
                    }
                
                VStack {
                    Text("\(1000 * progressValue, specifier: "%.0f")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("of 1000 miles")
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                }
                .offset(y: 60)
            }
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                StatCard(
                    icon: "car",
                    title: "Total Drives:",
                    valueView: {
                        Text("\(totalDrives)")
                    }
                )
                
                StatCard(
                    icon: "timer",
                    title: "Total Time:",
                    valueView: {
                        Text("\(Int(totalTime))h \((totalTime - totalTime.rounded(.towardZero)) * 60, specifier: "%.0f")m")
                    }
                )
                
                StatCard(
                    icon: "map",
                    title: "Avg distance:",
                    valueView: {
                        Text("\(averageDistance, specifier: "%.1f") mi")
                    }
                )
                
                StatCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Avg time:",
                    valueView: {
                        Text("\(Int(averageTime))h \((averageTime - averageTime.rounded(.towardZero)) * 60, specifier: "%.0f")m")
                    }
                )
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .safeAreaPadding(.top)
        .safeAreaInset(edge: .bottom) {
            StartDriveButton()
                .padding(.horizontal)
                .padding(.vertical, 30)
        }
    }
}

#Preview {
    HomeView()
}
