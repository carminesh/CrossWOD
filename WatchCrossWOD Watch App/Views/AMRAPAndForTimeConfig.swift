//
//  AMRAPAndForTimeTimer.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import SwiftUI

struct AMRAPAndForTimeConfig: View {
    var selectedWorkout: Workout
    @ObservedObject var watchConnector = WatchConnector.shared
    @State private var readyToNavigate = false
    
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
                    .foregroundColor(selectedWorkout.type == .Amrap ? Color("amrapAccentColor") : Color("forTimeAccentColor"))
            }
            .frame(width: 175, height: 50, alignment: .leading)
            .background(Color("cardBackgroundColor"))
            .cornerRadius(13)
            
            Button {
                readyToNavigate.toggle()
            } label: {
                Text("START TIMER")
            }
            .font(.body)
            .fontWeight(.medium)
            .frame(width: 175, height: 50)
            .foregroundColor(.white)
            .background(selectedWorkout.type == .Amrap ? Color("amrapAccentColor") : Color("forTimeAccentColor") )
            .cornerRadius(13)
            
        }
        .navigationDestination(isPresented: $readyToNavigate) {
            if let initialCountdown = selectedWorkout.initialCountdown {
                AMRAPAndForTimeTimer(viewModel: AMRAPAndForTimeTimer.ViewModel(modeTitle: selectedWorkout.type.rawValue, countdown: initialCountdown))
            }
        }
        .onChange(of: watchConnector.startWorkout) { readyToNavigate = true }
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
