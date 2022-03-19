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
    let configuaration: Configuration

    init(_ configuration: Configuration) {
        self.configuaration = configuration
    }

    public convenience init(service: String? = nil, accessGroup: SharedGroupIdentifier? = nil) {
        var configuaration = Configuration()
        if let bundleIdentifier = service ?? Bundle.main.bundleIdentifier {
            configuaration.service = bundleIdentifier
        }
        configuaration.accessGroup = accessGroup
        self.init(configuaration)
    }

    public convenience init(server: String, protocolType: String, accessGroup: SharedGroupIdentifier? = nil, authenticationType: String = "default") {
        self.init(server: URL(string: server), protocolType: protocolType, accessGroup: accessGroup, authenticationType: authenticationType)
    }

    public convenience init(server: URL?, protocolType: String, accessGroup: SharedGroupIdentifier? = nil, authenticationType: String = "default") {
        var configuaration = Configuration()
        configuaration.itemClass = .internetPassword
        configuaration.server = server
        configuaration.protocolType = protocolType
        configuaration.accessGroup = accessGroup
        configuaration.authenticationType = authenticationType
        self.init(configuaration)
    }
}

public extension Keychain {
    func accessibility(_ accessibility: Accessibility) -> Keychain {
        var configuaration = self.configuaration
        configuaration.accessibility = accessibility
        return Keychain(configuaration)
    }

    func isSynchronizable(_ isSynchronizable: Bool) -> Keychain {
        var configuaration = self.configuaration
        configuaration.isSynchronizable = isSynchronizable
        return Keychain(configuaration)
    }

    func label(_ label: String) -> Keychain {
        var configuaration = self.configuaration
        configuaration.label = label
        return Keychain(configuaration)
    }

    func comment(_ comment: String) -> Keychain {
        var configuaration = self.configuaration
        configuaration.comment = comment
        return Keychain(configuaration)
    }

    func attributes(_ attributes: Attributes) -> Keychain {
        var configuaration = self.configuaration
        attributes.forEach { configuaration.attributes.updateValue($1, forKey: $0) }
        return Keychain(configuaration)
    }

    @available(watchOS, unavailable)
    func authenticationPrompt(_ authenticationPrompt: String) -> Keychain {
        var configuaration = self.configuaration
        configuaration.authenticationPrompt = authenticationPrompt
        return Keychain(configuaration)
    }

#if os(iOS) || os(macOS)
    func accessibility(_ accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychain {
        var configuaration = self.configuaration
        configuaration.accessibility = accessibility
        configuaration.authenticationPolicy = authenticationPolicy
        return Keychain(configuaration)
    }

    func authenticationUI(_ authenticationUI: AuthenticationUI) -> Keychain {
        var configuaration = self.configuaration
        configuaration.authenticationUI = authenticationUI
        return Keychain(configuaration)
    }

    func authenticationContext(_ authenticationContext: LAContext) -> Keychain {
        var configuaration = self.configuaration
        configuaration.authenticationContext = authenticationContext
        return Keychain(configuaration)
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
