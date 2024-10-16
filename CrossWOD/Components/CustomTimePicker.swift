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

    // Formatta il tempo da secondi a stringa leggibile
    func formatTime(seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds) seconds"
        } else if seconds == 60 {
            return "1 minute"
        } else if seconds % 60 == 0 {
            return "\(seconds / 60) minutes"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return String(format: "%d:%02d minutes", minutes, remainingSeconds)
        }
    }
     
    // Funzione statica per generare gli intervalli di tempo
    static func generateTimeIntervals() -> [Int] {
        var intervals: [Int] = []

        // Da 20 a 60 secondi (incremento di 5 secondi)
        intervals.append(contentsOf: stride(from: 10, through: 60, by: 5))

        // Da  1:00 a 3:00 minuti (incremento di 15 secondi)
        intervals.append(contentsOf: stride(from: 75, through: 180, by: 15))

        // Da 3:30 a 5:00 minuti (incremento di 30 secondi)
        intervals.append(contentsOf: stride(from: 210, through: 300, by: 30))

        // Da 6 a 90 minuti (incremento di 1 minuto)
        intervals.append(contentsOf: stride(from: 360, through: 5400, by: 60))

        return intervals
    }
}


struct CustomTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomTimePicker(selectedTime: .constant(20)) // Use .constant to simulate a binding in the preview
    }
}
