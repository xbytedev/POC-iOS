//
//  MTPlaceDetail.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 22/07/23.
//

import Foundation

struct MTPlaceDetail {
	let id: Int
	let name: String
	let category: String
	let attractionType: String
	let image: String
	let region: String
	let rayon: String
	let city: String
	let address: String
	let website: String
	let telephone: String
	let email: String
	let latitude: String
	let longitude: String
}
extension MTPlaceDetail: Identifiable { }
extension MTPlaceDetail: Equatable { }
extension MTPlaceDetail: Hashable { }
extension MTPlaceDetail: Decodable {
	enum CodingKeys: String, CodingKey {
		case id, image
		case name = "Name"
		case category = "Category"
		case attractionType = "Attraction_Type"
		case region = "Region"
		case rayon = "Rayon"
		case city = "City"
		case address = "Address"
		case website = "Website"
		case telephone = "Telephone"
		case email = "Email"
		case latitude = "Latitude"
		case longitude = "Longitude"
	}
}
