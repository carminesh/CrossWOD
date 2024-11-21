import Foundation
import WatchConnectivity


final class WatchConnector: NSObject, ObservableObject {
    
    static let shared = WatchConnector()
    
    @Published var workout: Workout? = nil
    @Published var startWorkout: Bool = false
    @Published var isWorkoutPaused: Bool = true
    @Published var countdownToAdjust: Int = 0

    


    
    override private init() {
        super.init()
        
#if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
#endif
        
        WCSession.default.delegate = self
        
        // Start the WCSession
        WCSession.default.activate()
    }
    
    // MARK: - Helper Function to Identify Source Device
    private func getDeviceType() -> String {
#if os(watchOS)
        return "Watch"
#else
        return "iPhone"
#endif
    }
    
    // MARK: - Sender functions section
    
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
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        
        let workoutDictionary = workoutToDictionary(workout: workout)
        let message = workoutDictionary.merging([
            "messageType": "sendWorkoutInfo",
            "sourceDevice": getDeviceType()  // Add source device identifier
        ]) { (_, new) in new }
        
        WCSession.default.sendMessage(message as [String : Any], replyHandler: { response in
            if let status = response["status"] as? String {
                print("Response from \(response["sourceDevice"] ?? "Unknown") in sendWorkoutInfo: \(status)")
            } else {
                print("Unexpected response in sendWorkoutInfo.")
            }
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
    }
    
    public func sendPauseInfo(toPaused paused: Bool, countdownToAdjust: Int) {
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
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
    #endif

        // Log device information and current pause state
        print("[\(getDeviceType())] Sending pause info. Paused: \(paused)")
        
        let message = [
            "messageType": "sendPauseInfo",
            "sourceDevice": getDeviceType(),
            "isPaused": paused,
            "countdownToAdjust": countdownToAdjust
        ] as [String : Any]
        
        WCSession.default.sendMessage(message, replyHandler: { response in
            if let status = response["status"] as? String {
                print("[\(self.getDeviceType())] Response from \(response["sourceDevice"] ?? "Unknown") in sendPauseInfo: \(status)")
            } else {
                print("[\(self.getDeviceType())] Unexpected response in sendPauseInfo.")
            }
        }, errorHandler: { error in
            print("[\(self.getDeviceType())] Error sending message: \(error.localizedDescription)")
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
        
        let message = [
            "messageType": "startWorkoutOnOtherDevice",
            "sourceDevice": getDeviceType()  // Add source device identifier
        ]
        
        WCSession.default.sendMessage(message, replyHandler: { response in
            print("Response from \(response["sourceDevice"] ?? "Unknown") in startWorkout: \(response)")
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
    }
    
    // MARK: Receiver function section
    func handleWorkoutInfoResponse(_ message: [String: Any]) {
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
        if let isPaused = response["isPaused"] as? Bool,
           let countdownToAdjust = response["countdownToAdjust"] as? Int {
            DispatchQueue.main.async {
                print("[\(self.getDeviceType())] setting isWorkoutPaused to: \(isPaused) and countdownToAdjust to: \(countdownToAdjust)")
                self.isWorkoutPaused = isPaused
                self.countdownToAdjust = countdownToAdjust
            }
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
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
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
            replyHandler(["status": "Unknown message type", "sourceDevice": getDeviceType()])
            return
        }
        
        // Get the source of the message
        let sourceDevice = message["sourceDevice"] as? String ?? "Unknown"
        
        // Ignore messages from the same device to avoid looping
        if sourceDevice == getDeviceType() {
            print("Ignoring message \(messageType) from same device (\(sourceDevice))")
            replyHandler(["status": "Ignored message from same device", "sourceDevice": getDeviceType()])
            return
        }
        
        print("Received MessageType: \(messageType) from \(sourceDevice)")
        
        // Send a custom acknowledgment
        if messageType == "startWorkoutOnOtherDevice" {
            replyHandler(["status": "Workout started", "sourceDevice": getDeviceType()])
        } else {
            replyHandler(["status": "received", "sourceDevice": getDeviceType()])
        }
        
        // Here we manage the response on the receiving device
        switch messageType {
        case "sendWorkoutInfo":
            handleWorkoutInfoResponse(message)
        case "sendPauseInfo":
            handlePauseResponse(message)
        case "startWorkoutOnOtherDevice":
            handleStartWorkoutResponse(message)
        default:
            print("Unhandled message type: \(messageType)")
        }
    }
}
