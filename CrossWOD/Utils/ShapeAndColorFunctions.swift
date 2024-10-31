//
//  ShapeAndColorFunctions.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 28/10/24.
//


import SwiftUI


// Function to get color based on workout type
func workoutColor(for workoutType: String) -> Color {
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

// Function to get shape based on workout type
func workoutShape(for workoutType: String) -> AnyView {
    let color = workoutColor(for: workoutType) // Get color for the shape
    
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


