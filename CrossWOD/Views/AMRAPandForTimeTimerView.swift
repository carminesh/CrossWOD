//
//  AMRAPandForTimeTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AMRAPandForTimeTimerView: View {
    
    var viewModel: ViewModel

    @ObservedObject var watchConnector = WatchConnector.shared
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isListening = false
    
    // Access the presentation mode to allow navigation control
    @Environment(\.presentationMode) var presentationMode
    
    
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
                
                HStack {
                    ZStack {
                        Text(viewModel.modeTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()

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
                                    .background(
                                                isListening
                                                    ? (viewModel.modeTitle == "AMRAP"
                                                        ? Color("amrapAccentColor")
                                                        : Color("forTimeAccentColor"))
                                                    : Color("cardBackgroundColor")
                                            )
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
                
              
                
                
                HStack(spacing: 20) {
                    
                    Text("Last series in: \(formatTimeWithDecimals(seconds: viewModel.seriesTimes.last ?? 0))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(!viewModel.seriesTimes.isEmpty && viewModel.countdown > 0 ? 1 : 0)
                    
    
                    
                }
                .opacity(viewModel.delay ? 0 : 1)
                .padding(.horizontal, 10)
                
                
                Spacer()
                    .frame(height: 70)
                
                
                // MARK: COUNTDOWN section
                VStack(alignment: .center) {
                    
                    
                    if viewModel.delay {
                        
                        VStack() {
                            
                            Text("STARTS IN:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .opacity(viewModel.delay ? 1 : 0)
                                .padding(.bottom, 20)
                            
                            Text("\(viewModel.delayCountdown)")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color("forTimeAccentColor"))
                            
                        }
                        
                        
                        
                        
                    } else {
                        
                        Text(formatTimeWithDecimals(seconds: viewModel.countdown))
                            .font(.system(size: 56))
                            .fontWeight(.bold)
                            .opacity(viewModel.countdown == 0 ? 0 : 1)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        
                    }
                    
                }.padding()
                
                
                // Delay showing this part after countdown == 0
                if viewModel.countdown == 0 && viewModel.showAfterDelay {
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
                        
                        Text(formatTimeWithDecimals(seconds: viewModel.startingTime))
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
                        
                        sendPauseInfo(toPaused: viewModel.isPaused, countdownToAdjust: viewModel.countdown)
                        
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
                        .background(viewModel.modeTitle == "AMRAP" ? Color("amrapAccentColor") : Color	("forTimeAccentColor"))
                        .cornerRadius(15)
                    }
                    
                }
                .padding()
                .disabled(viewModel.countdown == 0 || viewModel.delay)
                .opacity(viewModel.countdown == 0 || viewModel.delay ? 0 : 1)
                
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
                            sendPauseInfo(toPaused: viewModel.isPaused, countdownToAdjust: viewModel.countdown)

                        case "pausa", "stop":
                            viewModel.isPaused.toggle()
                            print("⏸️ VOCE: \(command) - Pausa/Stop timer")
                            if !viewModel.isPaused {
                                viewModel.riveAnimation.pauseRiveAnimation()
                                viewModel.stopTimer()

                            }
                            sendPauseInfo(toPaused: viewModel.isPaused, countdownToAdjust: viewModel.countdown)
                        
                        default:
                            
                            print("❓ Comando vocale non riconosciuto: \(command)")
                            break
                        }
                    }
                    
                    speechRecognizer.startListening()
                }
                
                if (!watchConnector.startWorkout) {
                    startWorkoutOnOtherDevice(setStart: true)
                }
                
            }
            //MARK: onChange related to the pause message sent from watchOS
            .onChange(of: watchConnector.isWorkoutPaused) {
                print("ON CHANGE IPHONE")
                viewModel.isPaused = watchConnector.isWorkoutPaused
                
                if viewModel.isPaused {
                    viewModel.startTimer()
                } else {
                    viewModel.stopTimer()
                }
            }
            .onChange(of: watchConnector.countdownToAdjust) {
                viewModel.countdown = watchConnector.countdownToAdjust
            }
            .onChange(of: watchConnector.resetView) {
                if watchConnector.resetView {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onChange(of: viewModel.countdown) { newValue in
                if newValue == 0 {
                    // Ritarda di 1 secondo la visualizzazione
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        viewModel.showAfterDelay = true
                    }
                } else {
                    // Reset nel caso di restart del timer
                    viewModel.showAfterDelay = false
                }
            }
            .onDisappear {
                startWorkoutOnOtherDevice(setStart: false)
                resetView()
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
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", countdown: 2))
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            // Using ViewModel for iPhone SE (3rd generation) preview
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", countdown: 2))
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            // Using ViewModel for iPad (11-inch) preview
            AMRAPandForTimeTimerView(viewModel: AMRAPandForTimeTimerView.ViewModel(modeTitle: "AMRAP", countdown: 2))
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}
