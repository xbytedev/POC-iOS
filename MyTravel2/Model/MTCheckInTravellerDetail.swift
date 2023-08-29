//
//  MTCheckInTravellerDetail.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 29/08/23.
//

import Foundation

struct MTCheckInTravellerDetail {
	let id: Int
	let peopleId: Int
	let peopleCode: String
	let peopleCity: String
	let partnerId: Int
	let peopleCountry: String
	let peopleName: String
	let placeName: String?
	let parnerName: String
	let date: Date
}
extension MTCheckInTravellerDetail: Identifiable { }
extension MTCheckInTravellerDetail: Equatable { }
extension MTCheckInTravellerDetail: Hashable { }
extension MTCheckInTravellerDetail: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case peopleId = "people_id"
		case peopleCode = "people_code"
		case peopleCity = "people_city"
		case partnerId = "partner_id"
		case peopleCountry = "people_country"
		case peopleName = "people_name"
		case placeName = "place_name"
		case parnerName = "partner_name"
		case date
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		peopleId = try container.decode(Int.self, forKey: .peopleId)
		peopleCode = try container.decode(String.self, forKey: .peopleCode)
		peopleCity = try container.decode(String.self, forKey: .peopleCity)
		partnerId = try container.decode(Int.self, forKey: .partnerId)
		peopleCountry = try container.decode(String.self, forKey: .peopleCountry)
		peopleName = try container.decode(String.self, forKey: .peopleName)
		placeName = try container.decodeIfPresent(String.self, forKey: .placeName)
		parnerName = try container.decode(String.self, forKey: .parnerName)
		let dateStr = try container.decode(String.self, forKey: .date)
		guard let decodedDate = MTFormatter.Date.serverDateFormatter.date(from: dateStr) else {
			throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string format mismatch")
		}
		date = decodedDate
	}
}
