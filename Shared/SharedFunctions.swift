//
//  SharedFunctions.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import Foundation



func sendWorkoutInfo(workout: Workout) {
    WatchConnector.shared.send(theFollowing: workout)
}
