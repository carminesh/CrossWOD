//
//  ForTimeConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 22/10/24.
//


import SwiftUI

struct ForTimeConfigView: View {
    @State private var selectedTime: Int = 60
    @State private var showTimePicker = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title
                Text("FOR TIME")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Workout as fast as possible")
                    .font(.subheadline)
                    
                    
                
                
                // Time Configuration Box
                VStack {
                    Text("Work as quickly as possible for:")
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
                NavigationLink(destination: ForTimeTimerView(countdown: selectedTime)){
                    Text("START TIMER")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color("forTimeAccentColor"))
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
                        CustomTimePicker(intervalType: "FOR TIME", selectedTime: $selectedTime)
                        
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
                .edgesIgnoringSafeArea(.all)
            }
        }
        .animation(.easeInOut, value: showTimePicker)
    }
}


struct ForTimeConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ForTimeConfigView()
    }
}
