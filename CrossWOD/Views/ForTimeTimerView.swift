//
//  ForTimeTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 22/10/24.
//

import SwiftUI

struct ForTimeTimerView: View {
    
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    
    @State private var randomPhrase: String = ""
    @State private var isPaused: Bool = true
    var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
    
    @State var countdown: Int
    @State private var timer: Timer? = nil
    @State private var delay: Bool = true
    
    @State private var startingTime : Int = 0
    @State private var delayCountdown : Int = 3
    @State private var initialCountdown : Int = 0
    @State private var seriesTimes: [Int] = []
    @State private var showAfterDelay: Bool = false
    
    
    var body: some View {
        
        ZStack {
            
            
            Color("backgroundColor")
                  .ignoresSafeArea()
            
            riveAnimation.riveViewModel.view()
                .opacity(delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(1), value: delayCountdown)
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                
                Text("FOR TIME")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Text(delay ? "Starts in:" : "Last series in: \(formatTimeWithDecimals(seconds: seriesTimes.last ?? 0))")
                        .fontWeight(.bold)
                        .padding()
                        .opacity(!seriesTimes.isEmpty || delay ? 1 : 0)
                    
            
                    
                    if delay {
                        Text("\(delayCountdown)")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color("forTimeAccentColor"))
                    } else {
                        Text(formatTimeWithDecimals(seconds: countdown))
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .opacity(countdown == 0 ? 0 : 1)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    Spacer()
                    
                }.padding()
                
                // Delay showing this part after countdown == 0
                if countdown == 0 && showAfterDelay {
                    Text(randomPhrase)
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
                        
                        Text(formatTimeWithDecimals(seconds: startingTime))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.all, 8)
                            .padding(.trailing, 12)
                    }
                    .background(Color(red: 60/255, green: 60/255, blue: 60/255))
                    .cornerRadius(6)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                    .transition(.opacity)
                    
                
                }
                
               
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
                            Image(isPaused ? "pause_icon" : "start_icon")
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
                        .background(Color("cardBackgroundColor"))
                        .cornerRadius(15)
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
                        .background(Color("forTimeAccentColor"))
                        .cornerRadius(15)
                    }
                    
                }
                .disabled(countdown == 0 || delay)
                .opacity(countdown == 0 || delay ? 0 : 1)
                .padding(.bottom, 40)
            }
            .onAppear {
                randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
                startingTime = countdown
                initialCountdown = countdown
                startDelay()
            }
            .onChange(of: countdown) {
                if countdown == 0 {
                    // Add a delay before showing the text
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showAfterDelay = true
                        }
                    }
                }
            }
            .onDisappear {
                riveAnimation.riveViewModel.reset()
                stopTimer()
                if(countdown == 0) {
                    saveWorkoutHistory()
                }
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
        riveAnimation.startRiveAnimation()

        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare() // Prepare the generator
            generator.impactOccurred() // Trigger the feedback
            
            if isPaused && countdown > 0 {
                countdown -= 1
            }
            
            if countdown == 0 {
                timer?.invalidate()
                timer = nil
                riveAnimation.stopRiveAnimation()
            }
        }
    }
    
    private func stopTimer() {
        riveAnimation.pauseRiveAnimation()
        timer?.invalidate()
        timer = nil
    }
    
    private func lastSeriesTime() {
        let seriesTime = initialCountdown - countdown
        seriesTimes.append(seriesTime)
        initialCountdown -= seriesTime
    }
    

    
    private func saveWorkoutHistory() {
        let workout = Workout(
            type: .ForTime,
            date: Date(),
            initialCountdown: startingTime,
            seriesPerformed: seriesTimes.count,
            seriesTimes: seriesTimes
        )
        
        workoutHistoryManager.addWorkout(workout)
    }
    
    
}





struct ForTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ForTimeTimerView(countdown: 5)
    }
}

