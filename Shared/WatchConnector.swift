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
    @Published var startWorkout: Bool = false
    
    
    
    
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
    
    // --MARK: Function to send workout info over the other device
    public func sendWorkoutInfo(ofTheFollowing workout: Workout) {
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
        let message = workoutDictionary.merging(["messageType": "sendWorkoutInfo"]) { (_, new) in new }
        
        
        WCSession.default.sendMessage(message as [String : Any], replyHandler: { response in
            if let status = response["status"] as? String {
                print("Response from Watch: \(status)")
            } else {
                print("Unexpected response from Watch.")
            }
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
        
    }
    
    public func sendPauseInfo(pause: Bool) {
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
        
        let setPause = ["pause": pause, "messageType": "sendPauseInfo"] as [String : Any]
        
        
        WCSession.default.sendMessage(setPause as [String : Any], replyHandler: { response in
            if let status = response["status"] as? String {
                print("Response from Watch: \(status)")
            } else {
                print("Unexpected response from Watch.")
            }
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
        
    }
    
    // MARK: - Function to start workout on other device
    public func startWorkoutOnOtherDevice() {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activated.")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("WCSession is not reachable.")
            return
        }
        
#if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else { return }
#else
        guard WCSession.default.isWatchAppInstalled else { return }
#endif
        
        let message = ["messageType": "startWorkoutOnOtherDevice"]
        
        WCSession.default.sendMessage(message, replyHandler: { response in
            if let status = response["status"] as? String, status == "Workout started" {
                DispatchQueue.main.async {
                    self.startWorkout = true
                }
                print("Response from Watch: \(status)")
            } else {
                print("Unexpected response from Watch.")
            }
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
    }
    
    
    func handleWorkoutResponse(_ message: [String: Any]) {
        do {
            
            // Decode the message directly to a Workout object
            let workout = try dictionaryToWorkout(dictionary: message)
                        
            // Assign the decoded Workout to self.workout
            DispatchQueue.main.async {
                self.workout = workout
            }
            
            
        } catch {
            print("Error decoding Workout from message: \(error.localizedDescription)")
        }
    }
    
    func handlePauseResponse(_ response: [String: Any]) {
        if let status = response["status"] as? String {
            print("Pause Response: \(status)")
        }
    }
    
    func handleStartWorkoutResponse(_ response: [String: Any]) {
        DispatchQueue.main.async {
            self.startWorkout = true
        }
    }
    
    func handleError(_ error: Error) {
        print("Error sending message: \(error.localizedDescription)")
    }
    
    
    
}


// MARK: - WCSessionDelegate here we manage the received messages
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
        
        guard let messageType = message["messageType"] as? String else {
            replyHandler(["status": "Unknown message type"])
            return
        }
        
        switch messageType {
        case "sendWorkoutInfo":
            handleWorkoutResponse(message)
        case "sendPauseInfo":
            handlePauseResponse(message)
        case "startWorkoutOnOtherDevice":
            handleStartWorkoutResponse(message)
        default:
            replyHandler(["status": "Unhandled message type"])
        }
        
        
    }
    
    
    
    
}
