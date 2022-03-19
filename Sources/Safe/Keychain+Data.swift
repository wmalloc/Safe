//
//  Keychain+Data.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public extension Keychain {
    func data(forKey key: String, ignoringAttributeSynchronizable: Bool = true) throws -> Data? {
        var query = options.queryAttributes(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
        query[Search.MatchLimit] = Search.MatchLimitOne
        query[ReturnType.Data] = kCFBooleanTrue
        query.account = key

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainError.unexpectedError
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw securityError(status: status)
        }
    }

    func set(data value: Data, forKey key: String, ignoringAttributeSynchronizable: Bool = true) throws {
        var query = options.queryAttributes(ignoringAttributeSynchronizable: ignoringAttributeSynchronizable)
        query.account = key
        #if os(iOS)
        if let authenticationUI = options.authenticationUI {
            query[UseAuthentication.UI] = authenticationUI.rawValue
        } else {
            query[UseAuthentication.UI] = UseAuthentication.UIFail
        }
        #elseif os(OSX)
        query[ReturnType.Data] = kCFBooleanTrue
        if let authenticationUI = options.authenticationUI {
            query[UseAuthentication.UI] = authenticationUI.rawValue
        } else {
            query[UseAuthentication.UI] = UseAuthentication.UIFail
        }
        #else
        if let authenticationUI = options.authenticationUI {
            query[UseAuthentication.UI] = authenticationUI.rawValue
        }
        #endif

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            var query = options.queryAttributes()
            query.account = key

            var (attributes, error) = options.attributes(forKey: nil, value: value)
            if let error = error {
                print(error.localizedDescription)
                throw error
            }

            options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

            #if os(iOS)
            if status == errSecInteractionNotAllowed && floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_8_0) {
                try removeItem(forKey: key)
                try set(data: value, forKey: key)
            } else {
                status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
                if status != errSecSuccess {
                    throw securityError(status: status)
                }
            }
            #else
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status != errSecSuccess {
                throw securityError(status: status)
            }
            #endif
        case errSecItemNotFound:
            var (attributes, error) = options.attributes(forKey: key, value: value)
            if let error = error {
                print(error.localizedDescription)
                throw error
            }

            options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

            status = SecItemAdd(attributes as CFDictionary, nil)
            if status != errSecSuccess {
                throw securityError(status: status)
            }
        default:
            throw securityError(status: status)
        }
    }
}