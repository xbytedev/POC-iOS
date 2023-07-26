//
//  PlaceDetailProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/07/23.
//

import Foundation

protocol PlaceDetailProvider {
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error>
}
struct PlaceDetailAPIProvider: PlaceDetailProvider {
	struct PlaceDetailParam {
		let place: MTPlace
	}

	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error> {
		let requester = WebRequester<MTResponse<MTPlaceDetail>>(withSession: WebRequesterSessionProvider.session)
		let param = PlaceDetailParam(place: place)
		let result = await requester.request(toURL: APPURL.agentPlaceDetails, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				if let placeDetail = response.data {
					return .success(placeDetail)
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

extension PlaceDetailAPIProvider.PlaceDetailParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case placeId = "place_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(place.id, forKey: .placeId)
	}
}
