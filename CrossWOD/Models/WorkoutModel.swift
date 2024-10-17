//
//  WorkoutModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation

struct Workout: Identifiable, Codable {
    var id = UUID()
    let type: String
    let date: Date
    let initialCountdown: Int
    let seriesPerformed: Int
    let seriesTimes: [Int] // Track each last series time in seconds
}
    

struct WorkoutGroup: Identifiable {
    let id = UUID()
    let date: Date
    let workouts: [Workout]
}
