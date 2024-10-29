//
//  HistoryRow.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct HistoryRow: View {

    let workout: Workout
    
    
    
    
    var body: some View {
        
        
        HStack(spacing: 12) {
            
            NavigationLink(destination: WorkoutHistoryDetailView(workout: workout)) {
                
                VStack {
                    
                    workoutShape(for: workout.type.rawValue)
                    
                    
                    Text(workout.type.rawValue)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                .frame(width: 90)
                
                
                
                
                if workout.type == .Amrap || workout.type == .ForTime {
                    
                    VStack {
                        Image("clock_icon")
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text(formatTimeWithDecimals(seconds: workout.initialCountdown ?? 0))
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .frame(width: 90)
                    
                    
                    
                    
                    VStack {
                        Text(String(workout.seriesPerformed ?? 0))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Series")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .frame(width: 90)
                    
                    
                    
                } else if workout.type == .Emom || workout.type == .Tabata {
                    
                    VStack {
                        
                        
                        if let numberOfRounds = workout.numberOfRounds {
                            let roundsText = numberOfRounds == 1 ? "Round" : "Rounds"
                            let formattedTime = formatTimeToNumberOnly(seconds: numberOfRounds) ?? "0"
                            
                            Text("\(formattedTime)")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("\(roundsText)")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 90)
                    
                    
                    
                    
                    
                    
                    VStack {
                        if let seriesPerformed = workout.performedSets {
                            let setText = seriesPerformed == 1 ? "Set" : "Sets"
                            let numberOfPerformedSeries = formatTimeToNumberOnly(seconds: seriesPerformed) ?? "0"
                            
                            Text(numberOfPerformedSeries)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(setText)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 90)
                    
                    
                    
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal)
                        
        }
        .padding(.vertical, 10)
        .background(Color("cardBackgroundColor"))
        .cornerRadius(12)
        
    }
    
}

#Preview {
    let dummyWorkout = Workout(
        type: .Tabata,
        date: Date(),
        performedSets: 2,
        numberOfRounds: 2,
        roundTimes: 10,
        totalWorkoutTime: 40
    )
    
    let dummyWorkout2 = Workout(
        type: .Amrap,
        date: Date(),
        initialCountdown: 300,
        seriesPerformed: 5,
        seriesTimes: [30, 40, 35, 45, 50]
    )
    
    

    HistoryRow(workout: dummyWorkout)
    HistoryRow(workout: dummyWorkout2)
}
