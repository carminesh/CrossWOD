//
//  WorkoutHistoryView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryView: View {
    var viewModel: ViewModel
    @State private var userIsPro: Bool = false
    @State private var workoutToDelete: Workout?
    @State private var showDeleteAlert = false
    @State private var showPaywall = false // Flag to show paywall
    
    var body: some View {
        
        
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            
            List {
                
                ForEach(viewModel.groupedWorkouts) { group in
                    Section(header: Text(dateFormatter.string(from: group.date))) {
                        ForEach(group.workouts, id: \.id) { workout in
                            
                            
                            if viewModel.canDeleteWorkout(workout, userIsPro: userIsPro) {
                                // Row for Pro users or recent workouts
                                HistoryRow(workout: workout)
                                    .background(Color("cardBackgroundColor"))
                                    .listRowInsets(EdgeInsets())
                            } else {
                                // Row for non-Pro users
                                ZStack {
                                    HistoryRow(workout: workout)
                                        .background(Color("cardBackgroundColor"))
                                        .opacity(0.5)
                                        .blur(radius: 3)
                                        .listRowInsets(EdgeInsets())
                                        .overlay(
                                            Color.black.opacity(0.2) // Dark overlay for visual restriction
                                        )

                                    // Placeholder overlay for non-Pro users
                                    VStack {
                                        Image(systemName: "lock.fill") // Replace with your icon
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.white)

                                        Text("Upgrade to Premium")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(10)
                                    
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    // Show paywall or prompt to upgrade
                                    showPaywall = true
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                workoutToDelete = group.workouts[index]
                                // Show the alert
                                showDeleteAlert = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
            .listStyle(.insetGrouped)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this workout?"),
                    primaryButton: .destructive(Text("Delete")) {
                        // Perform the deletion if the workout is valid
                        if let workoutToDelete = workoutToDelete {
                            if viewModel.canDeleteWorkout(workoutToDelete, userIsPro: userIsPro) {
                                viewModel.removeWorkout(workoutToDelete)
                            } else {
                                // Show paywall if not Pro
                                showPaywall = true
                            }
                        }
                    },
                    secondaryButton: .cancel {
                        // Clear the workout to delete
                        workoutToDelete = nil
                    }
                )
            }
        }
    }
    
}



#Preview {
    WorkoutHistoryView(viewModel: WorkoutHistoryView.ViewModel())
}
