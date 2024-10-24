//
//  TabataTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct TabataTimerView: View {
    @ObservedObject var workoutHistoryManager = WorkoutHistoryManager()

    let workTime: Int // Work time for each round
    let restTime: Int // Rest time between rounds
    let numberOfSeries: Int // Total series to be performed
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
                Text("TABATA")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()

                HStack(spacing: 20) {
                   
                    if setSeries > 1 {
                        InfoIndicator(text: "Set: \(currentSet)/\(setSeries)", accentColor: Color("tabataAccentColor"), number: currentSet, outOF: setSeries, timerHasFinished: timerHasFinished)
                    }
                   
                    
                    if numberOfSeries > 1 {
                        InfoIndicator(text: "Round: \(currentSeries)/\(numberOfSeries)", accentColor: Color("tabataAccentColor"), number: currentSeries, outOF: numberOfSeries, timerHasFinished: timerHasFinished)
                    }
                  
                    
                    
                    
                }.padding(.horizontal, 10)

                if isResting {
                    Text("Rest Time")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(timerHasFinished ? 0 : 1)
                        .padding()
                }
               

                VStack {
                    Text("Starts in:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .opacity(delay ? 1 : 0)

                    if delay {
                        Text("\(delayCountdown)")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color("tabataAccentColor"))
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
            // Set rest completed, go to next set
            currentSet += 1
            if currentSet > setSeries {
                timerHasFinished = true
                stopTimer()
                riveAnimation.stopRiveAnimation()
            } else {
                currentSeries = 1
                currentRound = 1
                isSetResting = false
                startTimer()
            }
        } else if isResting {
            // Rest between rounds completed, start next round or series
            currentSeries += 1
            if currentSeries > numberOfSeries {
                // All series done, move to set rest or end timer
                if currentSet < setSeries {
                    isSetResting = true
                    startTimer()
                } else {
                    timerHasFinished = true
                    stopTimer()
                    riveAnimation.stopRiveAnimation()
                }
            } else {
                isResting = false
                startTimer() // Start next work round
            }
        } else {
            // Work round completed, start rest or next round
            currentRound += 1
            if currentRound > numberOfSeries {
                isResting = true
                startTimer()
            } else {
                isResting = true
                startTimer() // Start rest time
            }
        }
    }

    private func saveWorkoutHistory() {
        let workout = Workout(
            type: .Tabata,
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
    TabataTimerView(workTime: 10, restTime: 5, numberOfSeries: 2, setRestTime: 10, setSeries: 1)
}
