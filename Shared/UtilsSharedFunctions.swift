//
//  UtilsSharedFunctions.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import Foundation

// MARK: - workoutToDictionary function
func workoutToDictionary(workout: Workout) -> [String: Any?] {
    
    var dict: [String: Any?] = [
        "id": workout.id.uuidString,
        "type": workout.type.rawValue,
        "date": ISO8601DateFormatter().string(from: workout.date) // Serializing date to string
    ]
    
    // Add properties based on the workout type
    switch workout.type {
    case .Amrap, .ForTime:
        dict["accentColor"] = workout.accentColor
        dict["initialCountdown"] = workout.initialCountdown
        dict["seriesPerformed"] = workout.seriesPerformed
        dict["seriesTimes"] = workout.seriesTimes
        
    case .Emom:
        dict["forTime"] = workout.forTime
        dict["workTime"] = workout.workTime
        dict["setRestTime"] = workout.setRestTime
        dict["setSeries"] = workout.setSeries
        dict["performedSets"] = workout.performedSets
        dict["numberOfRounds"] = workout.numberOfRounds
        dict["roundTimes"] = workout.roundTimes
        dict["totalWorkoutTime"] = workout.totalWorkoutTime
        
    case .Tabata:
        dict["restTime"] = workout.restTime
        dict["numberOfSeries"] = workout.numberOfSeries
        dict["workTime"] = workout.workTime
        dict["setRestTime"] = workout.setRestTime
        dict["setSeries"] = workout.setSeries
        dict["performedSets"] = workout.performedSets
        dict["numberOfRounds"] = workout.numberOfRounds
        dict["roundTimes"] = workout.roundTimes
        dict["totalWorkoutTime"] = workout.totalWorkoutTime
    }
    
    return dict
}

// MARK: - dictionaryToWorkout function
func dictionaryToWorkout(dictionary: [String: Any]) throws -> Workout {
    // Ensure the dictionary contains the required fields
    guard let typeString = dictionary["type"] as? String,
          let type = WorkoutType(rawValue: typeString),
          let dateString = dictionary["date"] as? String,
          let date = ISO8601DateFormatter().date(from: dateString) else {
        throw NSError(domain: "Invalid dictionary format", code: 1, userInfo: nil)
    }

    // Initialize a new Workout instance based on the type
    switch type {
    case .Amrap, .ForTime:
        return Workout(
            id: UUID(uuidString: dictionary["id"] as? String ?? UUID().uuidString)!,
            type: type,
            date: date,
            accentColor: dictionary["accentColor"] as? String,
            initialCountdown: dictionary["initialCountdown"] as? Int,
            seriesPerformed: dictionary["seriesPerformed"] as? Int,
            seriesTimes: dictionary["seriesTimes"] as? [Int],
            forTime: dictionary["forTime"] as? Int,
            restTime: nil,
            numberOfSeries: nil,
            workTime: nil,
            setRestTime: nil,
            setSeries: nil,
            performedSets: nil,
            numberOfRounds: nil,
            roundTimes: nil,
            totalWorkoutTime: nil
        )

    case .Emom:
        return Workout(
            id: UUID(uuidString: dictionary["id"] as? String ?? UUID().uuidString)!,
            type: type,
            date: date,
            accentColor: dictionary["accentColor"] as? String,
            initialCountdown: nil,
            seriesPerformed: nil,
            seriesTimes: nil,
            forTime: dictionary["forTime"] as? Int,
            restTime: nil,
            numberOfSeries: dictionary["numberOfSeries"] as? Int,
            workTime: dictionary["workTime"] as? Int,
            setRestTime: dictionary["setRestTime"] as? Int,
            setSeries: dictionary["setSeries"] as? Int,
            performedSets: dictionary["performedSets"] as? Int,
            numberOfRounds: nil,
            roundTimes: nil,
            totalWorkoutTime: dictionary["totalWorkoutTime"] as? Int
        )

    case .Tabata:
        return Workout(
            id: UUID(uuidString: dictionary["id"] as? String ?? UUID().uuidString)!,
            type: type,
            date: date,
            accentColor: dictionary["accentColor"] as? String,
            initialCountdown: nil,
            seriesPerformed: nil,
            seriesTimes: nil,
            forTime: nil,
            restTime: dictionary["restTime"] as? Int,
            numberOfSeries: dictionary["numberOfSeries"] as? Int,
            workTime: dictionary["workTime"] as? Int,
            setRestTime: dictionary["setRestTime"] as? Int,
            setSeries: dictionary["setSeries"] as? Int,
            performedSets: dictionary["performedSets"] as? Int,
            numberOfRounds: dictionary["numberOfRounds"] as? Int,
            roundTimes: dictionary["roundTimes"] as? Int,
            totalWorkoutTime: dictionary["totalWorkoutTime"] as? Int
        )
    }
}

