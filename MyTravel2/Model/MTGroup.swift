//
//  MTGroup.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

struct MTGroup: Decodable {
	let id: Int
	let groupdCode: Int
	var name: String?
	let partnerID, status: Int?
	let createdAt, updatedAt: String?
	let travellerCount: Int
	var isDefault: Int
	var navigateView: Bool = false

	enum CodingKeys: String, CodingKey {
		case id, name, status
		case groupdCode = "group_code"
		case partnerID = "partner_id"
		case travellerCount = "group_people_count"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case isDefault = "default_status"
	}
}

extension MTGroup {
	static let dummy = MTGroup(
		id: 20, groupdCode: 124657, name: "Create by iOS", partnerID: 1, status: 1,
		createdAt: "2023-05-22T12:53:58.000000Z", updatedAt: "2023-05-22T12:53:58.000000Z", travellerCount: 2, isDefault: 1)
}

extension MTGroup: Identifiable { }
extension MTGroup: Equatable { }
extension MTGroup: Hashable { }
