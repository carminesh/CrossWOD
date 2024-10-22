//
//  AMRAPConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI

struct AMRAPConfigView: View {
    @State private var selectedTime: Int = 10
    @State private var showTimePicker = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                Text("AMRAP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("As many rounds as possible")
                    .font(.subheadline)
                    
                    
                
                
                // Time Configuration Box
                VStack {
                    Text("Maximum number of possible series in:")
                        .font(.callout)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        showTimePicker = true // Show time picker
                    }) {
                        Text(formatTimeWithDecimals(seconds: selectedTime))
                            .font(.system(size: 46))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color("cardBackgroundColor"))
                .cornerRadius(25)
                .padding(.top, 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                
                Spacer() 
                
                // NavigationLink for starting the timer
                NavigationLink(destination: AMRAPTimerView(countdown: selectedTime)){
                    Text("START TIMER")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color("amrapAccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.bottom, 40) // Add padding at the bottom for spacing
            }
            
            // Custom time picker overlay
            if showTimePicker {
                ZStack {
                    Color.black.opacity(0.9) // Dimmed background
                    
                    VStack {
                        CustomTimePicker(intervalType: "AMRAP", selectedTime: $selectedTime)
                        
                        Button("Done") {
                            showTimePicker = false // Hide the picker
                        }
                        .padding()
                        .buttonStyle(.bordered)
                    }
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(25)
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.scale)

                }
                .edgesIgnoringSafeArea(.all) // Cover the entire screen
            }
        }
        .animation(.easeInOut, value: showTimePicker)
    }
}


struct AMRAPConfigView_Previews: PreviewProvider {
    static var previews: some View {
        AMRAPConfigView()
    }
}
