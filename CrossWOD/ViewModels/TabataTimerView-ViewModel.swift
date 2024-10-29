//
//  TabataTimerView-ViewModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 29/10/24.
//

import Foundation


extension TabataTimerView {
    
    @Observable
    class ViewModel {
        var isPaused: Bool = true
        var currentRound: Int = 1
        var currentSeries: Int = 1
        var currentSet: Int = 1
        var timeRemaining: Int = 0 // Countdown timer
        var isResting: Bool = false
        var isSetResting: Bool = false
        var timerHasFinished = false
        var showAfterDelay: Bool = false
        var delayCountdown: Int = 3
        var delay: Bool = true
        var randomPhrase: String = ""
        
        private var timer: Timer?
        var workTime: Int
        var restTime: Int
        var numberOfSeries: Int
        var setRestTime: Int
        var setSeries: Int
        
        var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
        
        // MARK: - Initializer
        init(workTime: Int, restTime: Int, numberOfSeries: Int, setRestTime: Int, setSeries: Int) {
            self.randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
            self.workTime = workTime
            self.restTime = restTime
            self.numberOfSeries = numberOfSeries
            self.setRestTime = setRestTime
            self.setSeries = setSeries
        }
        
        // MARK: - Reset Function
        func resetTimer() {
            stopTimer() // Stop any ongoing timer
            isPaused = true // Set the timer to paused state
            currentRound = 1 // Reset current round
            currentSet = 1 // Reset current set
            currentSeries = 1 // Reset current series
            timeRemaining = 0 // Reset the remaining time
            isResting = false // Reset resting state
            isSetResting = false // Reset set resting state
            timerHasFinished = false // Reset finished state
            delay = true // Reset delay state to show the countdown
            delayCountdown = 3 // Reset the delay countdown
            riveAnimation.riveViewModel.reset()
        }
        
        var totalTime: Int {
            let totalTimePerRound = (workTime + restTime) * numberOfSeries
            return (setSeries > 1) ? (totalTimePerRound * setSeries) + (setRestTime * (setSeries - 1)) : totalTimePerRound
        }
        
        // MARK: - Timer Functions
        func startDelay() {
            delayCountdown = 3 // Reset delay countdown
            delay = true // Show the delay countdown
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.delayCountdown > 0 {
                    self.delayCountdown -= 1
                } else {
                    self.delay = false
                    timer.invalidate() // Stop the delay timer
                    self.startTimer() // Start the main countdown timer
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
                self.tick()
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
        
        func saveWorkoutHistory() {
            if timeRemaining == 0 {
                let workout = Workout(
                    type: .Tabata,
                    date: Date(),
                    performedSets: setSeries,
                    numberOfRounds: numberOfSeries,
                    roundTimes: workTime,
                    totalWorkoutTime: totalTime
                )
                
                WorkoutHistoryView.ViewModel().addWorkout(workout)
            }
           
        }
    }
    
    
}
