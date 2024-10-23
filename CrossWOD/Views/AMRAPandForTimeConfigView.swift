//
//  AMRAPandForTimeConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AMRAPandForTimeConfigView: View {
    @State private var selectedTime: Int = 10
    @State private var showTimePicker = false
    
    
    var modeTitle: String
    var modeDescription: String
    
    
    private var accentColor: Color {
        modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color("forTimeAccentColor")
    }
    
    
    
   
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                Text(modeTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(.white)
                
    
                    

                
                // Time Configuration Box
                VStack {
                    Text(modeDescription)
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
                .frame(minWidth: UIScreen.main.bounds.width * 0.8)
                .padding()
                .background(Color("cardBackgroundColor"))
                .cornerRadius(25)
                .padding(.top, 30)
                
                
                Spacer()
                
                // NavigationLink for starting the timer
                NavigationLink(destination: AMRAPandForTimeTimerView(countdown: selectedTime, modeTitle: modeTitle, accentColor: accentColor)){
                    Text("START TIMER")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding()
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.bottom, 40)
            }
            
            // Custom time picker overlay
            if showTimePicker {
                ZStack {
                    Color.black.opacity(0.9) // Dimmed background
                    
                    VStack {
                        CustomTimePicker(intervalType: modeTitle, selectedTime: $selectedTime)
                        
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

#Preview {
    AMRAPandForTimeConfigView(
        modeTitle: "AMRAP",
        modeDescription: "Maximum number of possible series in:"
    )
}
