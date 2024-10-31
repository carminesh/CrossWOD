//
//  ContentView.swift
//  WatchCrossWOD Watch App
//
//  Created by Carmine Fabbri on 30/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var watchConnector = WatchConnector.shared
    
    var body: some View {
        VStack {
            
            if let workout = watchConnector.workout {
                
                switch workout.type {
                case .Amrap, .ForTime:
                    AMRAPAndForTimeConfig(selectedWorkout: workout)
                case .Emom:
                    Text("EMOM")
                case .Tabata:
                    Text("TABATA")
                }
                
                
            } else {
                
                Text("Open the CrossWOD application on your iPhone and select the workout")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
