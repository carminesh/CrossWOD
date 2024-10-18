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
                                mode: "AMRAP",
                                backgroundColor: Color.white,
                                circleColor: Color(red: 247/255, green: 79/255, blue: 51/255),
                                circleSize: 160,
                                circleOffset: CGSize(width: -100, height: -160),
                                destination: AMRAPConfigView()
                            )
                            Spacer()
                            GlassCardView(
                                mode: "EMOM",
                                backgroundColor: Color.white,
                                circleColor: Color.green,
                                circleSize: 120,
                                circleOffset: CGSize(width: -120, height: -100),
                                destination: EMOMConfigView()
                            )
                            
                            Spacer()
                        }
                        .padding(.bottom, 6)
                        HStack {
                            Spacer()
                            GlassCardView(
                                mode: "FOR TIME",
                                backgroundColor: Color.white,
                                circleColor: Color.yellow,
                                circleSize: 120,
                                circleOffset: CGSize(width: -100, height: -100),
                                destination: EMOMConfigView()
                            )
                            
                            Spacer()
                            GlassCardView(
                                mode: "TABATA",
                                backgroundColor: Color.white,
                                circleColor: Color.blue,
                                circleSize: 120,
                                circleOffset: CGSize(width: -100, height: -160),
                                destination: EMOMConfigView()
                            )
                            
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
            }
        }
        .accentColor(.white)
    }
    
}

#Preview {
    ContentView()
}
