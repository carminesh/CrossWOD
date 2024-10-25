//
//  AMRAPandForTimeTimerView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct AMRAPandForTimeTimerView: View {
   
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
    
    var modeTitle: String
    var accentColor: Color
    
  
    
    var body: some View {
        
        ZStack {
            
            
            Color("backgroundColor")
                .ignoresSafeArea()
            
            riveAnimation.riveViewModel.view()
                .frame(maxWidth: .infinity)
                .opacity(delayCountdown == 0 ? 1 : 0)
                .animation(.easeInOut.delay(0.2), value: delayCountdown)
                .ignoresSafeArea()
            
            VStack {
                
                Text(modeTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
            
                
                
                // MARK: COUNTDOWN section
                VStack(alignment: .center) {
                    
                    
                    Text("Last series in: \(formatTimeWithDecimals(seconds: seriesTimes.last ?? 0))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(!seriesTimes.isEmpty ? 1 : 0)
                    
                    
                    
                    GeometryReader { geometry in
                        if delay {
                            
                            VStack() {
                                
                                Text("STARTS IN:")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(delay ? 1 : 0)
                                    .padding(.bottom, 20)
                                
                                Text("\(delayCountdown)")
                                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.2))
                                    .fontWeight(.bold)
                                    .foregroundColor(accentColor)
                                
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            
                        
                            
                        } else {
                            
                            Text(formatTimeWithDecimals(seconds: countdown))
                                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.18))
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .fontWeight(.bold)
                                .opacity(countdown == 0 ? 0 : 1)
                                .foregroundColor(.white)
                              
            
                        }
                        
                    }
                    
                }
                .padding()
                .padding(.bottom, 80)
                
                
                // Delay showing this part after countdown == 0
                if countdown == 0 && showAfterDelay {
                    VStack {
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
                                .padding(10)

                            
                            Text(formatTimeWithDecimals(seconds: startingTime))
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(10)
                                
                        }
                        .background(Color("cardBackgroundColor"))
                        .cornerRadius(12)
                        .transition(.opacity)
                        
                    }
                    .padding()
                    
                }
            
                Spacer()
            
                
            
                // MARK: BUTTON section
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
                                .frame(width: 19, height: 19)
                                .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                        .background(Color(accentColor))
                        .cornerRadius(15)
                    }
                    
                }
                .padding()
                .disabled(countdown == 0 || delay)
                .opacity(countdown == 0 || delay ? 0 : 1)
                
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
            type: modeTitle == "AMRAP" ? .Amrap : .ForTime,
            date: Date(),
            initialCountdown: startingTime,
            seriesPerformed: seriesTimes.count,
            seriesTimes: seriesTimes
        )
        
        workoutHistoryManager.addWorkout(workout)
    }
    
    
}

    

struct AMRAPandForTimeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AMRAPandForTimeTimerView(countdown: 10, modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"))
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            AMRAPandForTimeTimerView(countdown: 10, modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"))
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            AMRAPandForTimeTimerView(countdown: 10, modeTitle: "AMRAP", accentColor: Color("amrapAccentColor"))
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}
