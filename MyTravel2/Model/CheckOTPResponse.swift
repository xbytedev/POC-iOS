//
//  CheckOTPResponse.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

struct CheckOTPResponse {
	let status: Bool
	let message: String?
	let userId: String?
	let data: WebUser?
	let token: String?
}

extension CheckOTPResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case status, message, data, token
		case userId = "user_id"
	}
}
