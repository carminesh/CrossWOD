//
//  WorkoutHistoryDetailView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryDetailView: View {
    
    var viewModel: ViewModel
    var workout: Workout
    
    // State variables for alert
    @State private var showRepeatAlert = false
    @State private var navigateToWorkout = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // MARK: Workout type section
                        VStack(alignment: .leading) {
                            
                            Text("Workout type:")
                                .font(.body)
                                .foregroundColor(.white)
                            
                            
                            HStack {
                                workoutShape(for: workout.type.rawValue)
                                
                                Text(workout.type.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                
                            }
                            .frame(width: geometry.size.width / 3)
                            .padding()
                            .background(Color("cardBackgroundColor"))
                            .cornerRadius(15)
                            
                        }.padding(.horizontal)
                        
                        // MARK: Workout date and duration
                        HStack() {
                            
                            
                            VStack(alignment: .leading) {
                                Text("Workout date:")
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                
                                
                                VStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                    
                                    Text(dateFormatter.string(from: workout.date))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(4)
                                }
                                .frame(width: geometry.size.width / 2.35, height: geometry.size.width / 2.5)
                                .background(Color("cardBackgroundColor"))
                                .cornerRadius(15)
                                
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                
                                
                                Text("Workout duration:")
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                
                                
                                
                                VStack {
                                    Image(systemName: "fitness.timer")
                                        .font(.system(size: 57))
                                        .foregroundColor(.white)
                                    
                                    if workout.type == .Amrap || workout.type == .ForTime {
                                        Text(
                                            formatTimeWithDecimals(seconds: workout.initialCountdown ?? 0)
                                        )
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(4)
                                    } else {
                                        Text(
                                            formatTimeWithDecimals(seconds: workout.totalWorkoutTime ?? 0)
                                        )
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(4)
                                    }
                                    
                                    
                                }
                                .frame(width: geometry.size.width / 2.35, height: geometry.size.width / 2.5)
                                .background(Color("cardBackgroundColor"))
                                .cornerRadius(15)
                                
                            }
                            
                        }.padding()
                        
                        // MARK: AMRAP and FORTIME list section
                        if workout.type == .Amrap || workout.type == .ForTime {
                            if let seriesTimes = workout.seriesTimes, !seriesTimes.isEmpty {
                                
                                
                                VStack(alignment: .leading) {
                                    Text("Round timing:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
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
                                            
                                            Text(viewModel.timeDifferenceText(workout: workout, for: index))
                                                .font(.body)
                                                .foregroundColor(viewModel.timeDifferenceColor(workout: workout, for: index))
                                                .frame(width: 70)
                                        }
                                        .padding()
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(15)
                                        
                                    }
                                }.padding()
                            } else {
                                
                                
                                VStack(alignment: .leading) {
                                    Text("For this workout, series were not performed.")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    
                                }.padding()
                            }
                            // MARK: EMOM section
                        } else if workout.type == .Emom  {
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text("Every:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
                                    
                                    Text("\(formatTimeWithDecimals(seconds: workout.roundTimes ?? 0)) \(formatTimeToOnlyText(seconds: workout.roundTimes ?? 0))")
                                        .frame(width: geometry.size.width / 3)
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(15)
                                    
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("For duration of:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
                                    Text("\(formatTimeWithDecimals(seconds: workout.totalWorkoutTime ?? 0)) \(formatTimeToOnlyText(seconds: workout.totalWorkoutTime ?? 0))")
                                        .frame(width: geometry.size.width / 3)
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(15)
                                    
                                }
                                
                                
                            }
                            .padding()
                        } else if workout.type == .Tabata {
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text("Work time:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
                                    Text("\(formatTimeWithDecimals(seconds: workout.workTime ?? 0)) \(formatTimeToOnlyText(seconds: workout.workTime ?? 0))")
                                        .frame(width: geometry.size.width / 3)
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .background(Color("cardBackgroundColor"))
                                        .cornerRadius(15)
                                    
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Performed rounds:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
                                    if let rounds = workout.numberOfRounds {
                                        Text("\(rounds) round\(rounds == 1 ? "" : "s")")
                                            .frame(width: geometry.size.width / 3)
                                            .padding()
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .background(Color("cardBackgroundColor"))
                                            .cornerRadius(15)
                                    }
                                    
                                }
                                
                                
                            }
                            .padding()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text("Performed sets:")
                                        .font(.body)
                                        .foregroundColor(.white)
                                    
                                    
                                    if let series = workout.setSeries {
                                        Text("\(series) set\(series == 1 ? "" : "s")")
                                            .frame(width: geometry.size.width / 3)
                                            .padding()
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .background(Color("cardBackgroundColor"))
                                            .cornerRadius(15)
                                    }
                                }
                                
                                Spacer()
                                
                                
                                
                                
                            }
                            .padding(.horizontal)
                                
                                
                            
                        }
                    }
                }.padding(.top, 30)
                
                
                // NavigationLink to handle the navigation
                NavigationLink(destination: viewModel.redirectToProperWorkoutView(to: workout), isActive: $navigateToWorkout) {
                    EmptyView() // Invisible link that activates when navigateToWorkout is true
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showRepeatAlert.toggle()
                }) {
                    Image(systemName: "repeat")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 2)
                }
            }
        }
        .alert(isPresented: $showRepeatAlert) {
            Alert(
                title: Text("Repeat Workout"),
                message: Text("Do you want to repeat this workout?"),
                primaryButton: .default(Text("Yes")) {
                    navigateToWorkout = true
                },
                secondaryButton: .cancel()
            )
        }
    
        
    }
}

struct WorkoutHistoryDetail_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        let dummyWorkout = Workout(
            type: .Amrap,
            date: Date(), // Use the current date for the dummy workout
            initialCountdown: 300,
            seriesPerformed: 5,
            seriesTimes: [30, 40, 35, 45, 50] // Example series times in seconds
        )
        
        
        
        Group {
            WorkoutHistoryDetailView(viewModel: WorkoutHistoryDetailView.ViewModel(), workout: dummyWorkout)
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            WorkoutHistoryDetailView(viewModel: WorkoutHistoryDetailView.ViewModel(), workout: dummyWorkout)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            WorkoutHistoryDetailView(viewModel: WorkoutHistoryDetailView.ViewModel(), workout: dummyWorkout)
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}
