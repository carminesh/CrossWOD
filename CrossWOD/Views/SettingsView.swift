//
//  SettingsView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        
        ZStack {
            Color("backgroundColor") // Apply background color to ZStack
                .edgesIgnoringSafeArea(.all) // Extend the background to the edges
            
            List {
                Section(header: Text("Your progress").font(.headline)) {
                    SettingsRow(icon: "figure.run", title: "Workout history", destination: WorkoutHistoryView())
                }
                
                Section(header: Text("Others").font(.headline)) {
                    SettingsRow(icon: "person.fill", title: "Suggest new features", destination: Text("Sign In"))
                    SettingsRow(icon: "info.circle", title: "About", destination: Text("About"))
                }
                
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden) // This hides the default background
            
            
        }
        
        
    }
}

#Preview {
    SettingsView()
}


    
