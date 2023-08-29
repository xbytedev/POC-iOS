//
//  MTCheckInTravellerDetail.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 29/08/23.
//

import Foundation

extension MTCheckInTravellerDetail {
	static let preview = MTCheckInTravellerDetail(
		id: 0, peopleId: 0, peopleCode: "0", peopleCity: "People City", partnerId: 0, peopleCountry: "People Country",
		peopleName: "People Name", placeName: "Place name", parnerName: "Partner name",
		date: Calendar.current.date(bySetting: .day, value: -2, of: Date()) ?? Date())
}
