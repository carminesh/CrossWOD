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
        
  
        switch workoutType {
        case "Amrap":
            return Color("amrapAccentColor")
        case "Emom":
            return Color("emomAccentColor")
        case "ForTime":
            return Color("forTimeAccentColor")
        case "Tabata":
            return Color("tabataAccentColor")
        default:
            return Color.gray
        }
    }
    
    // Method to return different shapes based on workout type
    func shape() -> AnyView {
        switch workoutType {
        case "Amrap":
            return AnyView(
                Circle()
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        case "Emom":
            return AnyView(
                Hexagon()
                    .fill(color)
                    .frame(width: 17, height: 18)
            )
        case "ForTime":
            return AnyView(
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        case "Tabata":
            return AnyView(
                Triangle()
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        default:
            return AnyView(
                Circle()
                    .fill(Color.gray)
                    .frame(width: 18, height: 18)
            )
        }
    }
}
