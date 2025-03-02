//
//  KeychainManager.swift
//  SpaceShipsApp
//
//  Created by Vlad Klunduk on 16/02/2025.
//

import Foundation
import Security

protocol KeychainFetchable {
    func fetchPassword(for email: String) -> String?
}

struct KeychainManager {
    func savePassword(_ password: String, for email: String) {
        guard let passwordData = password.data(using: .utf8) else { return }
        let attributes: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passwordData,
            kSecAttrAccount: email
        ]
        SecItemAdd(attributes as CFDictionary, nil)
    }
}

extension KeychainManager: KeychainFetchable {
    func fetchPassword(for email: String) -> String? {
        let attributes: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: email,
            kSecReturnData: true
        ]
        var result: AnyObject?
        SecItemCopyMatching(attributes as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
