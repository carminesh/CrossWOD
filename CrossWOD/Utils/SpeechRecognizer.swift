//
//  SpeechRecognizer.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/06/25.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "it-IT"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    var onCommandRecognized: ((String) -> Void)?

    override init() {
        super.init()	
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != .authorized {
                print("❌ Speech recognition not authorized")
            }
        }
    }

    func startListening() {
        stopListening() // sempre sicuro

        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }
        request.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            (buffer, _) in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("🎤 Audio engine started")
        } catch {
            print("❌ Error starting audio engine: \(error.localizedDescription)")
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let error = error {
                print("❌ Errore riconoscimento: \(error.localizedDescription)")
                return
            }
            guard let result = result else {
                print("⚠️ Nessun risultato")
                return
            }

            let bestString = result.bestTranscription.formattedString.lowercased()
            print("🎤 Frase riconosciuta: \(bestString)")

            if bestString.contains("pausa") || bestString.contains("stop") {
                self.onCommandRecognized?("pausa")
            } else if bestString.contains("riprendi") || bestString.contains("continua") {
                self.onCommandRecognized?("riprendi")
            } else if bestString.contains("start") || bestString.contains("avvia") {
                self.onCommandRecognized?("start")
            }
        }
    }
    
    func stopListening() {
        recognitionTask?.cancel()
        recognitionTask = nil
        request = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
