//
//  HistoryRow.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct HistoryRow: View {
    @ObservedObject var viewModel: HistoryRowViewModel
    let workout: Workout
    
    
    
    
    var body: some View {
        
        NavigationLink(destination: WorkoutHistoryDetailView(viewModel: viewModel, workout: workout)) {
            VStack {
                
                viewModel.shape()
                
                
                Text(workout.type.rawValue)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
            }
            .frame(width: 70)
            .padding()
            
            Spacer()
            
            if workout.type == .Amrap || workout.type == .ForTime {
                
                VStack {
                    Image("clock_icon")
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text(formatTimeWithDecimals(seconds: workout.initialCountdown ?? 0))
                        .font(.body)
                        .foregroundColor(.white)
                }
                .frame(width: 50)
                .padding()
                
                Spacer()
                
                VStack {
                    Text(String(workout.seriesPerformed ?? 0))
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Series")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .frame(width: 50)
                .padding()
                
            } else if workout.type == .Emom || workout.type == .Tabata {
                
                VStack {
                    
                    
                    if let numberOfRounds = workout.numberOfRounds {
                        let roundsText = numberOfRounds == 1 ? "Round" : "Rounds"
                        let formattedTime = formatTimeToNumberOnly(seconds: numberOfRounds)
                        
                        Text("\(formattedTime)")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(roundsText)")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                .padding()

                
                Spacer()
                
                VStack {
                    
                    if let seriesPerformed = workout.performedSets {
                        let setText = seriesPerformed == 1 ? "Set" : "Sets"
                        let numberOfPerformedSeries = formatTimeToNumberOnly(seconds:  workout.performedSets ?? 0)
                        
                        Text("\(numberOfPerformedSeries)")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(setText)")
                            .font(.body)
                            .foregroundColor(.white)
                        
                    }
                    
                }.padding()
                
                
            }
            
            Spacer()
            Spacer()
            Spacer()
            
        }
        .background(Color("cardBackgroundColor"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    
}

#Preview {
    let dummyWorkout = Workout(
        type: .Tabata,
        date: Date(), // Use the current date for the dummy workout
        initialCountdown: 300, // 5 minutes countdown
        seriesPerformed: 5,
        seriesTimes: [30, 40, 35, 45, 50] // Example series times in seconds
    )
    let viewModel = HistoryRowViewModel(workoutType: dummyWorkout.type.rawValue)
    
    HistoryRow(viewModel: viewModel, workout: dummyWorkout)
}
