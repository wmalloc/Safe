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
        configuaration.itemClass
    }

    var service: String {
        configuaration.service
    }

    var accessGroup: SharedGroupIdentifier? {
        configuaration.accessGroup
    }

    var server: URL? {
        configuaration.server
    }

    var protocolType: String {
        configuaration.protocolType
    }

    var authenticationType: String {
        configuaration.authenticationType
    }

    var accessibility: Accessibility {
        configuaration.accessibility
    }

    var isSynchronizable: Bool {
        configuaration.isSynchronizable
    }

    var label: String? {
        configuaration.label
    }

    var comment: String? {
        configuaration.comment
    }

#if os(iOS) || os(macOS)
    var authenticationPolicy: AuthenticationPolicy? {
        configuaration.authenticationPolicy
    }

    var authenticationPrompt: String? {
        configuaration.authenticationPrompt
    }

    var authenticationUI: AuthenticationUI {
        configuaration.authenticationUI ?? .allow
    }

    var authenticationContext: LAContext? {
        configuaration.authenticationContext as? LAContext
    }
#endif
}
