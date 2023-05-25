//
//  MTUserDefaults.swift
//  MyTravel
//
//  Created by Xuser on 16/05/23.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
	let key: String
	let defaultValue: T

	init(_ key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}

	var wrappedValue: T {
		get {
			return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
		}
		set {
			UserDefaults.standard.set(newValue, forKey: key)
		}
	}
}

struct MTUserDefaults {
	static func removeAllData() {
		if let appDomain = Bundle.main.bundleIdentifier {
			UserDefaults.standard.removePersistentDomain(forName: appDomain)
		}
	}

	static var currentUser: WebUser? {
		get {
			if let data = UserDefaults.standard.data(forKey: Key.UserDefaults.currentUser) {
				return try? data.decoded()
			}
			return nil
		}
		set {
			if newValue == nil {
				UserDefaults.standard.removeObject(forKey: Key.UserDefaults.currentUser)
			}
			if let data = try? newValue.encoded() {
				UserDefaults.standard.set(data, forKey: Key.UserDefaults.currentUser)
			}
		}
	}

	@UserDefault(Key.UserDefaults.lastOTPSendDate, defaultValue: nil)
	static var lastOTPSendDate: Date?
}
