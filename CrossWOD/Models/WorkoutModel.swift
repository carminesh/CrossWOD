//
//  WorkoutModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//


import Foundation

enum WorkoutType: String, Codable {
    case amrap  // As Many Rounds As Possible
    case emom   // Every Minute On the Minute
    // Add more workout types as needed
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
    
    
}

struct WorkoutGroup: Identifiable {
    let id = UUID()
    let date: Date
    let workouts: [Workout]
}
