//
//  StartDriveButton.swift
//  MileUp
//
//  Created by Rafe Marriott on 28/01/2026.
//

import SwiftUI

struct StartDriveButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Start a Drive")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color(UIColor.systemBackground))
                .background(
                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(15)
                        .frame(width: 350, height: 70)
                        .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 5)
                )
        }
    }
}

#Preview {
    StartDriveButton(action: {})
}
