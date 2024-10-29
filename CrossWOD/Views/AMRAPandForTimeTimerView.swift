//
//  AMRAPandForTimeTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AMRAPandForTimeTimerView: View {
    
    var viewModel: ViewModel
    
    
    var body: some View {
        
        ZStack {
            
            
            Color("backgroundColor")
                .ignoresSafeArea()
            
            viewModel.riveAnimation.riveViewModel.view()
                .frame(maxWidth: .infinity)
                .opacity(viewModel.delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(1), value: viewModel.delayCountdown)
                .ignoresSafeArea()
            
            VStack {
                
                Text(viewModel.modeTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                
                
                // MARK: COUNTDOWN section
                VStack(alignment: .center) {
                    
                    
                    Text("Last series in: \(formatTimeWithDecimals(seconds: viewModel.seriesTimes.last ?? 0))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(!viewModel.seriesTimes.isEmpty ? 1 : 0)
                    
                    
                    
                    GeometryReader { geometry in
                        if viewModel.delay {
                            
                            VStack() {
                                
                                Text("STARTS IN:")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(viewModel.delay ? 1 : 0)
                                    .padding(.bottom, 20)
                                
                                Text("\(viewModel.delayCountdown)")
                                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.2))
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.accentColor)
                                
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            
                            
                            
                        } else {
                            
                            Text(formatTimeWithDecimals(seconds: viewModel.countdown))
                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.18))
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .fontWeight(.bold)
                                .opacity(viewModel.countdown == 0 ? 0 : 1)
                                .foregroundColor(.white)
                            
                            
                        }
                        
                    }
                    
                }
                .padding()
                .padding(.bottom, 80)
                
                
                // Delay showing this part after countdown == 0
                if viewModel.countdown == 0 && viewModel.showAfterDelay {
                    VStack {
                        Text(viewModel.randomPhrase)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                        
                        HStack {
                            Image("clock_icon")
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .padding(10)
                            
                            
                            Text(formatTimeWithDecimals(seconds: viewModel.startingTime))
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                            
                        }
                        .background(Color("cardBackgroundColor"))
                        .cornerRadius(12)
                        .transition(.opacity)
                        
                    }
                    .padding()
                    
                }
                
                Spacer()
                
                
                
                // MARK: BUTTON section
                HStack {
                    Button(action: {
                        viewModel.isPaused.toggle()
                        if viewModel.isPaused {
                            viewModel.startTimer()
                        } else {
                            viewModel.stopTimer()
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(viewModel.isPaused ? "pause_icon" : "start_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .padding(.leading, 50)
                            
                            Text(viewModel.isPaused ? "PAUSE" : "START")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.trailing, 50)
                        }
                        .padding(.vertical, 20)
                        .background(Color("cardBackgroundColor"))
                        .cornerRadius(15)
                    }
                    .animation(.easeInOut(duration: 1), value: viewModel.isPaused)
                    
                    Button(action: {
                        viewModel.recordLastSeriesTime()
                    }) {
                        HStack(spacing: 10) {
                            Image("add_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19, height: 19)
                                .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                        .background(viewModel.accentColor)
                        .cornerRadius(15)
                    }
                    
                }
                .padding()
                .disabled(viewModel.countdown == 0 || viewModel.delay)
                .opacity(viewModel.countdown == 0 || viewModel.delay ? 0 : 1)
                
            }
            .onAppear {
                viewModel.startDelay()
                UIApplication.shared.isIdleTimerDisabled = true
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
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}


struct AMRAPandForTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Using ViewModel for iPhone 16 Pro preview
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"), countdown: 10))
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            // Using ViewModel for iPhone SE (3rd generation) preview
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"), countdown: 10))
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            // Using ViewModel for iPad (11-inch) preview
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"), countdown: 10))
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}
