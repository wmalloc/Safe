//
//  Keychain+Shared.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import os.log
import Security

public extension Keychain {
    func string(forKey key: String, ignoringAttributeSynchronizable: Bool = true) throws -> String? {
        guard let data = try data(forKey: key, ignoringAttributeSynchronizable: ignoringAttributeSynchronizable) else  {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            os_log(.error, log: .keychain, "Data conversion")
            throw KeychainError.conversionError
        }
        return string
    }
    
    func set(string value: String, key: String, ignoringAttributeSynchronizable: Bool = true) throws {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
            os_log(.error, log: .keychain, "Data conversion")
            throw KeychainError.conversionError
        }
        try set(data: data, forKey: key, ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
    }
}
