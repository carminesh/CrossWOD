//
//  WorkoutHistoryManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import SwiftUI

class WorkoutHistoryManager: ObservableObject {
    @Published var workouts: [Workout] = []
    
    // Computed property to group workouts by date
    var groupedWorkouts: [WorkoutGroup] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: workouts) { workout in
            calendar.startOfDay(for: workout.date)
        }
        
        return grouped.map { WorkoutGroup(date: $0.key, workouts: $0.value) }
            .sorted(by: { $0.date > $1.date })
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

    // Function to calculate time differences for AMRAP workouts
    func timeDifferenceText(workout: Workout, for index: Int) -> String {
        guard workout.type == .Amrap, let seriesTimes = workout.seriesTimes, index > 0 else {
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
        guard workout.type == .Amrap, let seriesTimes = workout.seriesTimes, index > 0 else {
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
