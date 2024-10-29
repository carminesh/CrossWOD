//
//  TabataTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct TabataTimerView: View {
    
    var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            viewModel.riveAnimation.riveViewModel.view()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(UIScreen.main.bounds.width < 376 ? 1.15 : 1.0)
                .opacity(viewModel.delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(1), value: viewModel.delayCountdown)
                .ignoresSafeArea()
            
            VStack {
                Text("TABATA")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                
                HStack(spacing: 20) {
                    
                    if viewModel.setSeries > 1 {
                        InfoIndicator(text: "Set: \(viewModel.currentSet)/\(viewModel.setSeries)", accentColor: Color("tabataAccentColor"), number: viewModel.currentSet, outOF: viewModel.setSeries, timerHasFinished: viewModel.timerHasFinished)
                    }
                    
                    if viewModel.numberOfSeries > 1 {
                        
                        InfoIndicator(text: "Round: \(viewModel.currentRound)/\(viewModel.numberOfSeries)", accentColor: Color("tabataAccentColor"), number: viewModel.currentRound, outOF: viewModel.numberOfSeries, timerHasFinished: viewModel.timerHasFinished)
                    }
                    
                    
                    
                }
                .opacity(viewModel.delay ? 0 : 1)
                .padding(.horizontal, 10)
                
                Spacer()
                    .frame(height: 70)
                
                VStack {
                    
                    if !viewModel.isResting {
                        Text("STARTS IN:")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .opacity(viewModel.delay ? 1 : 0)
                    } else if viewModel.isResting && !viewModel.timerHasFinished {
                        Text("REST")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("tabataAccentColor"))
                            .padding()
                            .animation(.easeInOut, value: viewModel.isResting)
                            .onAppear {
                                viewModel.riveAnimation.doRestRiveAnimation()
                            }
                            .onDisappear {
                                
                                if (!viewModel.timerHasFinished) {
                                    viewModel.riveAnimation.undoRestRiveAnimation()
                                } else {
                                    viewModel.riveAnimation.restToStopRiveAnimation()
                                }
                                
                            }
                    }
                    
                    if viewModel.delay {
                        Text("\(viewModel.delayCountdown)")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color("tabataAccentColor"))
                    } else {
                        Text(formatTimeWithDecimals(seconds: viewModel.timeRemaining))
                            .font(.system(size: 56))
                            .fontWeight(.bold)
                            .opacity(viewModel.timeRemaining == 0 ? 0 : 1)
                            .foregroundColor(.white)
                            .padding()
                    }
                }.padding()
                
                if viewModel.timerHasFinished && viewModel.showAfterDelay {
                    Spacer()
                    Text(viewModel.randomPhrase)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .padding()
                    
                    HStack {
                        Image("clock_icon")
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(.all, 8)
                            .padding(.leading, 12)
                        
                        Text(formatTimeWithDecimals(seconds: viewModel.totalTime))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.all, 8)
                            .padding(.trailing, 12)
                    }
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                // MARK: BUTTON section
                HStack {
                    Button(action: {
                        viewModel.isPaused.toggle()
                        if viewModel.isPaused {
                            viewModel.startTimer()
                        } else {
                            viewModel.riveAnimation.pauseRiveAnimation()
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
                }
                .disabled(viewModel.timeRemaining == 0 || viewModel.delay || viewModel.isResting || viewModel.isSetResting)
                .opacity(viewModel.timeRemaining == 0 || viewModel.delay || viewModel.isResting || viewModel.isSetResting ? 0 : 1)
                .padding(.bottom, 40)
            }
            .onAppear {
                viewModel.startDelay()
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onChange(of: viewModel.timerHasFinished) {
                if viewModel.timerHasFinished {
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
                viewModel.resetTimer()
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}




#Preview {
    TabataTimerView(viewModel: TabataTimerView.ViewModel(workTime: 10, restTime: 5, numberOfSeries: 2, setRestTime: 10, setSeries: 1))
}
