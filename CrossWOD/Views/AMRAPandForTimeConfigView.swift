//
//  AMRAPandForTimeConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AMRAPandForTimeConfigView: View {
    
    // --MARK: watchOs variables
    @ObservedObject var watchConnector = WatchConnector.shared
    @State private var readyToNavigate = false
    
    @State private var selectedTime: Int = 10
    @State private var showTimePicker = false
    @State private var workout: Workout?
    
    
    
    var modeTitle: String
    var modeDescription: String
    var timePickerDescription: String
    
    
    
    private var accentColor: Color {
        modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color("forTimeAccentColor")
    }
    
    
    // Initialize the view model with selectedTime
    @State private var viewModel: AMRAPandForTimeTimerView.ViewModel
    
    init(modeTitle: String, modeDescription: String, timePickerDescription: String, selectedTime: Int) {
        self.modeTitle = modeTitle
        self.modeDescription = modeDescription
        self.timePickerDescription = timePickerDescription

        
        // Initialize the ViewModel with selectedTime
        _viewModel = State(wrappedValue: AMRAPandForTimeTimerView.ViewModel(modeTitle: modeTitle, countdown: selectedTime))
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
                
                
                Text(modeDescription)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(accentColor)
                
                
                // Time Configuration Box
                VStack {
                    Text(timePickerDescription)
                        .font(.callout)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(6)
                    
                    Button(action: {
                        showTimePicker = true // Show time picker
                    }) {
                        Text(formatTimeWithDecimals(seconds: selectedTime))
                            .font(.system(size: 46))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.8)
                .padding()
                .background(Color("cardBackgroundColor"))
                .cornerRadius(25)
                .padding(.top, 30)
                
                
                Spacer()
                
                Button {
                    readyToNavigate.toggle()
                } label: {
                    Text("START TIMER")
                }
                .font(.body)
                .fontWeight(.bold)
                .padding()
                .background(accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
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
        .onAppear {
            workout = Workout(
                type: modeTitle == "AMRAP" ? .Amrap : .ForTime,
                date: Date(),
                initialCountdown: selectedTime,
                seriesPerformed: 0,
                seriesTimes: []
            )
            
            
            if let workout = workout {
                sendWorkoutInfo(workout: workout)
            }
        }
        .onChange(of: selectedTime) {
            
            // Update the workout instance each time selectedTime changes
            workout = Workout(
                type: modeTitle == "AMRAP" ? .Amrap : .ForTime,
                date: Date(),
                initialCountdown: selectedTime,
                seriesPerformed: 0,
                seriesTimes: []
            )
            
            //Update the time of the viewModel
            viewModel = AMRAPandForTimeTimerView.ViewModel(modeTitle: modeTitle, countdown: selectedTime)
            
            
            if let workout = workout {
                sendWorkoutInfo(workout: workout)
            }
        }
        .navigationDestination(isPresented: $readyToNavigate) {
            AMRAPandForTimeTimerView(viewModel: viewModel)
        }
        .onChange(of: watchConnector.startWorkout) { readyToNavigate = true }
        
    }
}

//#Preview {
//    AMRAPandForTimeConfigView(
//        modeTitle: "AMRAP",
//        modeDescription: "Maximum number of possible series in:",
//        timePickerDescription: "Complete as many rounds as possible in:"
//    )
//}
