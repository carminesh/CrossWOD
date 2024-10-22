//
//  ContentView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 12/10/24.
//


import SwiftUI

struct ContentView: View {
    @State private var selectedMode: String = ""
    @State private var showTimer = false
    

    let workouts = [
        (title: "AMRAP", icon: "amrap_card", modeDescription: "As many rounds as possible", destination: AnyView(AMRAPConfigView())),
        (title: "EMOM", icon: "emom_card", modeDescription: "Every minute on the minute", destination: AnyView(EMOMConfigView())),
        (title: "FOR TIME", icon: "for_time_card", modeDescription: "Workout as fast as possible",  destination: AnyView(ForTimeConfigView())),
        (title: "TABATA", icon: "tabata_card", modeDescription: "Intense work followed by rest", destination: AnyView(AMRAPConfigView()))
    ]
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color("backgroundColor").edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Text("welcome.")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .padding()
                            Spacer()
                            
                            NavigationLink(destination: SettingsView()) {
                                Image("setting_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding()
                        
                      
                        LazyVStack(spacing: 0) {
                            ForEach(workouts, id: \.title) { workout in
                                NavigationLink(destination: workout.destination) {
                                    CardView(
                                        imageName: workout.icon, title: workout.title, modeDescription: workout.modeDescription
                                    )
                                    .frame(height: geometry.size.width / 3.45)
                  
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .accentColor(.white)
        }
    }
}


#Preview {
    ContentView()
}
