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
    
    // Create the @State viewModel
    @State private var viewModel: AMRAPAndForTimeTimerView.ViewModel
    
    // Initialize the viewModel with selectedWorkout data
    init(selectedWorkout: Workout) {
        self.selectedWorkout = selectedWorkout
        
        // Initialize viewModel based on selectedWorkout
        _viewModel = State(initialValue: AMRAPAndForTimeTimerView.ViewModel(
            modeTitle: selectedWorkout.type.rawValue,
            countdown: selectedWorkout.initialCountdown ?? 10 // Default to 10 if initialCountdown is nil
        ))
    }
    
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
            AMRAPAndForTimeTimerView(viewModel: viewModel)
        }
        //MARK: Update the time of the viewModel
        .onChange(of: selectedWorkout.initialCountdown) {
            viewModel = AMRAPAndForTimeTimerView.ViewModel(
                modeTitle: selectedWorkout.type.rawValue,
                countdown: selectedWorkout.initialCountdown ?? 10
            )
        }
        .onChange(of: watchConnector.startWorkout) { readyToNavigate = true }
        .onDisappear() {
            watchConnector.startWorkout = false
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
