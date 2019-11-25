//
//  CommandStatus.swift
//  Calculator
//
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import Foundation

/// Constants to identify the Watch Connectivity methods, also used as user-visible strings in UI.
///
enum Command: String {
    case updateAppContext = "UpdateAppContext"
}

/// Constants to identify the phrases of a Watch Connectivity communication.
///
enum Phrase: String {
    case updated = "Updated"
    case received = "Received"
    case finished = "Finished"
    case failed = "Failed"
}

/// Wrap the command status to bridge the commands status and UI.
///
struct CommandStatus {
    var command: Command
    var phrase: Phrase
    var payload: Payload?
    var errorMessage: String?

    init(command: Command, phrase: Phrase) {
        self.command = command
        self.phrase = phrase
    }
}
