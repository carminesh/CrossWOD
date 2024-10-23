//
//  EMOMTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 17/10/24.
//

import SwiftUI

struct EMOMTimerView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    
    
    let everyTime: Int // Time interval (e.g. every minute)
    let forTime: Int // Number of rounds before rest
    let numberOfSeries: Int // Total sets to be performed
    let restTime: Int // Rest time between series
    
    @State private var isPaused: Bool = true
    
    @State private var currentRound: Int = 1
    @State private var currentSeries: Int = 1
    @State private var timeRemaining: Int = 0 // Countdown timer
    @State private var isResting: Bool = false
    @State private var timer: Timer?
    @State private var delayCountdown : Int = 3
    
    @State private var delay: Bool = true
    @State private var randomPhrase: String = ""
    @State private var timerHasFinished = false
    
    @State private var showAfterDelay: Bool = false
    
    var totalTime: Int {
        let totalTimePerRound = forTime
        
        if numberOfSeries > 1 {
            return (totalTimePerRound * numberOfSeries) + (restTime * (numberOfSeries > 1 ? numberOfSeries - 1 : numberOfSeries ))
        }
        
        return totalTimePerRound
    }
    
    var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
    
    var body: some View {
        
        
        ZStack {
            
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)

            
            riveAnimation.riveViewModel.view()
                .frame(maxWidth: .infinity)
                .opacity(delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(1), value: delayCountdown)
                .ignoresSafeArea()

            
            VStack {
                
                
                Text("EMOM")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                
                Text("Set: \(currentSeries)/\(numberOfSeries)")
                    .font(.title3)
                    .opacity(timerHasFinished ? 0 : 1)
                    .padding(.top, 4)
                
                Text(isResting ? "Rest Time" : "Round: \(currentRound)/\(formatTimeToNumberOnly(seconds: forTime))")
                    .font(.title3)
                    .opacity(timerHasFinished ? 0 : 1)
                    .padding()
            
    
                
                VStack {
                
                    
                    
                    
                    Text("Starts in:")
                        .fontWeight(.bold)
                        .padding()
                        .opacity(delay ? 1 : 0)
                    
                    
                    
                    // Show the remaining time section
                    if delay {
                        Text("\(delayCountdown)")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color("emomAccentColor"))
                    } else {
                        Text(formatTimeWithDecimals(seconds: timeRemaining))
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .opacity(timeRemaining == 0 ? 0 : 1)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    
                }.padding()
                
               
                
                
                if currentSeries == 0 && currentRound == 0  && !isResting && showAfterDelay{
                    
                    Spacer()

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
                        
                        Text(formatTimeWithDecimals(seconds: totalTime))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.all, 8)
                            .padding(.trailing, 12)
                    }
                    .background(Color("cardBackgroundColor"))
                    .cornerRadius(15)
                    
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isPaused.toggle()
                        if isPaused {
                            startTimer()
                        } else {
                            riveAnimation.pauseRiveAnimation()
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
                        .background(Color("cardBackgroundColor"))
                        .cornerRadius(10)
                    }
                    .animation(.easeInOut(duration: 1), value: isPaused)
                    
                    
                }
                .disabled(timeRemaining == 0 || delay)
                .opacity(timeRemaining == 0 || delay ? 0 : 1)
                .padding(.bottom, 40)
                
                
            }.onAppear {
                startDelay()
                randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
            }
            .onChange(of: currentSeries) {
                if currentSeries == 0 && !isResting && currentRound == 0 {
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
                if timeRemaining == 0 {
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
    
    func startTimer() {
        riveAnimation.pauseRiveAnimation()
        stopTimer() // Stop any existing timer
        
        riveAnimation.startRiveAnimation()
        // Set the initial timeRemaining based on the current state
        if !isResting {
            
            
            if timeRemaining == 0 {
                // If timeRemaining is zero, start with everyTime
                timeRemaining = everyTime // Start the timer for the exercise interval
            }
        } else {
            if timeRemaining == 0 {
                // If in resting state and timeRemaining is zero, start with restTime
                timeRemaining = restTime // Start the timer for the rest period
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare() // Prepare the generator
            generator.impactOccurred() // Trigger the feedback
            tick()
        }
    }
    
    // Stop the timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // timeRemaining tick
    func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            
        } else {
            handleNextRoundOrRest()
        }
    }
    
    func handleNextRoundOrRest() {
        if isResting {
            currentSeries += 1 // Go to the next series
            isResting = false // Stop resting
            
            if currentSeries <= numberOfSeries {
                startTimer() // Start the new series
            } else {
                riveAnimation.stopRiveAnimation()
                stopTimer()
            }
        } else {
            currentRound += 1
            if currentRound > Int(formatTimeToNumberOnly(seconds: forTime))! { // Completed all rounds in the current series
                if currentSeries < numberOfSeries {
                    isResting = true
                    currentRound = 1
                    startTimer()
                } else {
                    currentSeries = 0
                    currentRound = 0
                    timerHasFinished = true
                    stopTimer()
                    riveAnimation.stopRiveAnimation()
                }
            } else {
                startTimer() // Start the next round
            }
        }
    }
    
    private func saveWorkoutHistory() {
        let workout = Workout(
            type: .Emom,
            date: Date(),
            performedSets: numberOfSeries,
            numberOfRounds: forTime,
            roundTimes: everyTime,
            totalWorkoutTime: totalTime
        )
        
        workoutHistoryManager.addWorkout(workout)
    }
    
    
}

#Preview {
    EMOMTimerView(everyTime: 60, forTime: 60, numberOfSeries: 1, restTime: 20)
}
