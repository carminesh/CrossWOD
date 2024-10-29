//
//  WorkoutHistoryManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import SwiftUI


extension WorkoutHistoryView {
    
    @Observable
    class ViewModel {
        var workouts: [Workout] = []
        
        var groupedWorkouts: [WorkoutGroup] {
            let calendar = Calendar.current
            let grouped = Dictionary(grouping: workouts) { workout in
                calendar.startOfDay(for: workout.date)
            }
            
            return grouped.map { group in
                // Reverse the workouts for each group (for the same day)
                WorkoutGroup(date: group.key, workouts: group.value.reversed())
            }
            .sorted(by: { $0.date > $1.date }) // Sort groups by date (most recent first)
        }
        
       
        init() {
            loadWorkouts()
        }
        
       
        
        func addWorkout(_ workout: Workout) {
            workouts.append(workout)
            saveWorkouts()
        }
        
        func removeWorkout(_ workout: Workout) {
            workouts.removeAll(where: { $0.id == workout.id })
            saveWorkouts()
        }
        
        func saveWorkouts() {
            if let encoded = try? JSONEncoder().encode(workouts) {
                UserDefaults.standard.set(encoded, forKey: "workoutHistory")
            }
        }
        
        func loadWorkouts() {
            if let savedWorkouts = UserDefaults.standard.data(forKey: "workoutHistory"),
               let decoded = try? JSONDecoder().decode([Workout].self, from: savedWorkouts) {
                workouts = decoded
            }
            
        }
        
        func getWorkouts() -> [Workout] {
            if let savedWorkouts = UserDefaults.standard.data(forKey: "workoutHistory"),
               let decoded = try? JSONDecoder().decode([Workout].self, from: savedWorkouts) {
                workouts = decoded
            }
            
            return workouts
        }

        
        
    }

}

