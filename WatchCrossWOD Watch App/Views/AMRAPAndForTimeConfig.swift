//
//  AMRAPAndForTimeTimer.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import SwiftUI

struct AMRAPAndForTimeConfig: View {
    
    var selectedWorkout: Workout
    
    var body: some View {
        
        Text(selectedWorkout.type == .Amrap ? "AMRAP" : "FOR TIME")
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
                    
                
                Text(formatTimeWithDecimals(seconds: selectedWorkout.initialCountdown ?? 0))
                    .font(.body)
                    .foregroundColor(Color("amrapAccentColor"))
                    
            
            
                    
            }
            .frame(width: 175, height: 50, alignment: .leading)
            .background(Color("cardBackgroundColor"))
            .cornerRadius(13)
            
            if let initialCountdown = selectedWorkout.initialCountdown {
                NavigationLink(destination: AMRAPAndForTimeTimer(viewModel: AMRAPAndForTimeTimer.ViewModel(modeTitle: selectedWorkout.type.rawValue, countdown: initialCountdown ))) {
                    Text("START TIMER")
                        .font(.body)
                        .fontWeight(.medium)
                        .frame(width: 175, height: 50)
                        .foregroundColor(.white)
                        .background(Color("amrapAccentColor"))
                        .cornerRadius(13)
                }
            
            }
        
            
            
            
            
        }
    }
}

#Preview {
    
    let workout = Workout(
            type: .Amrap,
            date: Date(),
            accentColor: "amrapAccentColor",
            initialCountdown: 1200,
            seriesPerformed: 5,
            seriesTimes: [200, 400, 600]
        )
    
    
    AMRAPAndForTimeConfig(selectedWorkout: workout)
}
