//
//  MTTempTraveler.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 03/07/23.
//

import Foundation

struct MTTempTraveler {
	let id: Int
	let name: String
	let familyName: String
	let residenceCountry: String
	let residenceCity: String
	let residencePostCode: String
	let tripId: Int
	var otherPeopleCount: Int = 0
}
extension MTTempTraveler: Identifiable { }
extension MTTempTraveler: Equatable { }
extension MTTempTraveler: Hashable { }
extension MTTempTraveler: Decodable {
	enum CodingKeys: String, CodingKey {
		case id, name
		case familyName = "family_name"
		case residenceCountry = "residence_country"
		case residenceCity = "residence_city"
		case residencePostCode = "residence_post_code"
		case tripId = "trip_id"
	}
}
