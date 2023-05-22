//
//  MTGroup.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

struct MTGroup: Decodable {
	let id: Int
	let name: String?
	let partnerID, status: Int?
	let createdAt, updatedAt: String?

	enum CodingKeys: String, CodingKey {
		case id, name
		case partnerID = "partner_id"
		case status
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}
}

extension MTGroup: Identifiable { }
