//
//  AMRAPAndForTimeTimer.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import SwiftUI

struct AMRAPAndForTimeTimer: View {
    
    var viewModel: ViewModel
    
    
    var body: some View {
        
        ZStack {
            
            
            Color("backgroundColor")
                .ignoresSafeArea()
        
            
            VStack {
                
                Text(viewModel.modeTitle)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Text("STARTS IN:")
                    .font(.caption)
                    .foregroundColor(.white)
                    .opacity(viewModel.delay ? 1 : 0)
                    .padding(.bottom, 20)
                
                
                

                   
                
                // MARK: COUNTDOWN section
                VStack(alignment: .center) {
                    
                    if viewModel.delay {
                        
                        Text("\(viewModel.delayCountdown)")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color("forTimeAccentColor"))
        
                    } else {
                        
                        Text(formatTimeWithDecimals(seconds: viewModel.countdown))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .opacity(viewModel.countdown == 0 ? 0 : 1)
                            .foregroundColor(.white)
                        
                    }
                    
                }.padding()
                
                                
            
                
                    
                
                // MARK: BUTTON section
                    Button(action: {
                        viewModel.isPaused.toggle()
                        if viewModel.isPaused {
                            viewModel.startTimer()
                        } else {
                            viewModel.stopTimer()
                        }
                    }) {
                        HStack(spacing: 8) {
                            
                            Image(viewModel.isPaused ? "pause_icon" : "start_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                
                            
                            Text(viewModel.isPaused ? "PAUSE" : "START")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 175, height: 50)
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(13)
                    .disabled(viewModel.countdown == 0 || viewModel.delay)
                    .opacity(viewModel.countdown == 0 || viewModel.delay ? 0 : 1)
                    .animation(.easeInOut(duration: 1), value: viewModel.isPaused)
//                    Button(action: {
//                        viewModel.recordLastSeriesTime()
//                    }) {
//                        HStack(spacing: 10) {
//                            Image("add_icon")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 19, height: 19)
//                                .padding(.horizontal, 20)
//                        }
//                        .padding(.vertical, 20)
//                        .background(viewModel.modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color("forTimeAccentColor"))
//                        .cornerRadius(15)
//                    }
                    

                
            }
            .onAppear {
                viewModel.startDelay()
                
            }
            .onChange(of: viewModel.countdown) {
                if viewModel.countdown == 0 {
                    // Add a delay before showing the text
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            viewModel.showAfterDelay = true
                        }
                    }
                }
            }
            .onDisappear {
                viewModel.saveWorkoutHistory()
                viewModel.resetCountdown()
            }
        }
    }
    
}

#Preview {
    AMRAPAndForTimeTimer(viewModel: AMRAPAndForTimeTimer.ViewModel(modeTitle: "AMRAP", countdown: 2))
}
