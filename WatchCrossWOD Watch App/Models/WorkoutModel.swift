//
//  WorkoutModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//


import Foundation
import SwiftUICore

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
    
    

    // AMRAP and ForTime - specific properties
    var accentColor: String?
    var initialCountdown: Int?
    var seriesPerformed: Int?
    var seriesTimes: [Int]?
    
    // EMOM and Tabata - specific properties
    
    // EMOM
    var forTime: Int?

    
    // TABATA
    var restTime: Int?
    var numberOfSeries: Int?
    
    // TABATA and EMOM
    var workTime: Int?
    var setRestTime: Int?
    var setSeries: Int?
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

