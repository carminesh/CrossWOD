//
//  WorkoutModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//


import Foundation

enum WorkoutType: String, Codable {
    case Amrap
    case Emom
    case ForTime
    case Tabata
}

struct Workout: Identifiable, Codable {
    var id = UUID()
    let type: WorkoutType
    let date: Date
    

    // AMRAP-specific properties
    var initialCountdown: Int?
    var seriesPerformed: Int?
    var seriesTimes: [Int]?
    
    // EMOM-specific properties
    var performedSets: Int?     
    var numberOfRounds: Int?
    var roundTimes: Int?
    var totalWorkoutTime: Int?
    
}

struct WorkoutGroup: Identifiable {
    let id = UUID()
    let date: Date
    let workouts: [Workout]
}
