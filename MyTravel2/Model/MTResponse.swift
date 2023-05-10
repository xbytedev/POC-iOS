//
//  MTResponse.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

struct MTResponse<MTDecodable: Decodable>: Decodable {
	let status: Bool
	let message, role: String
	let userID: MTDecodable

	enum CodingKeys: String, CodingKey {
		case status, message, role
		case userID = "user_id"
	}
}

struct NullCodable: Codable { }
