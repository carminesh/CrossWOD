//
//  CardComponent.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 21/10/24.
//

import SwiftUI

struct CardComponent: View {
    
    
    var modeTitle: String
    var modeIcon: String
    
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("cardBackgroundColor"))
            
            ZStack {
                // Image as a sort of "background" element
                Image(modeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                
                
                // Text above the image
                VStack {
                    Text(modeTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding() // Adds space between text and image if needed
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Center content within ZStack
            .padding()
        }
        
    }
}

#Preview {
    CardComponent(modeTitle: "AMRAP", modeIcon: "amrap_icon")
}
