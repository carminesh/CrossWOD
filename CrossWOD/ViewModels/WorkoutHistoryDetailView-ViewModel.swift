//
//  WorkoutHistoryDetailView-ViewModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 28/10/24.
//

import SwiftUI


extension WorkoutHistoryDetailView {
    
    @Observable
    class ViewModel {
        
        // Function to calculate time differences for AMRAP workouts
        func timeDifferenceText(workout: Workout, for index: Int) -> String {
            guard workout.type == .Amrap || workout.type == .ForTime, let seriesTimes = workout.seriesTimes, index > 0 else {
                return ""
            }
            let currentTime = seriesTimes[index]
            let previousTime = seriesTimes[index - 1]
            let difference = currentTime - previousTime
            
            if difference > 0 {
                return "+\(Int(difference)) s"
            } else if difference < 0 {
                return "\(Int(difference)) s"
            } else {
                return "0 s"
            }
        }
        
        // Function to change color based on time difference for AMRAP workouts
        func timeDifferenceColor(workout: Workout, for index: Int) -> Color {
            guard workout.type == .Amrap || workout.type == .ForTime, let seriesTimes = workout.seriesTimes, index > 0 else {
                return .white // No difference for the first element
            }
            let currentTime = seriesTimes[index]
            let previousTime = seriesTimes[index - 1]
            let difference = currentTime - previousTime
            
            if difference > 0 {
                return .red
            } else if difference < 0 {
                return .green
            } else {
                return .white
            }
        }
        
        
        
    }
    
    
}
