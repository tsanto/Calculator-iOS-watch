//
//  PayloadDataProvider.swift
//  Calculator
//
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import Foundation

/// Constants to access the payload dictionary.
///
struct PayloadKey {
    static let multiply = "multiplyKey"
}

/// Define the interfaces for providing payload for Watch Connectivity APIs.
///
protocol PayloadDataProvider {
    var appContext: [String: Any] { get }
}

struct Payload {
    var multiply: Multiply?

    init(_ dict: [String: Any]) {
        guard let multiply = dict[PayloadKey.multiply] as? [String: Any] else {
            return
        }

        self.multiply = Multiply(from: multiply)
    }
}
