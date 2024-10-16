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
                            Text(formatTime(seconds: selectedTime))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 74, height: 74)
                                .overlay( // Create the outline
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 247/255, green: 79/255, blue: 51/255), lineWidth: 3)
                                )
                        }
                        
                        Text(formatTimeText(seconds: selectedTime))
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(6)
                    }
                    
                    Spacer()
                    
                    // NavigationLink for starting the timer
                    NavigationLink(destination: ARMAPTimerView(showModal: $showModal, countdown: selectedTime)){
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
    
    func formatTime(seconds: Int) -> String {
        if seconds < 60 {
            return String(seconds)
        } else if seconds == 60 {
            return String(1)
        } else if seconds % 60 == 0 {
            return String(seconds / 60)
        } else {
            return "\(String(seconds / 60)):\(String(seconds % 60))"
        }
    }
    
    // Format the time as before
    func formatTimeText(seconds: Int) -> String {
        if seconds < 60 {
            return "Seconds"
        } else if seconds == 60 {
            return "Minute"
        } else {
            return "Minutes"
        }
    }
}

struct AMRAPConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AMRAPConfigView(showModal: .constant(true), selectedMode: .constant("AMRAP"))
    }
}
