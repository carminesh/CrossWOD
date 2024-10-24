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
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("EMOM")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Every minute on the minute")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    // Time Configuration Box
                    VStack {
                        Text("Workout every:")
                            .font(.callout)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: {
                            showTimePicker = true
                            everyTimeBool = true // Show time picker
                        }) {
                            Text(formatTimeWithDecimals(seconds: everyTime))
                                .font(.system(size: 46))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(minWidth: UIScreen.main.bounds.width * 0.8)
                    .padding()
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(25)
                    
                    VStack {
                        Text("For:")
                            .font(.callout)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            
                            // Decrease Series
                            Button(action: {
                                forTime = max(forTime - everyTime, everyTime)
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "minus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                            }
                            .frame(width: 50, height: 50)
                            
            
                                
                            
                            // Display Number of Series
                            Text(formatTimeWithDecimals(seconds: forTime))
                                .frame(width: 150, height: 62)
                                .foregroundColor(.white)
                                .font(.system(size: 46))
                                .fontWeight(.bold)
                               
                            
                            Button(action: {
                                forTime = min(forTime + everyTime, 10 * everyTime)
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2)
                                )
                            }
                            .frame(width: 50, height: 50)
                            
                            
                        }
                        .padding(.horizontal)
                        .cornerRadius(20)

                    }
                    .frame(minWidth: UIScreen.main.bounds.width * 0.8)
                    .padding()
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(25)
                }
                .padding()
                
                VStack(spacing: 16) {
                    Button(action: {
                        withAnimation {
                            showAdditionalSettings = true
                        }
                    }) {
                        Text(additionalSettingsAreApplied ? "Custom configuration added" : "+ Add configuration (optional)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(additionalSettingsAreApplied ? Color("emomAccentColor") : .white)
                            .padding()
                    }
                    
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
                            .background(Color("emomAccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.bottom, 40)
                }
            }
            .accentColor(.white)
            .sheet(isPresented: $showAdditionalSettings) {
                AdditionalTimerConfigView(
                    showAdditionalSettings: $showAdditionalSettings,
                    numberOfSeries: $numberOfSeries,
                    selectedRestTime: $selectedRestTime,
                    accentColor: Color("emomAccentColor")
                )
                .presentationDetents(
                    [.medium],
                    selection: $emomAdditionalConfigDetent
                )
            }
            
            // Custom time picker overlay
            if showTimePicker {
                ZStack {
                    Color.black.opacity(0.9)
                    
                    VStack {
                        if everyTimeBool {
                            CustomTimePicker(intervalType: "EMOM", selectedTime: $everyTime)
                                .onChange(of: everyTime) {
                                    updateForTime()
                                }
                        }
                        
                        Button("Done") {
                            showTimePicker = false
                            everyTimeBool = false
                            forTimeBool = false
                        }
                        .padding()
                        .buttonStyle(.bordered)
                    }
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(25)
                    .frame(width: 300, height: 400)
                    .shadow(radius: 10)
                    .transition(.scale)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .animation(.easeInOut, value: showTimePicker)
    }
    
    private func updateForTime() {
        // Ensure forTime is always a multiple of everyTime
        if forTime < everyTime {
            forTime = everyTime
        } else {
            forTime = ((forTime + everyTime - 1) / everyTime) * everyTime
        }
    }
}
struct EMOMConfigView_Previews: PreviewProvider {
    static var previews: some View {
        EMOMConfigView()
    }
}
