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
        riveViewModel.setInput("endAnimation", value: false)
        
    }
    
    public func pauseRiveAnimation() {
        riveViewModel.setInput("isStarted", value: false)
        riveViewModel.setInput("endAnimation", value: false)
    }
    
    public func stopRiveAnimation() {
        riveViewModel.setInput("isStarted", value: false)
        riveViewModel.setInput("endAnimation", value: true)
    }
    
        
    
}
