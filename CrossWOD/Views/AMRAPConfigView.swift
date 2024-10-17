//
//  AMRAPConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI

struct AMRAPConfigView: View {
    @Binding var showModal: Bool
    @Binding var selectedMode: String
    
    @State private var selectedTime: Int = 10
    @State private var showTimePicker = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Dismiss the view
                            showModal = false
                        }) {
                            Image("close_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding()
                        }
                    }
                    
                    Text("AMRAP")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
                    Text("Maximum number of possible series in:")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            showTimePicker = true // Show time picker
                        }) {
                            Text(formatTimeToNumberOnly(seconds: selectedTime))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .overlay( // Create the outline
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 247/255, green: 79/255, blue: 51/255), lineWidth: 3)
                                )
                        }
                        
                        Text(formatTimeToOnlyText(seconds: selectedTime))
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(6)
                    }
                    
                    Spacer()
                    
                    // NavigationLink for starting the timer
                    NavigationLink(destination: AMRAPTimerView(showModal: $showModal, countdown: selectedTime)){
                        Text("START TIMER")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(red: 247/255, green: 79/255, blue: 51/255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                // Custom time picker overlay
                if showTimePicker {
                    ZStack {
                        Color.black.opacity(1) // Dimmed background
                        
                        VStack {
                            CustomTimePicker(selectedTime: $selectedTime)
                            
                            Button("Done") {
                                showTimePicker = false // Hide the picker
                            }
                            .padding()
                            .buttonStyle(.bordered)
                        }
                        .frame(width: 300, height: 400)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .transition(.scale) // Animation for showing the picker
                    }
                    .edgesIgnoringSafeArea(.all) // Cover the entire screen
                }
                
            }
            .animation(.easeInOut, value: showTimePicker)
            
        }
        .accentColor(.white)
    }
    
    
}

struct AMRAPConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AMRAPConfigView(showModal: .constant(true), selectedMode: .constant("AMRAP"))
    }
}
