//
//  MTCheckInTravller.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 25/08/23.
//

import Foundation

struct MTCheckInTraveller {
	let id: Int
	let peopleId: Int
	let peopleCode: String
	let peopleName: String
	let placeName: String?
	let partnerName: String
	let date: Date
}

extension MTCheckInTraveller: Identifiable { }
extension MTCheckInTraveller: Equatable { }
extension MTCheckInTraveller: Hashable { }
extension MTCheckInTraveller: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case peopleId = "people_id"
		case peopleCode = "people_code"
		case peopleName = "people_name"
		case placeName = "place_name"
		case partnerName = "partner_name"
		case date
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		peopleId = try container.decode(Int.self, forKey: .peopleId)
		peopleCode = try container.decode(String.self, forKey: .peopleCode)
		peopleName = try container.decode(String.self, forKey: .peopleName)
		placeName = try container.decodeIfPresent(String.self, forKey: .placeName)
		partnerName = try container.decode(String.self, forKey: .partnerName)
		let dateStr = try container.decode(String.self, forKey: .date)
		guard let parsedDate = MTFormatter.Date.serverDateFormatter.date(from: dateStr) else {
			throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string format mismatch")
		}
		date = parsedDate
	}
}
