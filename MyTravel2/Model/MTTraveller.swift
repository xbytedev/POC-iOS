//
//  MTTraveller.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

struct MTTraveller {
	let id: Int
	let groupId: Int
	let groupCode: String
	let partnerId: Int
	let peopleCode: String
	var status: Bool
	var name: String
}

extension MTTraveller: Identifiable { }
extension MTTraveller: Equatable { }
extension MTTraveller: Hashable { }
extension MTTraveller: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case groupId = "group_id"
		case groupCode = "group_code"
		case partnerId = "partner_id"
		case peopleCode = "people_code"
		case status
		case name = "people_name"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		groupId = try container.decode(Int.self, forKey: .groupId)
		groupCode = try container.decode(String.self, forKey: .groupCode)
		partnerId = try container.decode(Int.self, forKey: .partnerId)
		peopleCode = try container.decode(String.self, forKey: .peopleCode)
		status = try container.decode(Int.self, forKey: .status) == 1
		name = try container.decode(String.self, forKey: .name)
	}
}
