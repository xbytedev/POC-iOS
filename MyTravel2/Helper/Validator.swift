//
//  Validator.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

class Validator {
	static let shared = Validator()

	func isValidEmail(_ email: String) -> Bool {
		// https://stackoverflow.com/a/25471164/3110026
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
}
