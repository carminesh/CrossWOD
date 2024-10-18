//
//  CustomTimePicker.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI

struct CustomTimePicker: View {
    
    let intervalType: String
    
    @Binding var selectedTime: Int
    

    // Computed property for time intervals based on intervalType
    var timeIntervals: [Int] {
        switch intervalType {
        case "AMRAP":
            return generateTimeIntervalsAMRAP()
        case "EMOM":
            return generateTimeIntervalsEMOM()
        case "SIMPLE EMOM":
            return generateTimeIntervalsSimpleEMOM(multiple: selectedTime)
        default:
            return generateTimeIntervalsAMRAP()
        }
    }

    var body: some View {
        VStack {
            // Display the currently selected time
            Text("Selected Time: \(formatTime(seconds: selectedTime))")
                .font(.headline)
                .padding()

            // Picker to select the time
            Picker("Select Time", selection: $selectedTime) {
                ForEach(timeIntervals, id: \.self) { time in
                    Text(formatTime(seconds: time)).tag(time)
                }
            }
            .labelsHidden() // Hide picker label
            .pickerStyle(WheelPickerStyle()) // Wheel style picker
            .frame(height: 150)
        }
        .padding()
    }
}


struct CustomTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomTimePicker(intervalType: "AMRAP", selectedTime: .constant(20))
    }
}
