//
//  KeychainError.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public enum KeychainError: OSStatus, LocalizedError {
    case success                            = 0
    case unimplemented                      = -4
    case param                              = -50
    case userCanceled                       = -128
    case notAvailable                       = -25291
    case missingEntitlement                 = -34018
    case conversionError                    = -67594
    case unexpectedError                    = -99999

    public var errorDescription: String? {
        description
    }
}

extension KeychainError: RawRepresentable {
    public init(status: OSStatus) {
        if let mappedStatus = KeychainError(rawValue: status) {
            self = mappedStatus
        } else {
            self = .unexpectedError
        }
    }
}
extension KeychainError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "Success."
        case .unimplemented:
            return "Function or operation not implemented."
        case .param:
            return "One or more parameters passed to a function were not valid."
        case .userCanceled:
             return "User canceled the operation."
        case .notAvailable:
            return "No keychain is available. You may need to restart your computer."
        case .missingEntitlement:
            return "A required entitlement isn't present."
        case .conversionError:
            return "A conversion error has occurred."
        case .unexpectedError:
            return "Unexpected error has occurred."
        }
    }
}

extension KeychainError: CustomNSError {
    public static let errorDomain = "com.waqarmalik.Safe.Error"

    public var errorCode: Int {
        return Int(rawValue)
    }

    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: description]
    }
}

extension CFError {
    var error: NSError {
        let domain = CFErrorGetDomain(self) as String
        let code = CFErrorGetCode(self)
        let userInfo = CFErrorCopyUserInfo(self) as! [String: Any]

        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
