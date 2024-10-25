//
//  EMOMTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 17/10/24.
//

import SwiftUI

struct EMOMTimerView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()
    
    let workTime: Int // Work time for each round
    let forTime: Int // Total time per round
    let restTime: Int = 0 // Rest time between rounds
    let setRestTime: Int // Rest time between sets
    let setSeries: Int // Number of sets
    
    @State private var isPaused: Bool = true
    @State private var currentRound: Int = 1
    @State private var currentSeries: Int = 1
    @State private var currentSet: Int = 1
    @State private var timeRemaining: Int = 0 // Countdown timer
    @State private var isResting: Bool = false
    @State private var isSetResting: Bool = false
    @State private var timer: Timer?
    @State private var delayCountdown: Int = 3
    
    @State private var delay: Bool = true
    @State private var randomPhrase: String = ""
    @State private var timerHasFinished = false
    @State private var showAfterDelay: Bool = false
    
    var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
    
    
    var totalTime: Int {
        let totalTimePerRound = (workTime + restTime) * numberOfSeries
        
        if setSeries > 1 {
            return (totalTimePerRound * setSeries) + (setRestTime * (setRestTime > 1 ? setSeries - 1 : setSeries ))
        }
        
        return totalTimePerRound
    }
    
    var numberOfSeries: Int {
        return forTime / workTime
    }
    
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
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                
                HStack(spacing: 20) {
                    
                    if setSeries > 1 {
                        InfoIndicator(text: "Set: \(currentSet)/\(setSeries)", accentColor: Color("emomAccentColor"), number: currentSet, outOF: setSeries, timerHasFinished: timerHasFinished)
                    }
                    
                    
                    if numberOfSeries > 1 {
                        InfoIndicator(text: "Round: \(currentRound)/\(numberOfSeries)", accentColor: Color("emomAccentColor"), number: currentRound, outOF: numberOfSeries, timerHasFinished: timerHasFinished)
                    }
                    
                    
                    
                }.padding(.horizontal, 10)
                
                Spacer()
                    .frame(height: 70)
                
                VStack {
                    
                    if !isResting {
                        Text("STARTS IN:")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .opacity(delay ? 1 : 0)
                    } else if isResting && !timerHasFinished && restTime > 0 {
                        Text("REST")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("emomAccentColor"))
                            .padding()
                            .animation(.easeInOut, value: isResting)
                    }
                    
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
                
                if timerHasFinished && showAfterDelay {
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
                    .cornerRadius(12)
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
                        .cornerRadius(10)
                    }
                    .animation(.easeInOut(duration: 1), value: isPaused)
                }
                .disabled(timeRemaining == 0 || delay)
                .opacity(timeRemaining == 0 || delay ? 0 : 1)
                .padding(.bottom, 40)
            }
            .onAppear {
                startDelay()
                randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
            }
            .onChange(of: timerHasFinished) {
                if timerHasFinished {
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
        stopTimer()
        
        riveAnimation.startRiveAnimation()
        
        // Set the initial timeRemaining only if the timer hasn't started (i.e., timeRemaining is zero)
        if timeRemaining == 0 {
            // Determine the timer for work/rest/set rest based on the state
            if !isResting && !isSetResting {
                timeRemaining = workTime
            } else if isResting && !isSetResting {
                timeRemaining = restTime
            } else if isSetResting {
                timeRemaining = setRestTime
                
            }
        }
        
        // Schedule the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            tick()
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            handleNextRoundOrRest()
        }
    }
    
    func handleNextRoundOrRest() {
        if isSetResting {
            // Set rest completed, prepare for the next set
            if currentSet < setSeries {
                currentSet += 1
                currentRound = 1 // Reset rounds for the new set
                isSetResting = false
                isResting = false // Ensure work time starts for the new set
                timeRemaining = workTime // Reset to work time
                startTimer() // Start work time for the new set
            } else {
                // All sets finished
                timerHasFinished = true
                stopTimer()
                riveAnimation.stopRiveAnimation()
            }
        } else if isResting {
            // Rest between rounds completed
            if currentRound < numberOfSeries {
                // Start next round
                currentRound += 1 // Increment currentRound
                // Next round, start work time
                isResting = false
                timeRemaining = workTime // Reset to work time for the next round
                startTimer() // Start work time for the next round
            } else {
                // All rounds in the current set are done
                if currentSet < setSeries {
                    // Move to next set rest
                    isSetResting = true // Start set rest
                    timeRemaining = setRestTime // Set time for the set rest
                    startTimer() // Start set rest time
                } else {
                    // If it is the last set, finish the workout
                    timerHasFinished = true
                    stopTimer()
                    riveAnimation.stopRiveAnimation()
                }
            }
        } else {
            // Work round completed, start rest time
            isResting = true
            timeRemaining = restTime // Set time for rest
            startTimer() // Start rest time
        }
    }
    
    private func saveWorkoutHistory() {
        let workout = Workout(
            type: .Emom,
            date: Date(),
            performedSets: setSeries,
            numberOfRounds: numberOfSeries,
            roundTimes: workTime,
            totalWorkoutTime: totalTime
        )
        workoutHistoryManager.addWorkout(workout)
    }

    
}

#Preview {
    EMOMTimerView(workTime: 60, forTime: 60, setRestTime: 10, setSeries: 1)
}
