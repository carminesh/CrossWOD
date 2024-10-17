//
//  WorkoutHistoryManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import SwiftUICore


class WorkoutHistoryManager: ObservableObject {
    @Published var workouts: [Workout] = []
    
    // Computed property to group workouts by date
    var groupedWorkouts: [WorkoutGroup] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: workouts) { workout in
            calendar.startOfDay(for: workout.date)
        }
        
        
        return grouped.map { WorkoutGroup(date: $0.key, workouts: $0.value) }
            .sorted(by: { $0.date < $1.date })
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
    
    
    func timeDifferenceText(workout: Workout, for index: Int) -> String {
        guard index > 0 else {
            return ""
        }
        let currentTime = workout.seriesTimes[index]
        let previousTime = workout.seriesTimes[index - 1]
        let difference = currentTime - previousTime
        
        if difference > 0 {
            return "+\(Int(difference)) s"
        } else if difference < 0 {
            return "\(Int(difference)) s"
        } else {
            return "0 s"
        }
    }
    
    func timeDifferenceColor(workout: Workout, for index: Int) -> Color {
        guard index > 0 else {
            return .white // No difference for the first element
        }
        let currentTime = workout.seriesTimes[index]
        let previousTime = workout.seriesTimes[index - 1]
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
