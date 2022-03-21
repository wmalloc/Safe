//
//  File.swift
//
//
//  Created by Waqar Malik on 3/20/22.
//

import Foundation

// https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps
public struct SharedGroupIdentifier: Identifiable {
    private static let appGroupPrefix = "group"
    let prefix: String
    let groupIdentifier: String

    public var id: String {
        prefix + "." + groupIdentifier
    }

    public init?(appIDPrefix: String, nonEmptyGroup groupIdentifier: String?) {
        guard !appIDPrefix.isEmpty, let groupIdentifier = groupIdentifier, !groupIdentifier.isEmpty else {
            return nil
        }

        self.prefix = appIDPrefix
        self.groupIdentifier = groupIdentifier
    }

    public init?(groupPrefix: String, nonEmptyGroup groupIdentifier: String?) {
        #if os(macOS)
        guard !groupPrefix.isEmpty, let groupIdentifier = groupIdentifier, !groupIdentifier.isEmpty else {
            return nil
        }
        #else
        guard groupPrefix == Self.appGroupPrefix, let groupIdentifier = groupIdentifier, !groupIdentifier.isEmpty else {
            return nil
        }
        #endif

        self.prefix = groupPrefix
        self.groupIdentifier = groupIdentifier
    }
}

public extension SharedGroupIdentifier {
    var description: String {
        id
    }
}
