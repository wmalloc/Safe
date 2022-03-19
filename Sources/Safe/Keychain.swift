//
//  Keychain.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security
#if os(iOS) || os(macOS)
import LocalAuthentication
#endif
import os.log

extension OSLog {
    static let keychain = OSLog(subsystem: "com.waqarmalik.Safe", category: "Keychain")
}

public final class Keychain {
    let options: Options

    init(_ options: Options) {
        self.options = options
    }

    public convenience init(service: String? = nil, accessGroup: String? = nil) {
        var options = Options()
        if let bundleIdentifier = service ?? Bundle.main.bundleIdentifier {
            options.service = bundleIdentifier
        }
        options.accessGroup = accessGroup
        self.init(options)
    }

    public convenience init(server: String, protocolType: String, accessGroup: String? = nil, authenticationType: String = "default") {
        self.init(server: URL(string: server)!, protocolType: protocolType, accessGroup: accessGroup, authenticationType: authenticationType)
    }

    public convenience init(server: URL, protocolType: String, accessGroup: String? = nil, authenticationType: String = "default") {
        var options = Options()
        options.itemClass = .internetPassword
        options.server = server
        options.protocolType = protocolType
        options.accessGroup = accessGroup
        options.authenticationType = authenticationType
        self.init(options)
    }
}

public extension Keychain {
    func accessibility(_ accessibility: Accessibility) -> Keychain {
        var options = self.options
        options.accessibility = accessibility
        return Keychain(options)
    }

    func isSynchronizable(_ isSynchronizable: Bool) -> Keychain {
        var options = self.options
        options.isSynchronizable = isSynchronizable
        return Keychain(options)
    }

    func label(_ label: String) -> Keychain {
        var options = self.options
        options.label = label
        return Keychain(options)
    }

    func comment(_ comment: String) -> Keychain {
        var options = self.options
        options.comment = comment
        return Keychain(options)
    }

    func attributes(_ attributes: [String: Any]) -> Keychain {
        var options = self.options
        attributes.forEach { options.attributes.updateValue($1, forKey: $0) }
        return Keychain(options)
    }

    @available(watchOS, unavailable)
    func authenticationPrompt(_ authenticationPrompt: String) -> Keychain {
        var options = self.options
        options.authenticationPrompt = authenticationPrompt
        return Keychain(options)
    }

#if os(iOS) || os(macOS)
    func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychain {
        var options = self.options
        options.accessibility = accessibility
        options.authenticationPolicy = authenticationPolicy
        return Keychain(options)
    }

    func authenticationUI(_ authenticationUI: AuthenticationUI) -> Keychain {
        var options = self.options
        options.authenticationUI = authenticationUI
        return Keychain(options)
    }

    func authenticationContext(_ authenticationContext: LAContext) -> Keychain {
        var options = self.options
        options.authenticationContext = authenticationContext
        return Keychain(options)
    }
#endif
}

public extension Keychain {
    subscript(key: String) -> String? {
        get {
            try? string(forKey: key)
        }
        
        set {
            guard let value = newValue else {
                try? removeItem(forKey: key)
                return
            }
            
            try? set(string: value, key: key)
        }
    }
    
    subscript(string key: String) -> String? {
        get {
            return self[key]
        }

        set {
            self[key] = newValue
        }
    }
    
    subscript(data key: String) -> Data? {
        get {
            try? data(forKey: key)
        }

        set {
            guard let value = newValue else {
                try? removeItem(forKey: key)
                return
            }
            try? set(data: value, forKey: key)
        }
    }
    
    subscript<T: Codable>(codable key: String) -> T? {
        get {
            try? get(forKey: key, handler: { data in
                try JSONDecoder().decode(T.self, from: data)
            })
        }
        set {
            guard let value = newValue else {
                try? removeItem(forKey: key)
                return
            }
            try? set(value: value, forKey: key, handler: { item in
                try JSONEncoder().encode(item)
            })
        }
    }
}
