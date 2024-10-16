//
//  TimeFunctions.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation


// -> 00:10, 1:30
func formatTimeWithDecimals(seconds: Int) -> String {
    let minutes = seconds / 60
    let  remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}


// -> 10 (SECONDS), 20 (SECONDS) and so on
func formatTimeToNumberOnly(seconds: Int) -> String {
    if seconds < 60 {
        return String(seconds)
    } else if seconds == 60 {
        return String(1)
    } else if seconds % 60 == 0 {
        return String(seconds / 60)
    } else {
        return "\(String(seconds / 60)):\(String(seconds % 60))"
    }
}

// -> 00:30 Seconds, 1:30 Minutes
func formatTime(seconds: Int) -> String {
    if seconds < 60 {
        return "\(seconds) seconds"
    } else if seconds == 60 {
        return "1 minute"
    } else if seconds % 60 == 0 {
        return "\(seconds / 60) minutes"
    } else {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d minutes", minutes, remainingSeconds)
    }
}

// ->  Seconds, Minute and Minutes
func formatTimeToOnlyText(seconds: Int) -> String {
    if seconds < 60 {
        return "Seconds"
    } else if seconds == 60 {
        return "Minute"
    } else {
        return "Minutes"
    }
}

// Function used in the CustomTimePicker in order to create the different time intervals
func generateTimeIntervals() -> [Int] {
    var intervals: [Int] = []

    // from 20 to 60 seconds (increments by 5 seconds)
    intervals.append(contentsOf: stride(from: 10, through: 60, by: 5))

    // from  1:00 to 3:00 minutes (increments by 15 seconds)
    intervals.append(contentsOf: stride(from: 75, through: 180, by: 15))

    // from 3:30 to 5:00 minutes (increments by 30 seconds)
    intervals.append(contentsOf: stride(from: 210, through: 300, by: 30))

    // from 6 to 90 minutes (increment of 1 minutes)
    intervals.append(contentsOf: stride(from: 360, through: 5400, by: 60))

    return intervals
}
