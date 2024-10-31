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
    
    
    public func send(workout: Workout) {
        guard WCSession.default.activationState == .activated else {
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
        
        
        
        
        let workoutData: [String: Any] = [
            "id": workout.id.uuidString,
            "type": workout.type.rawValue,
            "date": workout.date.timeIntervalSince1970,
            "accentColor": workout.accentColor ?? "",
            "initialCountdown": workout.initialCountdown ?? 0,
            "seriesPerformed": workout.seriesPerformed ?? 0,
            "seriesTimes": workout.seriesTimes ?? [],
            "forTime": workout.forTime ?? 0,
            "restTime": workout.restTime ?? 0,
            "numberOfSeries": workout.numberOfSeries ?? 0,
            "workTime": workout.workTime ?? 0,
            "setRestTime": workout.setRestTime ?? 0,
            "setSeries": workout.setSeries ?? 0,
            "performedSets": workout.performedSets ?? 0,
            "numberOfRounds": workout.numberOfRounds ?? 0,
            "roundTimes": workout.roundTimes ?? 0,
            "totalWorkoutTime": workout.totalWorkoutTime ?? 0
        ]

        if !workoutData.isEmpty {
            WCSession.default.transferUserInfo(workoutData)
        } else {
            print("Failed to convert Workout to dictionary for transfer.")
        }
        
    }
    
    
}


// MARK: - WCSessionDelegate
extension WatchConnector: WCSessionDelegate {
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
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
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        // Convert the dictionary to JSON data
        do {
            // Convert compatible values to types expected in `Workout`
            var userInfoWithCompatibleTypes = userInfo
            
            if let dateTimestamp = userInfo["date"] as? TimeInterval {
                userInfoWithCompatibleTypes["date"] = Date(timeIntervalSince1970: dateTimestamp)
            }
            
            if let uuidString = userInfo["id"] as? String {
                userInfoWithCompatibleTypes["id"] = UUID(uuidString: uuidString)
            }
            
            // Encode the adjusted dictionary back to JSON
            let data = try JSONSerialization.data(withJSONObject: userInfoWithCompatibleTypes, options: .fragmentsAllowed)
            
            // Decode the JSON data to a Workout object
            let workout = try JSONDecoder().decode(Workout.self, from: data)
            
            // Assign the decoded Workout to self.workout
            DispatchQueue.main.async {
                self.workout = workout
            }
            
        } catch {
            print("Error decoding Workout from userInfo: \(error)")
        }
    }
    
    
}
