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
