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
	var isDefault: Int
	var navigateView: Bool = false

	enum CodingKeys: String, CodingKey {
		case id, name
		case groupdCode = "group_code"
		case partnerID = "partner_id"
		case status
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case isDefault = "default_status"
	}
}

extension MTGroup: Identifiable { }
extension MTGroup: Equatable { }
extension MTGroup: Hashable { }
