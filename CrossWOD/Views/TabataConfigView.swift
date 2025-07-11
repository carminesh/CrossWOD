//
//  TabataConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct TabataConfigView: View {
    
    @State private var numberOfSeries: Int = 1
    @State private var workTime: Int = 5
    @State private var restTime: Int = 5
    @State private var showTimePicker = false
    
    @State private var workTimeBool = false
    @State private var restTimeBool = false
    @State private var showAdditionalSettings = false
    @State private var emomAdditionalConfigDetent = PresentationDetent.medium
    
    @State private var numberOfSets: Int = 1
    @State private var selectedRestTimeForSet: Int = 10
    
    var additionalSettingsAreApplied: Bool {
        return numberOfSets > 1 || selectedRestTimeForSet > 10
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            

            VStack {
                
                
                Text("TABATA")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Intense work followed by rest")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("tabataAccentColor"))
            
                // MARK: Time configuration boxes
                VStack(spacing: 16) {
                    // Time Configuration Box
                    VStack {
                        Text("Number of series:")
                            .font(.callout)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        
                        
                        HStack(spacing: 50) {
                            
                            // Decrease Series
                            Button(action: {
                                if numberOfSeries > 1 {
                                    numberOfSeries -= 1
                                }
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
                            Text(String(numberOfSeries))
                                .frame(width: 62, height: 62)
                                .foregroundColor(.white)
                                .font(.system(size: 46))
                                .fontWeight(.bold)
                                
                            
                            // Increase Series
                            Button(action: {
                                if numberOfSeries < 60 {
                                    numberOfSeries += 1
                                }
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
            
                    
                    VStack {
                        Text("Work for:")
                            .font(.callout)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                           
                        
                        Button(action: {
                            showTimePicker = true
                            workTimeBool = true
                        }) {
                            Text(formatTimeWithDecimals(seconds: workTime))
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
                        Text("Rest for:")
                            .font(.callout)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        
                        Button(action: {
                            showTimePicker = true
                            restTimeBool = true
                        }) {
                            Text(formatTimeWithDecimals(seconds: restTime))
                                .font(.system(size: 46))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(minWidth: UIScreen.main.bounds.width * 0.8)
                    .padding()
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(25)
                    
                    
                }.padding()
                
                
                
               
                
                
               
                
                VStack(spacing: 16) {
                    
                    
                    Button(action: {
                        withAnimation {
                            showAdditionalSettings = true
                        }
                    }) {
                        Text(additionalSettingsAreApplied ? "Custom configuration added" : "+ Add configuration (optional)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(additionalSettingsAreApplied ? Color("tabataAccentColor") : .white)
                           
                    }
                  
                    
                    Spacer()
                    
                    NavigationLink(destination: TabataTimerView(viewModel: TabataTimerView.ViewModel(workTime: workTime, restTime: restTime, numberOfSeries: numberOfSeries, setRestTime: selectedRestTimeForSet, setSeries: numberOfSets)))
                    {
                        Text("START TIMER")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color("tabataAccentColor"))
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
                    numberOfSeries: $numberOfSets,
                    selectedRestTime: $selectedRestTimeForSet,
                    accentColor: Color("tabataAccentColor")
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
                        if workTimeBool {
                            CustomTimePicker(intervalType: "TABATA", selectedTime: $workTime)
                        } else if restTimeBool {
                            CustomTimePicker(intervalType: "TABATA", selectedTime: $restTime)
                                
                            
                        }
                        
                        Button("Done") {
                            showTimePicker = false
                            workTimeBool = false
                            restTimeBool = false
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

#Preview {
    TabataConfigView()
}
