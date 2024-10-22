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
                    .padding(.top, 20)
                
                Text("Every minute on the minute")
                    .font(.subheadline)
                
                Spacer()
                
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
                .padding(.top, 30)
                
                
                VStack {
                    Text("for:")
                        .font(.callout)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        showTimePicker = true
                        forTimeBool = true
                    }) {
                        Text(formatTimeWithDecimals(seconds: forTime))
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
                
                
               
                
                VStack {
                    
                    
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
                            .background(Color("emomAccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
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
                    Color.black.opacity(0.9) 
                    
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
