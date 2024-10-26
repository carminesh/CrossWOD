//
//  RiveAnimationManager.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 16/10/24.
//

import Foundation
import RiveRuntime

struct RiveAnimationManager {
    
    let riveViewModel : RiveViewModel
    
    init(fileName : String, stateMachineName : String) {
        
        self.riveViewModel = RiveViewModel(fileName: fileName, stateMachineName: stateMachineName)
    }
    
    public func startRiveAnimation() {
        riveViewModel.setInput("isStarted", value: true)
         
    }
    
    public func pauseRiveAnimation() {
        riveViewModel.setInput("isStarted", value: false)
        riveViewModel.setInput("endAnimation", value: false)
    }
    
    public func stopRiveAnimation() {
        riveViewModel.setInput("endAnimation", value: true)
    }

    
    public func doRestRiveAnimation() {
        riveViewModel.setInput("isResting", value: true)
    }
    
    public func undoRestRiveAnimation() {
        riveViewModel.setInput("isResting", value: false)
        riveViewModel.reset()
        riveViewModel.setInput("isStarted", value: true)
    }
    
    public func restToStopRiveAnimation() {
        riveViewModel.setInput("isResting", value: false)
        riveViewModel.setInput("isStarted", value: false)
    }
    
}
