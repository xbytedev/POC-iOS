//
//  LocationProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import Foundation

protocol LocationProvider {
	func getPlaceList() async -> Result<[MTPlace], Error>
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error>
}

struct LocationAPIProvider: LocationProvider {
	struct PlaceDetailParam {
		let place: MTPlace
	}
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

extension LocationAPIProvider.PlaceDetailParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case placeId = "place_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(place.id, forKey: .placeId)
	}
}
