//
//  Keychain+Access.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security
#if os(iOS) || os(macOS)
import LocalAuthentication
#endif

public extension Keychain {
    var itemClass: ItemClass {
        options.itemClass
    }

    var service: String {
        options.service
    }

    var accessGroup: String? {
        options.accessGroup
    }

    var server: URL? {
        options.server
    }

    var protocolType: String {
        options.protocolType
    }

    var authenticationType: String {
        options.authenticationType
    }

    var accessibility: Accessibility {
        return options.accessibility
    }

    var isSynchronizable: Bool {
        options.isSynchronizable
    }

    var label: String? {
        options.label
    }

    var comment: String? {
        options.comment
    }

#if os(iOS) || os(macOS)
    var authenticationPolicy: AuthenticationPolicy? {
        options.authenticationPolicy
    }

    var authenticationPrompt: String? {
        options.authenticationPrompt
    }
    var authenticationUI: AuthenticationUI {
        options.authenticationUI ?? .allow
    }

    var authenticationContext: LAContext? {
        options.authenticationContext as? LAContext
    }
#endif
}
