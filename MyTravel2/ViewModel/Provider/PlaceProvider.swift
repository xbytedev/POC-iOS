//
//  PlaceProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import Foundation

protocol PlaceProvider {
	func getPlaceList() async -> Result<[MTPlace], Error>
}

struct PlaceAPIProvider: PlaceProvider {
	func getPlaceList() async -> Result<[MTPlace], Error> {
		let requester = WebRequester<MTResponse<[MTPlace]>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.agentPlaceList, withParameters: NullCodable())
		switch result {
		case .success(let response):
			if response.status {
				if let places = response.data {
					return .success(places)
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
