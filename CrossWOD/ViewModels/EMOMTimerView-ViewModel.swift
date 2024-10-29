//
//  EMOMTimerView-ViewModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 29/10/24.
//

import Foundation



extension EMOMTimerView {
    
    @Observable
    class ViewModel {
        // Input parameters
        let workTime: Int
        let forTime: Int
        let restTime: Int
        let setRestTime: Int
        let setSeries: Int
        
        // State properties
        var isPaused: Bool = true
        var currentRound: Int = 1
        var currentSet: Int = 1
        var timeRemaining: Int = 0 // Countdown timer
        var isResting: Bool = false
        var isSetResting: Bool = false
        var timerHasFinished = false
        var showAfterDelay: Bool = false
        
        var timer: Timer?
        var delayCountdown: Int = 3
        var delay: Bool = true
        var randomPhrase: String = ""
        
        var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
        
        var totalTime: Int {
            if setSeries > 1 {
                return (forTime * setSeries) + (setRestTime * (setRestTime > 1 ? setSeries - 1 : setSeries))
            }
            return forTime
        }
        
        var numberOfSeries: Int {
            return forTime / workTime
        }
        
        // MARK: - Initializer
        
        init(workTime: Int, forTime: Int, setRestTime: Int, setSeries: Int) {
            self.workTime = workTime
            self.forTime = forTime
            self.setRestTime = setRestTime
            self.setSeries = setSeries
            self.restTime = 0
            
            randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
        }
        
        // MARK: - Reset fuction
        
        func reset() {
            stopTimer() // Stop any ongoing timer
            isPaused = true
            currentRound = 1
            currentSet = 1
            timeRemaining = 0
            isResting = false
            isSetResting = false
            timerHasFinished = false
            showAfterDelay = false
            stopTimer()
            delay = true
            delayCountdown = 3 // Reset delay countdown
            riveAnimation.riveViewModel.reset()
        }
        
        

        // MARK: - Timing functions
        
        func startDelay() {
            delayCountdown = 3 // Reset delay countdown
            delay = true // Show the delay countdown
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.delayCountdown > 0 {
                    self.delayCountdown -= 1
                } else {
                    self.delay = false
                    timer.invalidate() // Stop the delay timer
                    self.startTimer()
                }
            }
        }
        
        
        func startTimer() {
            stopTimer()
            riveAnimation.startRiveAnimation()
            
            // Set the initial timeRemaining only if the timer hasn't started (i.e., timeRemaining is zero)
            if timeRemaining == 0 {
                timeRemaining = isResting || isSetResting ? (isResting ? restTime : setRestTime) : workTime
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
                }
            } else if isResting {
                if currentRound < numberOfSeries {
                    currentRound += 1 // Increment currentRound
                    isResting = false
                    timeRemaining = workTime // Reset to work time for the next round
                    startTimer()
                } else {
                    if currentSet < setSeries {
                        isSetResting = true // Start set rest
                        timeRemaining = setRestTime // Set time for the set rest
                        startTimer() // Start set rest time
                    } else {
                        timerHasFinished = true
                        riveAnimation.stopRiveAnimation()
                        stopTimer()

                        
                    }
                }
            } else {
                isResting = true
                timeRemaining = restTime // Set time for rest
                startTimer() // Start rest time
            }
        }
        
        func saveWorkoutHistory() {
            if timeRemaining == 0 {
                let workout = Workout(
                    type: .Emom,
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


