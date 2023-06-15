//
//  MTTraveller.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

struct MTTraveller {
	let groupId: Int
	let groupCode: String
	let peopleId: Int
	let peopleCode: String
	let status: Int
	let agentId: Int
}

extension MTTraveller: Identifiable {
	var id: String {
		peopleCode
	}
}
extension MTTraveller: Equatable { }
extension MTTraveller: Hashable { }
extension MTTraveller: Decodable {
	enum CodingKeys: String, CodingKey {
		case groupId = "group_id"
		case groupCode = "group_code"
		case peopleId = "people_id"
		case peopleCode = "people_code"
		case status
		case agentId = "agent_id"
	}
}
