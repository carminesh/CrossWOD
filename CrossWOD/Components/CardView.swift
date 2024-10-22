//
//  CardView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 22/10/24.
//


import SwiftUI

struct CardView: View {
    let imageName: String
    let title: String
    let modeDescription: String

    var body: some View {
        ZStack(alignment: .leading) {
            
        
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .cornerRadius(25)
                .clipped()
       
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("backgroundColor"))
                
                Text(modeDescription)
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundColor(Color("backgroundColor"))
            }.padding(.leading, 30)
            
        }
        .frame(height: 100)
        .padding(.horizontal, 20) 
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            imageName: "amrap_card",
            title: "Amrap",
            modeDescription: "Intense work followed by rest"
        )
        .previewLayout(.sizeThatFits)
    }
}
