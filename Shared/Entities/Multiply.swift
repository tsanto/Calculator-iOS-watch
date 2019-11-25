//
//  Multiply.swift
//  Calculator iOS
//
//  Created by Tiago Santo on 24/11/2019.
//  Copyright © 2019 Tiago Santo. All rights reserved.
//

import Foundation

struct Multiply {
    let result: String?
    
    var description: String {
        get {
            guard let result = result else {
                return "No results to be displayed."
            }
            
            return "Result: \(result)"
        }
    }
}

extension Multiply {
    /// For updateApplicationContext you need to provide an NSDictionary object with the data you want to send.
    /// The keys and values of your dictionary must all be property list types, because the data must be serialized and sent wirelessly.
    /// (If you need to include types that are not property list types, package them in an NSData object or write
    /// them to a file before sending them.)
    ///
    /// The fact that the dictionary is [String: Any] is misleading, because the Any values are restricted to valid property list types.
    ///
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["result"] = result ?? ""
        
        return dict
    }

    /// Since a dictionary with serialized value is received, we need to convert it with our custom objects.
    ///
    init?(from dict: [String: Any]) {
        guard let result = dict["result"] as? String else {
                return nil
        }

        self.init(
            result: result.isEmpty ? nil : result
        )
    }
}
