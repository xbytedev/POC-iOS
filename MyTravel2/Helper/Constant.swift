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

enum MTLoadingState {
	case idle
	case loading
	case failed(Error)
	case loaded
}
