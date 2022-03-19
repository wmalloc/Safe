//
//  AuthenticationPolicy.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public struct AuthenticationPolicy: OptionSet {
    public static let userPresence = AuthenticationPolicy(rawValue: 1 << 0)
    public static let biometryAny = AuthenticationPolicy(rawValue: 1 << 1)
    public static let biometryCurrentSet = AuthenticationPolicy(rawValue: 1 << 3)
    public static let devicePasscode = AuthenticationPolicy(rawValue: 1 << 4)

    @available(iOS, unavailable)
    @available(macOS 10.15, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let watch = AuthenticationPolicy(rawValue: 1 << 5)

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}
