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
                    SettingsRow(icon: "figure.run", title: "Workout history", destination: WorkoutHistoryView(viewModel: WorkoutHistoryView.ViewModel()))
                }
                
                Section(header: Text("Others").font(.headline)) {
                    SettingsRow(icon: "star.fill", title: "Rate the app", destination: Text("Rate app"))
                    SettingsRow(icon: "plus.rectangle.fill.on.rectangle.fill", title: "Suggest new features", destination: Text("Sign In"))
                    SettingsRow(icon: "info.circle.fill", title: "About", destination: Text("About"))
                }
                
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden) // This hides the default background
            
            
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            SettingsView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            SettingsView()
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}


    
