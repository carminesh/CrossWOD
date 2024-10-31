//
//  File.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 31/10/24.
//

import Foundation
import WatchConnectivity


final class WatchConnector: NSObject, ObservableObject {
    
    static let shared = WatchConnector()
    
    @Published var workout: Workout? = nil
    
    
    override private init() {
        
        super.init()
        
#if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
#endif
        
        WCSession.default.delegate = self
        
        // start the WCSession
        WCSession.default.activate()
    }
    
    
    public func send(theFollowing workout: Workout) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activated.")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("WCSession is not reachable.")
            return
        }
        
        
#if os(watchOS)
        
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#else
        
        // here i check if the app is installed on the watch
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        
        
        
        
        let workoutDictionary = workoutToDictionary(workout: workout)
        
        
        
        WCSession.default.sendMessage(workoutDictionary as [String : Any], replyHandler: { response in
            if let status = response["status"] as? String {
                print("Response from Watch: \(status)")
            } else {
                print("Unexpected response from Watch.")
            }
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
        
    }
    
    
}


// MARK: - WCSessionDelegate
// here we manage the received messages
extension WatchConnector: WCSessionDelegate {
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            print("Activation error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
        
        if activationState == .activated {
            print("WCSession activated.")
            
        }
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // If the person has more than one watch, and they switch,
        // reactivate their session on the new device.
        WCSession.default.activate()
    }
#endif
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        // Print received message for debugging
        print("Received message: \(message)")
        
        do {
    
            // Decode the message directly to a Workout object
            let workout = try dictionaryToWorkout(dictionary: message)
            
            print("workout: \(workout)")
            
            // Assign the decoded Workout to self.workout
            DispatchQueue.main.async {
                self.workout = workout 
            }
            
            // Send acknowledgment to sender
            replyHandler(["status": "Workout received successfully"])
            
        } catch {
            print("Error decoding Workout from message: \(error)")
            replyHandler(["status": "Error decoding Workout: \(error.localizedDescription)"])
        }
    }
    
    
}
