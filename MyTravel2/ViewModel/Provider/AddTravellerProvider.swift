//
//  AddTravellerProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

enum TravelerCodeType: String {
	case single
	case all
}
protocol AddTravellerProvider {
	func checkTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error>
	func addTraveler(to group: MTGroup, with code: Int, type: TravelerCodeType) async -> Result<Bool, Error>
}

struct AddTravellerAPIProvider: AddTravellerProvider {
	struct AddTravellerParam {
		let travellerCode: Int
		let group: MTGroup
		let user: WebUser
		let type: TravelerCodeType?
	}

	func addTraveler(to group: MTGroup, with code: Int, type: TravelerCodeType) async -> Result<Bool, Error> {
		guard let currentUser = MTUserDefaults.currentUser else {
			return .failure(CustomError.message(R.string.localizable.internalUserDataNotFound()))
		}
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = AddTravellerParam(travellerCode: code, group: group, user: currentUser, type: type)
		let result = await requester.request(toURL: APPURL.addTravellerToGroup, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				return .success(true)
			} else {
				return .failure(CustomError.getError(fromMessage: response.message))
			}
		case .failure(let error): return .failure(getOriginalErrorIfAny(error))
		}
	}

	func checkTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error> {
		guard let currentUser = MTUserDefaults.currentUser else {
			return .failure(CustomError.message(R.string.localizable.internalUserDataNotFound()))
		}
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = AddTravellerParam(travellerCode: code, group: group, user: currentUser, type: nil)
		let result = await requester.request(toURL: APPURL.checkTraveler, withParameters: param)
		switch result {
		case .success(let response):
			if response.status {
				return .success(true)
			} else {
				return .failure(CustomError.getError(fromMessage: response.message))
			}
		case .failure(let error): return .failure(getOriginalErrorIfAny(error))
		}
	}
}
extension AddTravellerAPIProvider.AddTravellerParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case peopleCode = "people_code"
		case groupId = "group_id"
		case groupCode = "group_code"
		case agentId = "agent_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(travellerCode, forKey: .peopleCode)
		try container.encode(group.id, forKey: .groupId)
		try container.encode(group.groupdCode, forKey: .groupCode)
		try container.encode(user.id, forKey: .agentId)
	}
}
extension TravelerCodeType: Encodable { }
