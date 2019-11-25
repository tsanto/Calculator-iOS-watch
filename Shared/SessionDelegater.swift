//
//  SessionDelegater.swift
//  Calculator
//
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import Foundation
import WatchConnectivity

/// Custom notifications.
/// Posted when Watch Connectivity activation status is changed,
/// or when data is received or sent. Clients observe these notifications to update the UI.
///
extension Notification.Name {
    static let dataDidFlow = Notification.Name("DataDidFlow")
    static let activationDidComplete = Notification.Name("ActivationDidComplete")
}

/// Implement WCSessionDelegate methods to receive Watch Connectivity data and notify clients.
/// WCsession status changes are also handled here.
///
class SessionDelegater: NSObject, WCSessionDelegate {
    /// Called when WCSession activation state is changed.
    ///
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        postNotificationOnMainQueueAsync(name: .activationDidComplete)
    }

    /// Called when an app context is received.
    ///
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("applicationContext was received")
        var commandStatus = CommandStatus(command: .updateAppContext, phrase: .received)
        commandStatus.payload = Payload(applicationContext)
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }

    /// WCSessionDelegate methods for iOS only.
    ///
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif

    /// Post a notification on the main thread asynchronously.
    ///
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: CommandStatus? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }
}
