//
//  InfoIndicator.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 24/10/24.
//

import SwiftUI

struct InfoIndicator: View {
    var text: String
    var accentColor: Color
    var number: Int
    var outOF: Int
    var timerHasFinished: Bool = true

    private var complete: Bool {
        number == outOF
    }

    private var color: Color {
        complete ? accentColor : .gray
    }

    var body: some View {
        ZStack {
            // Background with separate opacity
            RoundedRectangle(cornerRadius: 15)
                .fill(complete ? color.opacity(0.4) : Color("cardBackgroundColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: 2)
                )
                .frame(width: 140, height: 50)
                .animation(.snappy, value: complete)

            // Foreground Text
            HStack(spacing: 10) {
                Image(systemName: complete ? "inset.filled.circle.dashed" : "circle.dashed")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(text)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
        }
        .opacity(timerHasFinished ? 0 : 1)
    }
}


struct InfoIndicatorPreview: View {
    var body: some View {
        InfoIndicator(text: "Round: 3/5", accentColor: .blue, number: 3, outOF: 5, timerHasFinished: false)
    }
}


