//
//  WorkoutHistoryView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct WorkoutHistoryView: View {
    var viewModel = ViewModel()
    
    var body: some View {
        
        
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(viewModel.groupedWorkouts) { group in
                    Section(header: Text(dateFormatter.string(from: group.date))) {
                        ForEach(group.workouts) { workout in
                            HistoryRow(workout: workout)
                            .background(Color("cardBackgroundColor"))
                            .listRowInsets(EdgeInsets())
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                let workoutToDelete = group.workouts[index]
                                viewModel.removeWorkout(workoutToDelete)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Workout History")
            .listStyle(.insetGrouped)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }
    }
    
}

#Preview {
    WorkoutHistoryView()
}
