//
//  HistoryRow.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct HistoryRow: View {
    @ObservedObject var viewModel: HistoryRowViewModel
    let workout: Workout
    
    
    
    
    var body: some View {
        
        NavigationLink(destination: WorkoutHistoryDetailView(workout: workout)) {
            VStack {
                Circle()
                    .fill(viewModel.color)
                    .frame(width: 18, height: 18)
                    .clipShape(Circle())
                
                
                Text(workout.type)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.padding()
            
            Spacer()
            
            VStack {
                Image("clock_icon")
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text(formatTimeWithDecimals(seconds: workout.initialCountdown))
                    .font(.body)
                    .foregroundColor(.white)
            }.padding()
            
            Spacer()
            
            VStack {
                Text(String(workout.seriesPerformed))
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Series")
                    .font(.body)
                    .foregroundColor(.white)
            }.padding()
            
            Spacer()
            Spacer()
            Spacer()
            
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    let dummyWorkout = Workout(
        type: "AMRAP",
        date: Date(), // Use the current date for the dummy workout
        initialCountdown: 300, // 5 minutes countdown
        seriesPerformed: 5,
        seriesTimes: [30, 40, 35, 45, 50] // Example series times in seconds
    )
    let viewModel = HistoryRowViewModel(workoutType: dummyWorkout.type)
    
    HistoryRow(viewModel: viewModel, workout: dummyWorkout)
}
