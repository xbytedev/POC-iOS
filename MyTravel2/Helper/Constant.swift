//
//  Constant.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.com.pedro.POC-Scanner"

struct UIConfiguration {
	var isLoading = false
	var errorTitle = ""
	var errorMeessage = ""
	var alertPresent = false
}

func MTJSONEncoder() -> JSONEncoder {
	let encoder = JSONEncoder()
	return encoder
}

func MTJSONDecoder() -> JSONDecoder {
	let decoder = JSONDecoder()
	return decoder
}

enum MTLoadingState: ReflectiveEquatable {
	case idle
	case loading
	case failed(Error)
	case loaded
}

// Conform this protocol to Equatable
protocol ReflectiveEquatable: Equatable {}

extension ReflectiveEquatable {

	var reflectedValue: String { String(reflecting: self) }

	// Explicitly implement the required `==` function
	// (The compiler will synthesize `!=` for us implicitly)
	static func ==(lhs: Self, rhs: Self) -> Bool { // swiftlint:disable:this operator_whitespace
		return lhs.reflectedValue == rhs.reflectedValue
	}
}
