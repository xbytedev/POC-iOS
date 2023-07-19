//
//  MTPlace.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import Foundation

struct MTPlace {
	let id: Int
	let name: String?
	let category: String?
	let attractionType: String?
	let region: String?
	let rayon: String?
	let city: String?
}
extension MTPlace: Identifiable { }
extension MTPlace: Hashable { }
extension MTPlace: Equatable { }
extension MTPlace: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case name = "Name"
		case category = "Category"
		case attractionType = "Attraction_Type"
		case region = "Region"
		case rayon = "Rayon"
		case city = "City"
	}
}
