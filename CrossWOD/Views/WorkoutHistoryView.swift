//
//  WorkoutHistoryView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    
    var body: some View {
        List(workoutHistoryManager.workouts) { workout in
            VStack(alignment: .leading) {
                Text("Workout Type: \(workout.type)")
                Text("Date: \(workout.date.formatted(.dateTime))")
                Text("Initial Countdown: \(formatTime(seconds: workout.initialCountdown))")
                Text("Series Performed: \(workout.seriesPerformed)")
                ForEach(workout.seriesTimes.indices, id: \.self) { index in
                    Text("Series \(index + 1): \(formatTime(seconds: workout.seriesTimes[index]))")
                }
            }
            .padding()
        }
        .navigationTitle("Workout History")
        .onAppear {
            workoutHistoryManager.loadWorkouts()
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    WorkoutHistoryView()
}
