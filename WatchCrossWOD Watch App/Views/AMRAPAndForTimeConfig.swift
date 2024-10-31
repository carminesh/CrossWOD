//
//  AMRAPAndForTimeTimer.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import SwiftUI

struct AMRAPAndForTimeTimer: View {
    
    
    
    var body: some View {
        
        Text("AMRAP")
            .font(.title2)
            .foregroundColor(.white)
            .fontWeight(.medium)
        
        Spacer()
        Spacer()
        
        VStack {
        
            HStack(alignment: .top) {
        
                
                Text("Duration: ")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.leading, 14)
                    
                
                Text("00:20")
                    .font(.body)
                    .foregroundColor(Color("amrapAccentColor"))
                    
            
            
                    
            }
            .frame(width: 175, height: 50, alignment: .leading)
            .background(Color("cardBackgroundColor"))
            .cornerRadius(13)

        
            
            NavigationLink(destination: WatchTimerView()){
                Text("START TIMER")
                    .font(.body)
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .background(Color("amrapAccentColor"))
            .frame(width: 175, height: 50)
            .cornerRadius(13)
            
            
        }
    }
}

#Preview {
    AMRAPAndForTimeTimer()
}
