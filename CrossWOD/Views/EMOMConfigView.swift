//
//  EMOMConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 17/10/24.
//

import SwiftUI

struct EMOMConfigView: View {
    
    @State private var everyTime: Int = 60 {
        didSet {
            // Update forTime to be the next multiple of everyTime if needed
            updateForTime()
        }
    }
    @State private var forTime: Int = 120
    @State private var showTimePicker = false
    
    @State private var everyTimeBool = false
    @State private var forTimeBool = false
    @State private var showAdditionalSettings = false
    @State private var emomAdditionalConfigDetent = PresentationDetent.medium
    
    @State private var numberOfSeries: Int = 1
    @State private var selectedRestTime: Int = 10
    
    var additionalSettingsAreApplied: Bool {
        return numberOfSeries > 1 || selectedRestTime > 10
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("EMOM")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("Every x minute(s) for y repetition(s)")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack {
                    HStack {
                        VStack {
                            Text("Every:")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(6)
                            
                            Text("for:")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding()
                        
                        VStack {
                            Button(action: {
                                showTimePicker = true
                                everyTimeBool = true
                            }) {
                                Text(formatTimeToNumberOnly(seconds: everyTime))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.green, lineWidth: 3)
                                    )
                            }
                            .padding(.bottom, 4)
                            
                            Button(action: {
                                showTimePicker = true
                                forTimeBool = true
                            }) {
                                Text(formatTimeToNumberOnly(seconds: forTime))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.green, lineWidth: 3)
                                    )
                            }
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            showAdditionalSettings = true
                        }
                    }) {
                        Text(additionalSettingsAreApplied ? "Custom configuration added" : "+ Add configuration (optional)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(additionalSettingsAreApplied ? .green : .white)
                            .padding()
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: EMOMTimerView(
                        everyTime: everyTime,
                        forTime: forTime,
                        numberOfSeries: numberOfSeries,
                        restTime: selectedRestTime
                    )) {
                        Text("START TIMER")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .accentColor(.white)
            .sheet(isPresented: $showAdditionalSettings) {
                EMOMAdditionalConfigView(
                    showAdditionalSettings: $showAdditionalSettings,
                    numberOfSeries: $numberOfSeries,
                    selectedRestTime: $selectedRestTime
                )
                .presentationDetents(
                    [.medium],
                    selection: $emomAdditionalConfigDetent
                )
            }
            
            // Custom time picker overlay
            if showTimePicker {
                ZStack {
                    Color.black.opacity(1) // Dimmed background
                    
                    VStack {
                        if everyTimeBool {
                            CustomTimePicker(intervalType: "EMOM", selectedTime: $everyTime)
                                .onChange(of: everyTime) {                         updateForTime() 
                                }
                        } else if forTimeBool {
                            CustomTimePicker(intervalType: "SIMPLE EMOM", selectedTime: $forTime)
                                
                            
                        }
                        
                        Button("Done") {
                            showTimePicker = false
                            everyTimeBool = false
                            forTimeBool = false
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
    
    private func updateForTime() {
        
        if forTime < 2 * everyTime {
            forTime = 2 * everyTime
        } else {
            forTime = ((forTime + everyTime - 1) / everyTime) * everyTime;
        }
        
    }
}

struct EMOMConfigView_Previews: PreviewProvider {
    static var previews: some View {
        EMOMConfigView()
    }
}
