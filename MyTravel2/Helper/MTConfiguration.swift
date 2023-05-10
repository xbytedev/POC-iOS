//
//  MTConfiguration.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

enum MTConfiguration {
	enum Error: Swift.Error {
		case missingKey, invalidValue
	}

	static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
		guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
			throw Error.missingKey
		}

		switch object {
		case let value as T:
			return value
		case let string as String:
			guard let value = T(string) else { fallthrough }
			return value
		default:
			throw Error.invalidValue
		}
	}
}
