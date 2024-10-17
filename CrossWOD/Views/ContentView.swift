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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
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
                    
                    VStack {
                        HStack {
                            Spacer()
                            // Glass cards for different modalities
                            GlassCardView(
                                selectedMode: $selectedMode,
                                showTimer: $showTimer,
                                mode: "AMRAP",
                                backgroundColor: Color.white,
                                circleColor: Color(red: 247/255, green: 79/255, blue: 51/255),
                                circleSize: 160,
                                circleOffset: CGSize(width: -100, height: -160)
                            )
                            Spacer()
                            GlassCardView(
                                selectedMode: $selectedMode,
                                showTimer: $showTimer,
                                mode: "EMOM",
                                backgroundColor: Color.white,
                                circleColor: Color.green,
                                circleSize: 120,
                                circleOffset: CGSize(width: -120, height: -100)
                            )
                            Spacer()
                        }
                        .padding(.bottom, 6)
                        HStack {
                            Spacer()
                            GlassCardView(
                                selectedMode: $selectedMode,
                                showTimer: $showTimer,
                                mode: "FOR TIME",
                                backgroundColor: Color.white,
                                circleColor: Color.yellow,
                                circleSize: 120,
                                circleOffset: CGSize(width: -100, height: -100)
                            )
                            
                            Spacer()
                            GlassCardView(
                                selectedMode: $selectedMode,
                                showTimer: $showTimer,
                                mode: "TABATA",
                                backgroundColor: Color.white,
                                circleColor: Color.blue,
                                circleSize: 120,
                                circleOffset: CGSize(width: -100, height: -160)
                            )
                            
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .sheet(isPresented: $showTimer) { [selectedMode] in
                    
                    
                    // Present appropriate view based on selected mode
                    if selectedMode == "AMRAP" {
                        AMRAPConfigView(showModal: $showTimer, selectedMode: $selectedMode)
                    } else if selectedMode == "EMOM" {
                        AMRAPConfigView(showModal: $showTimer, selectedMode: $selectedMode)
                    } else if selectedMode == "FOR TIME" {
                        // Replace with the correct view for "FOR TIME"
                        Text("For Time view")
                    } else if selectedMode == "TABATA" {
                        // Replace with the correct view for "TABATA"
                        Text("Tabata view")
                    } else {
                        // Default view when selectedMode is empty or unexpected
                        Text("Selected Mode: \(selectedMode)")
                    }
                }
            }
        }
        .accentColor(.white)
    }
    
}

#Preview {
    ContentView()
}
