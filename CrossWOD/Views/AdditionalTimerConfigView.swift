//
//  AdditionalTimerConfigView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AdditionalTimerConfigView: View {
    
    @Binding var showAdditionalSettings: Bool
    @Binding var numberOfSeries: Int
    @Binding var selectedRestTime: Int
    
    var accentColor: Color
    
    var body: some View {
        
        
        ZStack {
        
            Color("extraBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            
            GeometryReader { geometry in
                
    
                
                VStack(spacing: 10){
        
                    // Sets Section
                    Text("Sets")
                        .foregroundColor(.white)
                        .font(.headline) // Dynamic font size
                        .fontWeight(.bold)
                        
                    
                    HStack {
                        // Decrease Series
                        Button(action: {
                            if numberOfSeries > 1 {
                                numberOfSeries -= 1
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)

                                Image(systemName: "minus")
                                    .font(.title2) // Dynamic size
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        }
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12) // Adjust for screen size
                        .padding(.trailing, geometry.size.width * 0.02)
                        
                        // Display Number of Series
                        Text(String(numberOfSeries))
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width * 0.3)
                        
                        // Increase Series
                        Button(action: {
                            numberOfSeries += 1
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)

                                Image(systemName: "plus")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        }
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                        .padding(.leading, geometry.size.width * 0.02)
                    }
                    .padding()
                    .background(Color("backgroundColor"))
                    .cornerRadius(20)
                    
                    
                    // Rest Time Section
                    Text("Rest time")
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        
                    
                    HStack {
                        // Decrease Rest Time
                        Button(action: {
                            if selectedRestTime > 0 {
                                if selectedRestTime > 5 * 60 {
                                    selectedRestTime -= 60 // Subtract 1 minute
                                } else if selectedRestTime > 3 * 60 {
                                    selectedRestTime -= 30 // Subtract 30 seconds
                                } else if selectedRestTime > 1 * 60 {
                                    selectedRestTime -= 15 // Subtract 15 seconds
                                } else {
                                    selectedRestTime -= 10 // Subtract 10 seconds
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)

                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                            }
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        }
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                        .padding(.trailing, geometry.size.width * 0.02)
                        
                        // Display Rest Time
                        Text(formatTimeWithDecimals(seconds: selectedRestTime))
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width * 0.3)
                        
                        // Increase Rest Time
                        Button(action: {
                            if selectedRestTime < 10 * 60 {
                                if selectedRestTime >= 5 * 60 {
                                    selectedRestTime += 60 // Add 1 minute
                                } else if selectedRestTime >= 3 * 60 {
                                    selectedRestTime += 30 // Add 30 seconds
                                } else if selectedRestTime >= 1 * 60 {
                                    selectedRestTime += 15 // Add 15 seconds
                                } else {
                                    selectedRestTime += 10 // Add 10 seconds
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)

                                Image(systemName: "plus")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        }
                        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                        .padding(.leading, geometry.size.width * 0.02)
                        
                        
                        
                    }
                    .padding()
                    .background(Color("backgroundColor"))
                    .cornerRadius(20)
                    
        
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            showAdditionalSettings = false
                        }) {
                            Text("SET CONFIG")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding()
                                .background(accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        
                        if selectedRestTime > 10 || numberOfSeries > 1 {
                            Button(action: {
                                selectedRestTime = 10
                                numberOfSeries = 1
                                
                            }) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(width: geometry.size.width * 0.143, height: geometry.size.width * 0.143)
                            .background(Color("cardBackgroundColor"))
                            .cornerRadius(15)
                        }
                    }.padding()
                    
                    
                    
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
}


#Preview {
    AdditionalTimerConfigView(showAdditionalSettings: .constant(true), numberOfSeries: .constant(1), selectedRestTime: .constant(20), accentColor: Color("emomAccentColor"))
}
