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

func SMJSONDecoder() -> JSONDecoder {
	let decoder = JSONDecoder()
	return decoder
}
