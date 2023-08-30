//
//  Extension.swift
//  MyTravel
//
//  Created by Xuser on 16/05/23.
//

import Foundation

extension String {
	func isValid(allowChars: [String], minLength: Int?, maxLength: Int?) -> Bool {
		let regEx = createRegExString(allowChars: allowChars, minLength: minLength, maxLength: maxLength)
		let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
		return predicate.evaluate(with: self)
	}

	private func createRegExString(allowChars: [String], minLength: Int?, maxLength: Int?) -> String {
		var regEx = "[" + allowChars.joined() + "]"
		if minLength != nil || maxLength != nil {
			regEx += "{"
			if minLength != nil {
				regEx += "\(minLength!)"
			} else {
				regEx += "0"
			}
			regEx += ","
			if maxLength != nil {
				regEx += "\(maxLength!)"
			}
			regEx += "}"
		}
		return regEx
	}
}

extension Encodable {
	func encoded(fromEncoder encoder: JSONEncoder = MTJSONEncoder()) throws -> Data {
		return try encoder.encode(self)
	}
}

extension Data {
	func decoded<T: Decodable>(fromDecoder decoder: JSONDecoder = MTJSONDecoder()) throws -> T {
		return try decoder.decode(T.self, from: self)
	}
}

extension Calendar {
	func endOfDay(for date: Date) -> Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return self.date(byAdding: components, to: date)!
	}
}
