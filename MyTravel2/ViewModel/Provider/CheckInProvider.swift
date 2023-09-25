//
//  CheckInProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 23/08/23.
//

import Foundation

protocol CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error>
	func getCheckInPeopleDetails(
		from checkInTraveller: MTCheckInTraveller) async -> Result<MTCheckInTravellerDetail, Error>
}

struct CheckInAPIProvider: CheckInProvider {

	struct CheckInPeopleDetailsParam {
		let traveller: MTCheckInTraveller
	}

	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error> {
		let requester = WebRequester<MTResponse<[MTCheckInTraveller]>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.checkInPeopleList, withParameters: NullCodable())
		switch result {
		case .success(let response):
			if response.status {
				if let travellers = response.data {
					return .success(travellers)
				} else {
					return .failure(CustomError.successButNoData)
				}
			} else {
				return .failure(CustomError.getError(fromMessage: response.message))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func getCheckInPeopleDetails(
		from checkInTraveller: MTCheckInTraveller) async -> Result<MTCheckInTravellerDetail, Error> {
			let requester = WebRequester<MTResponse<MTCheckInTravellerDetail>>(withSession: WebRequesterSessionProvider.session)
			let param = CheckInPeopleDetailsParam(traveller: checkInTraveller)
			let result = await requester.request(toURL: APPURL.checkInPeopleDetails, withParameters: param)
			switch result {
			case .success(let response):
				if response.status {
					if let travellerDetail = response.data {
						return .success(travellerDetail)
					} else {
						return .failure(CustomError.successButNoData)
					}
				} else {
					return .failure(CustomError.getError(fromMessage: response.message))
				}
			case .failure(let error):
				return .failure(getOriginalErrorIfAny(error))
			}
		}
}

extension CheckInAPIProvider.CheckInPeopleDetailsParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case id = "place_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(traveller.id, forKey: .id)
	}
}
