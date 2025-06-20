//
//  EMOMTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 17/10/24.
//

import SwiftUI

struct EMOMTimerView: View {
    
    var viewModel: ViewModel
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isListening = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            viewModel.riveAnimation.riveViewModel.view()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(UIScreen.main.bounds.width < 376 ? 1.15 : 1.0)
                .opacity(viewModel.delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(1), value: viewModel.delayCountdown)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    // Titolo centrato
                    Text("EMOM")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()

                    // Bottone microfono allineato a destra
                    HStack {
                        Spacer()
                        Button(action: {
                            isListening.toggle()
                            if isListening {
                                speechRecognizer.startListening()
                            } else {
                                speechRecognizer.stopListening()
                            }
                        }) {
                            Image(systemName: isListening ? "mic.fill" : "mic.slash.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .padding(12)
                                .background(isListening ? Color("emomAccentColor") : Color("cardBackgroundColor"))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                    }
                

            }
                
                HStack(spacing: 20) {
                    
                    if viewModel.setSeries > 1 {
                        InfoIndicator(text: "Set: \(viewModel.currentSet)/\(viewModel.setSeries)", accentColor: Color("emomAccentColor"), number: viewModel.currentSet, outOF: viewModel.setSeries, timerHasFinished: viewModel.timerHasFinished)
                    }
                    
                    
                    if viewModel.numberOfSeries > 1 {
                        InfoIndicator(text: "Round: \(viewModel.currentRound)/\(viewModel.numberOfSeries)", accentColor: Color("emomAccentColor"), number: viewModel.currentRound, outOF: viewModel.numberOfSeries, timerHasFinished: viewModel.timerHasFinished)
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
                    } else if (viewModel.isResting && !viewModel.timerHasFinished && viewModel.restTime > 1) || viewModel.isSetResting {
                        Text("REST")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("emomAccentColor"))
                            .padding()
                            .animation(.easeInOut, value: viewModel.isResting || viewModel.isSetResting)
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
                            .foregroundColor(Color("emomAccentColor"))
                    } else {
                        Text(formatTimeWithDecimals(seconds: viewModel.timeRemaining))
                            .font(.system(size: 60))
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
                .disabled(viewModel.timeRemaining == 0 || viewModel.delay || viewModel.isSetResting)
                .opacity(viewModel.timeRemaining == 0 || viewModel.delay || viewModel.isSetResting ? 0 : 1)
                .padding(.bottom, 40)
            }
            .onAppear {
                viewModel.startDelay()
                
                speechRecognizer.onCommandRecognized = { command in
                    if isListening {
                        switch command {
                            
                           
                            
                        case "continua", "riprendi":
                            viewModel.isPaused.toggle()
                            print("▶️ VOCE: \(command) - Avvio/Riprendo timer")
                            if viewModel.isPaused {
                                viewModel.startTimer()
                            }

                        case "pausa", "stop":
                            viewModel.isPaused.toggle()
                            print("⏸️ VOCE: \(command) - Pausa/Stop timer")
                            if !viewModel.isPaused {
                                viewModel.riveAnimation.pauseRiveAnimation()
                                viewModel.stopTimer()

                            }
                            
                      
                        default:
                            print("❓ Comando vocale non riconosciuto: \(command)")
                            break
                        }
                    }
                    
                    speechRecognizer.startListening()
                }
                
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
                viewModel.reset()
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    
    
}

#Preview {
    EMOMTimerView(viewModel: EMOMTimerView.ViewModel(workTime: 60, forTime: 60, setRestTime: 10, setSeries: 1))
}
