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
        
    
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(workoutHistoryManager.groupedWorkouts) { group in
                    Section(header: Text(dateFormatter.string(from: group.date))) {
                        ForEach(group.workouts) { workout in
                            HistoryRow(
                                viewModel: HistoryRowViewModel(workoutType: workout.type.rawValue),
                                workout: workout
                            )
                            .background(Color("cardBackgroundColor"))
                            .listRowInsets(EdgeInsets())
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                let workoutToDelete = group.workouts[index]
                                workoutHistoryManager.removeWorkout(workoutToDelete)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
            .onAppear {
                workoutHistoryManager.loadWorkouts()
            }
            .listStyle(.insetGrouped)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }
    }
    
}

#Preview {
    WorkoutHistoryView()
}
