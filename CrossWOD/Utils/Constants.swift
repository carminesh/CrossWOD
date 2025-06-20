//
//  Constants.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import SwiftUI


struct Constants {
    
    @State var userIsPro : Bool = false
    
    static func getWorkouts(userIsPro: Bool) -> [(title: String, icon: String, modeDescription: String, destination: AnyView)] {
        return [
            (title: "AMRAP", icon: "amrap_card", modeDescription: "As many rounds as possible", destination: AnyView(AMRAPandForTimeConfigView(modeTitle: "AMRAP", modeDescription: "As many rounds as possible", timePickerDescription: "Complete as many rounds as possible in:", selectedTime: 10))),
            (title: "EMOM", icon: "emom_card", modeDescription: "Every minute on the minute", destination: AnyView(EMOMConfigView())),
            (title: "FOR TIME", icon: "for_time_card", modeDescription: "Workout as fast as possible", destination: AnyView(AMRAPandForTimeConfigView(modeTitle: "FOR TIME", modeDescription: "Workout as fast as possible", timePickerDescription: "Finish the workout as fast as possible in:", selectedTime: 10))),
            (title: "TABATA", icon: "tabata_card", modeDescription: "Intense work followed by rest", destination: AnyView(TabataConfigView())),
            //(title: "BENCHMARK", icon: userIsPro ? "benchmark_card" : "benchmark_premium_card", modeDescription: "CrossFit Benchmark WODs", destination: AnyView(BenchmarkConfigView()))
        ]
    }
    
    static let motivationalPhrases = [
        "Congrats, you survived! Now, breathe... if you can!",
        "Time’s up! Who needs legs tomorrow, right?",
        "Well done! Your muscles will thank you... later, much later.",
        "That’s it! You just won the ‘Out of Breath’ championship!",
        "Great job! Now go hydrate, you earned it... and maybe a nap.",
        "Boom! Time’s up. Now, crawling counts as cardio!",
        "Workout complete! You’ve officially earned your sweat badge.",
        //"You did it! If you’re not wobbling, did you even AMRAP?",
        "Finished! And now for the recovery... a week-long Netflix marathon?",
        "Done! Feel that? That’s your body filing a formal complaint."
    ]		
}
