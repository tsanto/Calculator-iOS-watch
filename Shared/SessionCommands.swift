//
//  SessionCommands.swift
//  Calculator
//
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import Foundation
import WatchConnectivity

/// Define an interface to wrap Watch Connectivity APIs and
/// bridge the UI. Shared by the iOS app and watchOS app.
///
protocol SessionCommands {
    func updateAppContext(_ context: [String: Any])
}

/// Implement the commands. Every command handles the communication and notifies clients
/// when WCSession status changes or data flows. Shared by the iOS app and watchOS app.
///
extension SessionCommands {

    /// Update app context if the session is activated and update UI with the command status.
    ///
    func updateAppContext(_ context: [String: Any]) {
        var commandStatus = CommandStatus(command: .updateAppContext, phrase: .updated)
        commandStatus.payload = Payload(context)

        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        do {
            try WCSession.default.updateApplicationContext(context)
            print("applicationContext was sent")
        } catch {
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
        }
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }

    /// Post a notification on the main thread asynchronously.
    ///
    private func postNotificationOnMainQueueAsync(name: NSNotification.Name, object: CommandStatus) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: object)
        }
    }

    /// Handle the session unactived error. WCSession commands require an activated session.
    ///
    private func handleSessionUnactivated(with commandStatus: CommandStatus) {
        var mutableStatus = commandStatus
        mutableStatus.phrase = .failed
        mutableStatus.errorMessage =  "WCSession is not activeted yet!"
        postNotificationOnMainQueueAsync(name: .dataDidFlow, object: commandStatus)
    }
}
