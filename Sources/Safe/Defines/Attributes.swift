//
//  File.swift
//
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import Security

public typealias Attributes = [String: Any]

public extension Attributes {
    static var defaultOptions: Attributes {
        [AttributeKey.Synchronizable: SynchronizableAny]
    }
    
    var `class`: String? {
        get {
            self[AttributeKey.AttrClass] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AttrClass)
        }
    }

    var data: Data? {
        get {
            self[ValueType.Data] as? Data
        }
        set {
            setOrRemove(newValue, forKey: ValueType.Data)
        }
    }

    var ref: Data? {
        get {
            self[ValueType.Ref] as? Data
        }
        set {
            setOrRemove(newValue, forKey: ValueType.Ref)
        }
    }

    var persistentRef: Data? {
        get {
            self[ValueType.PersistentRef] as? Data
        }
        set {
            setOrRemove(newValue, forKey: ValueType.PersistentRef)
        }
    }

    var accessible: String? {
        get {
            self[AttributeKey.Accessible] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Accessible)
        }
    }

    var accessControl: SecAccessControl? {
        get {
            if #available(macOS 10.15, *) {
                if let accessControl = self[AttributeKey.AccessControl] {
                    return (accessControl as! SecAccessControl)
                }
                return nil
            } else {
                return nil
            }
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AccessControl)
        }
    }

    var accessGroup: String? {
        get {
            self[AttributeKey.AccessGroup] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AccessGroup)
        }
    }

    var synchronizable: Any? {
        get {
            self[AttributeKey.Synchronizable]
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Synchronizable)
        }
    }

    var creationDate: Date? {
        get {
            self[AttributeKey.CreationDate] as? Date
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.CreationDate)
        }
    }

    var modificationDate: Date? {
        get {
            self[AttributeKey.ModificationDate] as? Date
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.ModificationDate)
        }
    }

    var attributeDescription: String? {
        get {
            self[AttributeKey.Description] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Description)
        }
    }

    var comment: String? {
        get {
            self[AttributeKey.Comment] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Comment)
        }
    }

    var creator: String? {
        get {
            self[AttributeKey.Creator] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Creator)
        }
    }

    var type: String? {
        get {
            self[AttributeKey.AttrType] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AttrType)
        }
    }

    var label: String? {
        get {
            self[AttributeKey.Label] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Label)
        }
    }

    var isInvisible: Bool? {
        get {
            self[AttributeKey.IsInvisible] as? Bool
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.IsInvisible)
        }
    }

    var isNegative: Bool? {
        get {
            self[AttributeKey.IsNegative] as? Bool
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.IsNegative)
        }
    }

    var account: String? {
        get {
            self[AttributeKey.Account] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Account)
        }
   }

    var service: String? {
        get {
            self[AttributeKey.Service] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Service)
        }
    }

    var generic: Data? {
        get {
            self[AttributeKey.Generic] as? Data
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Generic)
        }
    }

    var securityDomain: String? {
        get {
            self[AttributeKey.SecurityDomain] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.SecurityDomain)
        }
    }

    var server: String? {
        get {
            self[AttributeKey.Server] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Server)
        }
    }

    var `protocol`: String? {
        get {
            self[AttributeKey.AttrProtocol] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AttrProtocol)
        }
    }

    var authenticationType: String? {
        get {
            self[AttributeKey.AuthenticationType] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.AuthenticationType)
        }
    }

    var port: Int? {
        get {
            self[AttributeKey.Port] as? Int
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Port)
        }
    }

    var path: String? {
        get {
            self[AttributeKey.Path] as? String
        }
        set {
            setOrRemove(newValue, forKey: AttributeKey.Path)
        }
    }
}

extension Attributes {
    mutating func setOrRemove(_ value: Any?, forKey key: String) {
        guard let value = value else {
            removeValue(forKey: key)
            return
        }
        self[key] = value
    }
}
