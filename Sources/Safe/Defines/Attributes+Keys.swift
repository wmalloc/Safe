//
//  File.swift
//
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

enum AttributeKey {
    @available(iOS 13.0, macOS 10.15, *)
    static let AccessControl = String(kSecAttrAccessControl)

    static let AttrClass = String(kSecClass)
    static let Accessible = String(kSecAttrAccessible)

    static let AccessGroup = String(kSecAttrAccessGroup)
    static let Synchronizable = String(kSecAttrSynchronizable)
    static let CreationDate = String(kSecAttrCreationDate)
    static let ModificationDate = String(kSecAttrModificationDate)
    static let Description = String(kSecAttrDescription)
    static let Comment = String(kSecAttrComment)
    static let Creator = String(kSecAttrCreator)
    static let AttrType = String(kSecAttrType)
    static let Label = String(kSecAttrLabel)
    static let IsInvisible = String(kSecAttrIsInvisible)
    static let IsNegative = String(kSecAttrIsNegative)
    static let Account = String(kSecAttrAccount)
    static let Service = String(kSecAttrService)
    static let Generic = String(kSecAttrGeneric)
    static let SecurityDomain = String(kSecAttrSecurityDomain)
    static let Server = String(kSecAttrServer)
    static let AttrProtocol = String(kSecAttrProtocol)
    static let AuthenticationType = String(kSecAttrAuthenticationType)
    static let Port = String(kSecAttrPort)
    static let Path = String(kSecAttrPath)
}

enum Search {
    static let MatchLimit = String(kSecMatchLimit)
    static let MatchLimitOne = kSecMatchLimitOne
    static let MatchLimitAll = kSecMatchLimitAll
}

enum ReturnType {
    static let Data = String(kSecReturnData)
    static let Attributes = String(kSecReturnAttributes)
    static let Ref = String(kSecReturnRef)
    static let PersistentRef = String(kSecReturnPersistentRef)
}

enum ValueType {
    static let Data = String(kSecValueData)
    static let Ref = String(kSecValueRef)
    static let PersistentRef = String(kSecValuePersistentRef)
}

let SynchronizableAny = kSecAttrSynchronizableAny

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
let UseOperationPrompt = String(kSecUseOperationPrompt)

enum UseAuthentication {
    @available(iOS, introduced: 8.0, deprecated: 9.0, message: "Use a UseAuthenticationUI instead.")
    @available(macOS, introduced: 10.10, deprecated: 10.11, message: "Use UseAuthenticationUI instead.")
    @available(watchOS, introduced: 2.0, deprecated: 2.0, message: "Use UseAuthenticationUI instead.")
    @available(tvOS, introduced: 8.0, deprecated: 9.0, message: "Use UseAuthenticationUI instead.")
    static let NoUI = String(kSecUseNoAuthenticationUI)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static let UI = String(kSecUseAuthenticationUI)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static let Context = String(kSecUseAuthenticationContext)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static let UIAllow = String(kSecUseAuthenticationUIAllow)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static let UIFail = String(kSecUseAuthenticationUIFail)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    static let UISkip = String(kSecUseAuthenticationUISkip)
}
