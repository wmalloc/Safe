//
//  AuthenticationUI.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public enum AuthenticationUI: CaseIterable, Equatable {
    case allow
    case fail
    case skip
}

extension AuthenticationUI: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case UseAuthentication.UIAllow:
            self = .allow
        case UseAuthentication.UIFail:
            self = .fail
        case UseAuthentication.UISkip:
            self = .skip
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .allow:
            return UseAuthentication.UIAllow
        case .fail:
            return UseAuthentication.UIFail
        case .skip:
            return UseAuthentication.UISkip
        }
    }
}

extension AuthenticationUI: CustomStringConvertible {
    public var description: String {
        switch self {
        case .allow:
            return "allow"
        case .fail:
            return "fail"
        case .skip:
            return "skip"
        }
    }
}
