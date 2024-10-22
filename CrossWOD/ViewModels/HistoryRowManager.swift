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
            return Color("amrapAccentColor")
        case "emom":
            return Color("emomAccentColor")
        case "for time":
            return Color("fortimeAccentColor")
        case "tabata":
            return Color("tabataAccentColor")
        default:
            return Color.gray
        }
    }
    
    // Method to return different shapes based on workout type
    func shape() -> AnyView {
        switch workoutType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "amrap":
            return AnyView(
                Circle()
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        case "emom":
            return AnyView(
                Hexagon()
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        case "for time":
            return AnyView(
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 18, height: 18)
            )
        case "tabata":
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
