//
//  MTResponse.swift
//  MyTravel
//
//  Created by Xuser on 10/05/23.
//

import Foundation

struct MTResponse<MTDecodable: Decodable> {
	let status: Bool
	let message: String?
	let role: String?
	let userID: Int?
	let data: MTDecodable?
}

extension MTResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case status, message, role, data
		case userID = "user_id"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let userId = try? container.decodeIfPresent(Int.self, forKey: .userID) {
			self.userID = userId
		} else if let strUserId = try? container.decodeIfPresent(String.self, forKey: .userID), !strUserId.isEmpty,
					let userId = Int(strUserId) {
			self.userID = userId
		} else {
			self.userID = nil
//			throw DecodingError.typeMismatch(
//				String.self, .init(codingPath: [CodingKeys.userID], debugDescription: "type neight in Number nor in String"))
		}
		status = try container.decode(Bool.self, forKey: .status)
		message = try container.decodeIfPresent(String.self, forKey: .message)
		role = try container.decodeIfPresent(String.self, forKey: .role)
		data = try container.decodeIfPresent(MTDecodable.self, forKey: .data)
	}
}

struct NullCodable: Codable { }
