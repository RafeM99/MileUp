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
    @State private var driveAverage: Double = 0.0
    
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
            
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "car.side")
                        
                        Text("Total Drives:")
                    }
                    
                    Text("\(totalDrives)")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        .frame(width: 160, height: 80)
                )
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "clock")
                        
                        Text("Total Time:")
                    }
                    
                    Text("\(Int(totalTime))h \((totalTime - totalTime.rounded(.towardZero)) * 60, specifier: "%.0f")m")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        .frame(width: 160, height: 80)
                )
                .padding(.horizontal)
            }
            
            HStack{
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        
                        Text("Avg per drive:")
                    }
                    
                    Text("\(driveAverage, specifier: "%.1f") mi")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                )
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}
