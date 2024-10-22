//
//  WorkoutHistoryDetailView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryDetailView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    @ObservedObject var viewModel: HistoryRowViewModel
    
    var workout: Workout
   
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Set background color for the entire view
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Workout type section
                        VStack(alignment: .leading) {
                            Text("Workout type:")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.leading, 28)
                            
                            HStack {
                                viewModel.shape()
                                
                                Text(workout.type.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                
                            }.frame(width: geometry.size.width / 3)
                                .padding()
                                .background(Color("cardBackgroundColor"))
                                .cornerRadius(15)
                                .padding(.leading, 26)
                        }.padding(.top, 30)
                        
                        // Workout date and duration
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Workout date:")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 50)
                                
                                
                                VStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                    
                                    Text(dateFormatter.string(from: workout.date))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                .frame(width: geometry.size.width / 2.5, height: geometry.size.width / 2.5)
                                .background(Color("cardBackgroundColor"))
                                .cornerRadius(15)
                                
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Workout duration:")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 24)
                                
                                
                                VStack {
                                    Image(systemName: "fitness.timer")
                                        .font(.system(size: 57))
                                        .foregroundColor(.white)
                                    
                                    Text(
                                        formatTimeWithDecimals(seconds: workout.initialCountdown ?? 0)
                                    )
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                }
                                .frame(width: geometry.size.width / 2.5, height: geometry.size.width / 2.5)
                                .background(Color("cardBackgroundColor"))
                                .cornerRadius(15)
                                .padding(.horizontal)
                            }
                            
                            Spacer()
                        }.padding(.leading, 16)
                        
                        // Conditional views for AMRAP or EMOM workout types
                        if workout.type == .Amrap {
                            if let seriesTimes = workout.seriesTimes, !seriesTimes.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Round timing:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.leading, 22)
                                    
                                    ForEach(Array(seriesTimes.enumerated()), id: \.offset) { index, time in
                                        HStack {
                                            Text("Series \(index + 1)")
                                                .font(.body)
                                                .foregroundColor(.white)
                                                .padding(.leading, 22)
                                            
                                            Spacer()
                                            
                                            Text(formatTimeWithDecimals(seconds: time))
                                                .font(.body)
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            Text(workoutHistoryManager.timeDifferenceText(workout: workout, for: index))
                                                .font(.body)
                                                .foregroundColor(workoutHistoryManager.timeDifferenceColor(workout: workout, for: index))
                                                .frame(width: 70)
                                        }
                                        .padding()
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 22)
                                    }
                                }
                            } else {
                                Text("For this workout, series were not performed.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 22)
                            }
                        } else if workout.type == .Emom {
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Text("Every:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 100)
                                    
                                    Text("\(formatTimeWithDecimals(seconds: workout.roundTimes ?? 0)) \(formatTimeToOnlyText(seconds: workout.roundTimes ?? 0))")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("For duration of:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 30)
                                    
                                    Text("\(formatTimeWithDecimals(seconds: workout.numberOfRounds ?? 0)) \(formatTimeToOnlyText(seconds: workout.numberOfRounds ?? 0))")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        
    }
}
#Preview {
    let dummyWorkout = Workout(
        type: .Emom,
        date: Date(), // Use the current date for the dummy workout
        initialCountdown: 300, // 5 minutes countdown
        seriesPerformed: 5,
        seriesTimes: [30, 40, 35, 45, 50] // Example series times in seconds
    )
    
    let viewModel = HistoryRowViewModel(workoutType: dummyWorkout.type.rawValue)
    
    WorkoutHistoryDetailView(viewModel: viewModel, workout: dummyWorkout)
}
