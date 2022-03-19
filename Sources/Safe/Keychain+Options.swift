//
//  Keychain+Options.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import os.log
import Security

extension Keychain {
    struct Options {
        var itemClass: ItemClass = .genericPassword

        var service: String = ""
        var accessGroup: String? = nil

        var server: URL?
        var protocolType: String = ""
        var authenticationType: String = "default"

        var accessibility: Accessibility = .afterFirstUnlock
        var authenticationPolicy: AuthenticationPolicy?

        var isSynchronizable: Bool = false

        var label: String?
        var comment: String?

        var authenticationPrompt: String?
        var authenticationUI: AuthenticationUI?
        var authenticationContext: AnyObject?

        var attributes = Attributes()
    }
    
    @discardableResult
    static func securityError(status: OSStatus) -> Error {
        let error = KeychainError(status: status)
        if error != .userCanceled {
            os_log("OSStatus error:[%d] %@", log: .keychain, type: .error, error.errorCode, error.description)
        }

        return error
    }

    @discardableResult
    func securityError(status: OSStatus) -> Error {
        return type(of: self).securityError(status: status)
    }
}

extension Attributes {
    var authenticationPrompt: String? {
        get {
            self[UseOperationPrompt] as? String
        }
        set {
            setOrRemove(newValue, forKey: UseOperationPrompt)
        }
    }
    
    var useAuthenticationContext: AnyObject? {
        get {
            self[UseAuthentication.Context] as? AnyObject
        }
        set {
            setOrRemove(newValue, forKey: UseAuthentication.Context)
        }
    }
}

extension Keychain.Options {
    func queryAttributes(ignoringAttributeSynchronizable: Bool = true) -> Attributes {
        var query = Attributes()

        query.class = itemClass.rawValue
        if let accessGroup = self.accessGroup {
            query.accessGroup = accessGroup
        }
        if ignoringAttributeSynchronizable {
            query.synchronizable = SynchronizableAny
        } else {
            query.synchronizable = isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
        }

        switch itemClass {
        case .genericPassword:
            query.service = service
        case .internetPassword:
            query.server = server?.host
            query.port = server?.port
            query.protocol = protocolType
            query.authenticationType = authenticationType
        }

        if #available(OSX 10.15, *) {
            if authenticationPrompt != nil {
                query.authenticationPrompt = authenticationPrompt
            }
        }

        #if os(iOS) || os(macOS)
        if authenticationContext != nil {
            query.useAuthenticationContext = authenticationContext
        }
        #endif

        return query
    }
    
    func attributes(forKey key: String?, value: Data) -> (Attributes, Error?) {
        var attributes: Attributes

        if let key = key {
            attributes = queryAttributes()
            attributes.account = key
        } else {
            attributes = Attributes()
        }

        attributes.data = value

        if let label = label {
            attributes.label = label
        }
        if let comment = comment {
            attributes.comment = comment
        }

        if let policy = authenticationPolicy {
            if #available(macOS 10.15, *) {
                var error: Unmanaged<CFError>?
                guard let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, SecAccessControlCreateFlags(rawValue: CFOptionFlags(policy.rawValue)), &error) else {
                    if let error = error?.takeUnretainedValue() {
                        return (attributes, error.error)
                    }

                    return (attributes, KeychainError.unexpectedError)
                }
                attributes.accessControl = accessControl
            } else {
                os_log(.error, log: .keychain, "'Touch ID integration' unavailable on this version of macOS")
            }
        } else {
            attributes.accessible = accessibility.rawValue
        }

        attributes.synchronizable = isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse

        return (attributes, nil)
    }
}
