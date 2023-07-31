//
//  PlaceDetailProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/07/23.
//

import Foundation

protocol PlaceDetailProvider {
	func getPlaceDetail(place: MTPlace) async -> Result<MTPlaceDetail, Error>
	func checkIn(group: MTGroup, to place: MTPlace) async -> Result<Void, Error>
	func checkIndividual(with code: Int) async -> Result<MTTempTraveler, Error>
	/// To check in individual traveller
	/// - Parameters:
	///   - code: Traveller code either entered manually or scanned via QR code
	///   - place: Place which traveler wants to check-in
	/// - Returns: Result either success or error
	func checkIn(code: Int, to place: MTPlace) async -> Result<Void, Error>
}
struct PlaceDetailAPIProvider: PlaceDetailProvider {

	struct PlaceDetailParam {
		let place: MTPlace
	}

	struct GroupCheckInParam {
		let place: MTPlace
		let group: MTGroup
	}

	struct CheckIndividualParam {
		let code: Int
	}

	struct IndividualCheckInParam {
		let place: MTPlace
		let code: Int
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

	func checkIn(group: MTGroup, to place: MTPlace) async -> Result<Void, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = GroupCheckInParam(place: place, group: group)
		let result = await requester.request(toURL: APPURL.groupCheckIn, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				return .success(())
			} else {
				return .failure(CustomError.getError(fromMessage: response.message))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func checkIndividual(with code: Int) async -> Result<MTTempTraveler, Error> {
		let requester = WebRequester<MTTempTravelerResponse>(withSession: WebRequesterSessionProvider.session)
		let param = CheckIndividualParam(code: code)
		let result = await requester.request(toURL: APPURL.checkPeopleCheckIn, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				if let tempTraveller = response.data {
					return .success(tempTraveller)
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

	func checkIn(code: Int, to place: MTPlace) async -> Result<Void, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = IndividualCheckInParam(place: place, code: code)
		let result = await requester.request(toURL: APPURL.individualCheckIn, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				return .success(())
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

extension PlaceDetailAPIProvider.GroupCheckInParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case placeId = "place_id"
		case groupId = "group_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(place.id, forKey: .placeId)
		try container.encode(group.id, forKey: .groupId)
	}
}

extension PlaceDetailAPIProvider.CheckIndividualParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case peopleCode = "people_code"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(code, forKey: .peopleCode)
	}
}

extension PlaceDetailAPIProvider.IndividualCheckInParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case code = "people_code"
		case place = "place_id"
	}
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(code, forKey: .code)
		try container.encode(place.id, forKey: .place)
	}
}
