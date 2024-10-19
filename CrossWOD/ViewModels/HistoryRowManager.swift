//
//  HistoryRowManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import SwiftUICore


class HistoryRowViewModel: ObservableObject {
    let workoutType: String
    
    init(workoutType: String) {
        self.workoutType = workoutType
    }
    
    var color: Color {
        switch workoutType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "amrap":
            return Color(red: 247/255, green: 79/255, blue: 51/255)
        case "emom":
            return Color.green
        case "for time":
            return Color.red
        case "tabata":
            return Color.purple
        default:
            return Color.gray
        }
    }
}
