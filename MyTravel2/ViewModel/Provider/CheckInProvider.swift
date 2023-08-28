//
//  CheckInProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 23/08/23.
//

import Foundation

protocol CheckInProvider {
	func getCheckInTravellerList() async -> Result<[MTCheckInTraveller], Error>
	func getCheckInPeopleDetails() async -> Result<Void, Error>
}

struct CheckInAPIProvider: CheckInProvider {
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
				return .failure(CustomError.successButNoData)
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func getCheckInPeopleDetails() async -> Result<Void, Error> {
		return .success(())
	}
}
