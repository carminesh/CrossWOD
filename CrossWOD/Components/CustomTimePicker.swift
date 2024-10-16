//
//  CustomTimePicker.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 14/10/24.
//

import SwiftUI

struct CustomTimePicker: View {
    // Intervalli di tempo personalizzati
    let timeIntervals: [Int] = generateTimeIntervals()

    @Binding var selectedTime: Int

    var body: some View {
        VStack {
            // Visualizza il tempo attualmente selezionato
            Text("Selected Time: \(formatTime(seconds: selectedTime))")
                .font(.headline)
                .padding()

            // Picker per selezionare il tempo
            Picker("Select Time", selection: $selectedTime) {
                ForEach(timeIntervals, id: \.self) { time in
                    Text(formatTime(seconds: time)).tag(time)
                }
            }
            .labelsHidden() // Nascondi l'etichetta del picker
            .pickerStyle(WheelPickerStyle()) // Stile a ruota
            .frame(height: 150)
        }
        .padding()
    }

    
    
}


struct CustomTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomTimePicker(selectedTime: .constant(20)) // Use .constant to simulate a binding in the preview
    }
}
