//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Tiago Santo on 24/11/2019.
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    @IBOutlet weak var errorImage: WKInterfaceImage!
    
    private var command: Command!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let context = context as? CommandStatus {
            command = context.command
            updateUI(with: context)
        } else {
            reloadController()
        }

        addNotifications()

    }
    
    private func reloadController() {
        let context = CommandStatus(command: .updateAppContext, phrase: .finished)
        awake(withContext: context)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func willActivate() {
        super.willActivate()
        guard command != nil else { return }

        if command == .updateAppContext {
            let payload = WCSession.default.receivedApplicationContext
            if payload.isEmpty == false {
                var commandStatus = CommandStatus(command: command, phrase: .received)
                commandStatus.payload = Payload(payload)
                updateUI(with: commandStatus)
            }
        }
    }

    /// Install notification observer.
    ///
    private func addNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataDidFlow(_:)),
            name: .dataDidFlow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(activationDidComplete(_:)),
            name: .activationDidComplete,
            object: nil
        )
    }

    /// .dataDidFlow notification handler. Update the UI based on the command status.
    ///
    @objc func dataDidFlow(_ notification: Notification) {
        guard let commandStatus = notification.object as? CommandStatus else { return }

        if commandStatus.command == command {
            updateUI(with: commandStatus, errorMessage: commandStatus.errorMessage)
            return
        }
    }

    /// .activationDidComplete notification handler.
    ///
    @objc func activationDidComplete(_ notification: Notification) {
        print("\(#function): session `activationState` is \(WCSession.default.activationState)")
    }

    /// Update the user interface with the command status.
    ///
    private func updateUI(with commandStatus: CommandStatus, errorMessage: String? = nil) {
        guard let payload = commandStatus.payload,
              let multiply = payload.multiply,
              errorMessage == nil
        else {
            displayError(description: "Not connected, please open the iPhone app")
            return
        }
        
        displayResult(description: multiply.description)
    }
    
    private func displayError(description: String) {
        errorImage.setHidden(false)
        mainLabel.setText(description)
    }
    
    private func displayResult(description: String) {
        errorImage.setHidden(true)
        mainLabel.setText(description)
    }
}

extension WCSessionActivationState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notActivated:
            return "notActivated"
        case .inactive:
            return "inactive"
        case .activated:
            return "activated"
        @unknown default:
            fatalError()
        }
    }

}

