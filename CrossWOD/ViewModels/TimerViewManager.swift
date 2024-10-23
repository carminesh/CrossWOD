//
//  TimerViewManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 17/10/24.
//

import Foundation

import Combine

class TimerViewManager: ObservableObject {
    @Published var countdown: Int
    @Published var delayCountdown: Int = 3
    @Published var isPaused: Bool = true
    @Published var delay: Bool = true
    @Published var randomPhrase: String = ""
    @Published var seriesTimes: [Int] = []
    
    private var timer: Timer? = nil
    private var initialCountdown: Int
    private var startingTime: Int
    private var workoutHistoryManager: WorkoutHistoryManager
    private var riveAnimation: RiveAnimationManager
    private var workoutType: String
    
    init(countdown: Int, workoutHistoryManager: WorkoutHistoryManager, riveAnimation: RiveAnimationManager, workoutType: String) {
        self.countdown = countdown
        self.initialCountdown = countdown
        self.startingTime = countdown
        self.workoutHistoryManager = workoutHistoryManager
        self.riveAnimation = riveAnimation
        self.workoutType = workoutType
        randomPhrase = Constants.motivationalPhrases.randomElement() ?? "Great job!"
    }
    
    func startDelay() {
        delayCountdown = 3
        delay = true
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.delayCountdown > 0 {
                self.delayCountdown -= 1
            } else {
                self.delay = false
                timer.invalidate()
                self.startTimer()
            }
        }
    }
    
    func startTimer() {
        riveAnimation.startRiveAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.isPaused && self.countdown > 0 {
                self.countdown -= 1
            }
            
            if self.countdown == 0 {
                self.riveAnimation.stopRiveAnimation()
            }
        }
    }
    
    func stopTimer() {
        riveAnimation.pauseRiveAnimation()
        timer?.invalidate()
        timer = nil
    }
    
    func togglePause() {
        isPaused.toggle()
        if isPaused {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func recordLastSeries() {
        let seriesTime = initialCountdown - countdown
        seriesTimes.append(seriesTime)
        initialCountdown -= seriesTime
    }
    
    func saveWorkoutHistory() {
        let workoutEnumType: WorkoutType
        
        switch workoutType.lowercased() {
        case "Amrap":
            workoutEnumType = .Amrap
        case "Emom":
            workoutEnumType = .Emom
        case "ForTime":
            workoutEnumType = .ForTime
        case "Tabata":
            workoutEnumType = .Tabata
        default:
            workoutEnumType = .Amrap
        }
        
        let workout = Workout(
            type: workoutEnumType,
            date: Date(),
            initialCountdown: startingTime,
            seriesPerformed: seriesTimes.count,
            seriesTimes: seriesTimes
        )
        workoutHistoryManager.addWorkout(workout)
    }
}
