//
//  PrimaryButton.swift
//  GRMS
//
//  Created by Purushothkumar on 08/07/25.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var color: Color
    var isEnabled: Bool
    var imageName: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
            }
            .frame(width: 140, height: 50)
            .background(isEnabled ? color : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.4), radius: 6, x: 0, y: 4)
        }
        .disabled(!isEnabled)
    }
}


