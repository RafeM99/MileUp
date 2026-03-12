//
//  StatCard.swift
//  MileUp
//
//  Created by Rafe Marriott on 25/01/2026.
//

import SwiftUI

struct StatCard<ValueView: View>: View {
    let icon: String
    let title: String
    @ViewBuilder var valueView: ValueView
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
            }

            valueView
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // content stretch and align left
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
        )
        .frame(height: 100) // consistent height
    }
}

//#Preview {
//    StatCard()
//}
