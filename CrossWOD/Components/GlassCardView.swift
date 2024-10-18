//
//  GlassCardView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI


struct GlassCardView<Destination: View>: View {
    
    var mode: String
    var backgroundColor: Color
    var circleColor: Color
    var circleSize: CGFloat // max size 160
    var circleOffset: CGSize
    let destination: Destination
    
    var body: some View {
        
        NavigationLink(destination: destination) {
            ZStack {
                Circle()
                    .fill(circleColor.opacity(0.6)) // Semi-transparent color
                    .frame(width: circleSize, height: circleSize) // Dynamic size of the circle
                    .offset(circleOffset) // Dynamic offset
                    .blur(radius: 40)
                    .mask(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: 160, height: 160)
                            .inverseMask() // Cut out the area where the card is
                    )
                
                // Glass Card
                VStack {
                    Text(mode)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 160, height: 160)
                .background(
                    // Blurred background (including the circle)
                    ZStack {
                        backgroundColor.opacity(0.6) // Background color with opacity for glass effect
                        Circle()
                            .fill(circleColor.opacity(0.6))
                            .frame(width: circleSize * 1.875, height: circleSize * 1.875) // Larger than the main circle
                            .offset(circleOffset) // Reapply dynamic offset
                    }
                        .blur(radius: 90) // Apply blur for the frosted glass effect
                )
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 50) // Optional: adds shadow for depth
            }
        }
    }
    
    
}


extension View {
    func inverseMask() -> some View {
        self
            .mask(
                Rectangle().fill(style: FillStyle(eoFill: true))
            )
    }
}

