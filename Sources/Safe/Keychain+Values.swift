//
//  Keychain+Values.swift
//  Keychain
//
//  Created by Waqar Malik on 3/16/22.
//

import Foundation
import os.log
import Security

public extension Keychain {
    typealias AttributesMapper<T> = (Attributes?) -> T
    typealias DataMapper<U, T> = (U) throws -> T

    func set<T>(value: T, forKey key: String, options: Attributes = .defaultOptions, handler: DataMapper<T, Data>) throws {
        let data = try handler(value)
        try set(data: data, forKey: key, options: options)
    }

    func get<T>(forKey key: String, options: Attributes = .defaultOptions, handler: DataMapper<Data, T>) throws -> T? {
        guard let data = try data(forKey: key, options: options) else {
            return nil
        }
        return try handler(data)
    }

    func item<T>(forKey key: String, options: Attributes = .defaultOptions, handler: AttributesMapper<T>) throws -> T {
        var query = configuaration.queryAttributes(options: options)
        query[Search.MatchLimit] = Search.MatchLimitOne
        query[ReturnType.Data] = kCFBooleanTrue
        query[ReturnType.Attributes] = kCFBooleanTrue
        query[ReturnType.Ref] = kCFBooleanTrue
        query[ReturnType.PersistentRef] = kCFBooleanTrue

        query.account = key

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let attributes = result as? Attributes else {
                throw KeychainError.unexpectedError
            }
            return handler(attributes)
        case errSecItemNotFound:
            return handler(nil)
        default:
            throw securityError(status: status)
        }
    }

    func removeItem(forKey key: String, options: Attributes = .defaultOptions) throws {
        var query = configuaration.queryAttributes(options: options)
        query.account = key

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }

    func removeAll() throws {
        var query = configuaration.queryAttributes()
#if !os(iOS) && !os(watchOS) && !os(tvOS)
        query[Search.MatchLimit] = Search.MatchLimitAll
#endif

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }
}
