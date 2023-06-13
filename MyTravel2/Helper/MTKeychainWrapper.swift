//
//  MTKeychainWrapper.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

enum MTKeychainWrapper {
	static var authToken: String? {
		get {
			return KeychainWrapper.standard.string(forKey: Key.Keychain.authToken)
		}
		set {
			if let newValue = newValue {
				KeychainWrapper.standard.set(newValue, forKey: Key.Keychain.authToken)
			} else {
				KeychainWrapper.standard.remove(forKey: Key.Keychain.authToken)
			}
		}
	}
}
