//
//  AMRAPTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI
import RiveRuntime

struct ARMAPTimerView: View {
    
    let phrases = [
        "Congrats, you survived! Now, breathe... if you can!",
        "Time’s up! Who needs legs tomorrow, right?",
        "Well done! Your muscles will thank you... later, much later.",
        "That’s it! You just won the ‘Out of Breath’ championship!",
        "Great job! Now go hydrate, you earned it... and maybe a nap.",
        "Boom! Time’s up. Now, crawling counts as cardio!",
        "Workout complete! You’ve officially earned your sweat badge.",
        "You did it! If you’re not wobbling, did you even AMRAP?",
        "Finished! And now for the recovery... a week-long Netflix marathon?",
        "Done! Feel that? That’s your body filing a formal complaint."
    ]
    
    
    @State private var randomPhrase: String = ""
    @Binding var showModal: Bool
    @State private var isPaused: Bool = true
    @StateObject private var riveViewModel = RiveViewModel(fileName: "AMRAP_animation", stateMachineName: "AMRAP_machine")
    
    @State var countdown: Int
    @State private var timer: Timer? = nil
    @State private var delay: Bool = true
    
    @State private var startingTime : Int = 0
    @State private var delayCountdown : Int = 3
    @State private var initialCountdown : Int = 0
    @State private var seriesTime : Int = 0
    
    
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                
               
                
                Text("AMRAP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                riveViewModel.view()
                    .frame(width: 370, height: 370)
                    .opacity(delay ? 0.6 : 1)
                    .clipShape(Circle())
                    .padding()
                
                
                
                VStack {
                    
                    if countdown == 0 {
                        Text(randomPhrase)
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
                                .padding(.all, 8)
                                .padding(.leading, 12)
                            
                            Text(formatTime(seconds: startingTime))
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.all, 8)
                                .padding(.trailing, 12)
                        }
                        .background(Color(red: 60/255, green: 60/255, blue: 60/255))
                        .cornerRadius(6)
                        .padding()
                        
                    } else {
                        Text(delay ? "Starts in:" : "Last series in: \(formatTime(seconds: seriesTime))")
                            .fontWeight(.bold)
                            .padding()
                            .opacity(seriesTime != 0 || delay ? 1 : 0)
                    }
                    
                    
                    
                    
                    // Show the remaining time section
                    
                    if delay {
                        Text("\(delayCountdown)")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 247/255, green: 79/255, blue: 51/255))
                    } else {
                        Text(formatTime(seconds: countdown))
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .opacity(countdown == 0 ? 0 : 1)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    
                }
                .frame(height: 130)
                
                
                Spacer()
                
                
                HStack {
                    Button(action: {
                        isPaused.toggle()
                        if isPaused {
                            startTimer()
                        } else {
                            stopTimer()
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(isPaused ? "pause_icon" : "start_icon" )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .padding(.leading, 50)
                            
                            Text(isPaused ? "PAUSE" : "START")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.trailing, 50)
                        }
                        .padding(.vertical, 20)
                        .background(Color(red: 60/255, green: 60/255, blue: 60/255))
                        .cornerRadius(10)
                    }
                    .animation(.easeInOut(duration: 1), value: isPaused)
                    
                    Button(action: {
                        lastSeriesTime()
                    }) {
                        HStack(spacing: 10) {
                            Image("add_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(.horizontal, 20)
                            
                        }
                        .padding(.vertical, 20)
                        .background(Color(red: 247/255, green: 79/255, blue: 51/255))
                        .cornerRadius(10)
                    }
                    
                }
                .disabled(countdown == 0 || delay)
                .opacity(countdown == 0 || delay ? 0 : 1)
                .padding(.bottom, 40)
                
                
                
                
            }
            .onAppear {
                randomPhrase = phrases.randomElement() ?? "Great job!"
                startingTime = countdown
                initialCountdown = countdown
                startDelay()
            }
        }
        
    }
    
    private func startDelay() {
        delayCountdown = 3 // Reset delay countdown
        delay = true // Show the delay countdown
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if delayCountdown > 0 {
                delayCountdown -= 1
            } else {
                delay = false
                timer.invalidate() // Stop the delay timer
                startTimer() // Start the main countdown timer
            }
        }
    }
    
    private func startTimer() {
        startRiveAnimation()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isPaused && countdown > 0 {
                countdown -= 1
            }
            
            if countdown == 0 {
                stopRiveAnimation()
            }
        }
    }
    
    private func lastSeriesTime() {
        seriesTime = initialCountdown - countdown
        initialCountdown -= seriesTime
    }
    
    
    private func stopTimer() {
        pauseRiveAnimation()
        timer?.invalidate()
        timer = nil
    }
    
    
    private func startRiveAnimation() {
        riveViewModel.setInput("isStarted", value: true)
        riveViewModel.setInput("endAnimation", value: false)
        
    }
    
    private func pauseRiveAnimation() {
        riveViewModel.setInput("isStarted", value: false)
        riveViewModel.setInput("endAnimation", value: false)
    }
    
    private func stopRiveAnimation() {
        riveViewModel.setInput("isStarted", value: false)
        riveViewModel.setInput("endAnimation", value: true)
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let  remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct ARMAPTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ARMAPTimerView(showModal: .constant(true), countdown: 5)
    }
}


