//
//  MTCheckInTravellerPreview.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 28/08/23.
//

import Foundation

extension MTCheckInTraveller {
	static let preview: MTCheckInTraveller = .init(
		id: 1, peopleId: 2, peopleCode: "peopleCode", peopleName: "People Name", placeName: "Place name",
		partnerName: "Partner name", date: Calendar.current.date(bySetting: .day, value: -2, of: Date()) ?? Date())
}
