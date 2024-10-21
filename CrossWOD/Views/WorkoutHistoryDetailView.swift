//
//  WorkoutHistoryDetailView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryDetailView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    var workout: Workout
    
    var body: some View {
        
        VStack {
            Text("Workout type: ")
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                .padding(.leading, 26)
            
            
            HStack {
                HStack {
                    
                    
                    Text(workout.type.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150)
                        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                        .cornerRadius(10)
                        .padding()
                    
                    
                    
                }
                .frame(width: 150)
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }.padding(.horizontal)

            
        }
        
        HStack {
            
            Spacer()
            
            VStack {
                Text("Workout date: ")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.leading, 22)
                
                
                VStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    
                    Text(dateFormatter.string(from: workout.date))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    
                }
                .frame(width: 150, height: 150)
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Spacer()
            
            
            VStack {
                
                Text("Workout duration: ")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.leading, 22)
                
                VStack {
                    Image(systemName: "fitness.timer")
                        .font(.system(size: 57))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    
                    Text(
                        formatTimeWithDecimals(
                            seconds: workout.initialCountdown ?? 0
                        )
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    
                }
                .frame(width: 150, height: 150)
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(10)
                .padding(.horizontal)
                
            }
            
            
        }.padding(.bottom, 30)
        
        if workout.type == .amrap {
            if let seriesTimes = workout.seriesTimes, !seriesTimes.isEmpty {
                
                VStack(spacing: 0) {
                    
                    Text("Round timing:")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black)
                        .padding(.leading, 22)
                        .padding(.bottom, 0)
                    
                    List {
                        ForEach(Array(seriesTimes.enumerated()), id: \.offset) { index, time in
                            HStack {
                                Text("Series \(index + 1)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Spacer()
                                
                                Text(formatTimeWithDecimals(seconds: time))
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Spacer()
                                
                                Text(workoutHistoryManager.timeDifferenceText(workout: workout, for: index))
                                    .font(.body)
                                    .foregroundColor(workoutHistoryManager.timeDifferenceColor(workout: workout, for: index))
                                    .frame(width: 70)
                                    .padding()
                            }
                            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                            .cornerRadius(10)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
            } else {
                VStack(spacing: 0) {
                    
                    Text("Round timing:")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black)
                        .padding(.leading, 22)
                        .padding(.bottom, 0)
                    
                    Text("For this workout, series were not performed.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.black)
                        .padding(.leading, 22)
                        .padding(.top, 18)
                }
            }
        } else if workout.type == .emom {
            
            HStack {
                
                Spacer()
                
                VStack {
                    Text("Every: ")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                        .padding(.leading, 22)
                    
                    
                    VStack {
                        
                        
                        Text("\(formatTimeWithDecimals(seconds: workout.roundTimes ?? 0)) \(formatTimeToOnlyText(seconds: workout.roundTimes ?? 0))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        
                    }
                    .frame(width: 150)
                    .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                
                VStack {
                    
                    Text("For duration of: ")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                        .padding(.leading, 22)
                    
                    VStack {
                        
                        
                        Text("\(formatTimeWithDecimals(seconds: workout.numberOfRounds ?? 0)) \(formatTimeToOnlyText(seconds: workout.numberOfRounds ?? 0))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        
                    }
                    .frame(width: 150)
                    .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                }
                
                
            }
            .padding(.bottom, 40)
                        
            
        }
        
        
        Spacer()
        
    }
    
}

#Preview {
    let dummyWorkout = Workout(
        type: .amrap,
        date: Date(), // Use the current date for the dummy workout
        initialCountdown: 300, // 5 minutes countdown
        seriesPerformed: 5,
        seriesTimes: [30, 40, 35, 45, 50] // Example series times in seconds
    )
    
    WorkoutHistoryDetailView(workout: dummyWorkout)
}
