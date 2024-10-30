//
//  AMRAPandForTime-ViewModel.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 28/10/24.
//

import Foundation
import SwiftUICore


extension AMRAPandForTimeTimerView {
    
    @Observable
    class ViewModel {        
        var riveAnimation = RiveAnimationManager(fileName: "countdown_animation", stateMachineName: "AnimatedCountdown")
        
        var countdown: Int
        var isPaused: Bool = true
        var delayCountdown: Int = 3
        var seriesTimes: [Int] = []
        
        var randomPhrase: String = ""
        var showAfterDelay: Bool = false
        
        var timer: Timer? = nil
        var initialCountdown: Int // this one is used for recording the last series time
        var startingTime: Int
        var modeTitle: String

        
        var delay: Bool = true
        
        // Store the original countdown value
        private var originalCountdown: Int
        
        
        // MARK: Init function
        init(modeTitle: String, countdown: Int) {
            self.modeTitle = modeTitle
            self.countdown = countdown
            self.originalCountdown = countdown
            self.startingTime = countdown
            self.initialCountdown = countdown
            self.randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
        }
        
        // MARK: Reset countdown and related properties
        func resetCountdown() {
            countdown = originalCountdown
            initialCountdown = originalCountdown
            delayCountdown = 3
            isPaused = true
            showAfterDelay = false
            seriesTimes.removeAll()
            timer?.invalidate() // Stop any active timers
            timer = nil
            riveAnimation.riveViewModel.reset() // Reset the animation
        }
        
        
        // MARK: Function related to the workout model
        
        func saveWorkoutHistory() {
            if countdown == 0 {
                let workout = Workout(
                    type: modeTitle == "AMRAP" ? .Amrap : .ForTime,
                    date: Date(),
                    initialCountdown: startingTime,
                    seriesPerformed: seriesTimes.count,
                    seriesTimes: seriesTimes
                )
                
                WorkoutHistoryView.ViewModel().addWorkout(workout)
            }
            
        }
        
        
        
        
        // MARK: Section related to the timer and animation management
        func startDelay() {
            delayCountdown = 3 // Reset delay countdown
            delay = true
            
            // Store the timer reference
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                if self.delayCountdown > 0 {
                    self.delayCountdown -= 1
                } else {
                    self.delay = false
                    timer.invalidate()
                    self.timer = nil
                    self.startTimer()
                }
            }
        }
        
        
        func startTimer() {
            riveAnimation.startRiveAnimation()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                
                if self.isPaused && self.countdown > 0 {
                    self.countdown -= 1
                }
                
                if self.countdown == 0 {
                    timer.invalidate() // Stop the delay timer
                    self.timer = nil
                    self.riveAnimation.stopRiveAnimation()
                }
            }
            
            
        }
        
        
        func stopTimer() {
            riveAnimation.pauseRiveAnimation()
            timer?.invalidate()
            timer = nil
        }
        
        
        func recordLastSeriesTime() {
            let seriesTime = initialCountdown - countdown
            seriesTimes.append(seriesTime)
            initialCountdown -= seriesTime
        }
        
        
        
    }
    
}
