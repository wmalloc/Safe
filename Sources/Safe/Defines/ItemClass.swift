//
//  Keychain+ItemClass.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public enum ItemClass: CaseIterable, Equatable {
    case genericPassword
    case internetPassword
}

extension ItemClass: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = .genericPassword
        case String(kSecClassInternetPassword):
            self = .internetPassword
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .genericPassword:
            return String(kSecClassGenericPassword)
        case .internetPassword:
            return String(kSecClassInternetPassword)
        }
    }
}

extension ItemClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .genericPassword:
            return "GenericPassword"
        case .internetPassword:
            return "InternetPassword"
        }
    }
}
