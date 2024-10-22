//
//  SettingsRow.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct SettingsRow<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination

    var body: some View {
        ZStack {
            
            Color("cardBackgroundColor")
                .edgesIgnoringSafeArea(.all)
                
            
            NavigationLink(destination: destination) {
                HStack {
                    Image(systemName: icon)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    Text(title)
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                }
                
            }
            .padding(.horizontal)
           
            
        }
        .listRowInsets(EdgeInsets())

    }
}
