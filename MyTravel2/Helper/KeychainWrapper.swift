//
//  KeychainWrapper.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

struct KeychainWrapper {
	// Test has been written for this class, If you change anything please run test to make sure didn't break anything
	// Command + U to run unit test
	static let standard = KeychainWrapper()

	private init() {
	}

	@discardableResult
	func set(_ value: String, forKey key: String) -> Bool {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key,
									kSecValueData as String: value.data(using: .utf8)!]

		let status = SecItemAdd(query as CFDictionary, nil)
		if status == errSecSuccess {
			return true
		} else if status == errSecDuplicateItem {
			return update(value, forKey: key)
		} else {
			return false
		}
	}

	@discardableResult
	func update(_ value: String, forKey key: String) -> Bool {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key]
		let attributes: [String: Any] = [kSecValueData as String: value.data(using: .utf8)!]
		let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
		return status == errSecSuccess
	}

	@discardableResult
	func remove(forKey key: String) -> Bool {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecAttrAccount as String: key]
		let status = SecItemDelete(query as CFDictionary)
		return status == errSecSuccess
	}

	func string(forKey key: String) -> String? {
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
									kSecMatchLimit as String: kSecMatchLimitOne,
									kSecAttrAccount as String: key,
									kSecReturnData as String: true]
		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		if status == noErr {
			if let data = item as? Data {
				return String(data: data, encoding: .utf8)
			}
		}
		return nil
	}
}
