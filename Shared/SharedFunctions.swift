//
//  SharedFunctions.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import Foundation



func sendWorkoutInfo(workout: Workout) {
    WatchConnector.shared.sendWorkoutInfo(ofTheFollowing: workout)
}



func startWorkoutOnOtherDevice() {
    WatchConnector.shared.startWorkoutOnOtherDevice()
}


