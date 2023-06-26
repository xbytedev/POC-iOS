//
//  GroupDetailProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

protocol GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error>
	func changeStatus(ofTraveller traveller: MTTraveller) async -> Result<Void, Error>
	func delete(group: MTGroup) async -> Result<Void, Error>
	func delete(traveller: MTTraveller) async -> Result<Void, Error>
}

struct GroupDetailAPIProvider: GroupDetailProvider {
	struct PeopleListParam {
		let group: MTGroup
	}
	struct ChangeStatusParam {
		let traveller: MTTraveller
	}
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error> {
		let requester = WebRequester<MTResponse<[MTTraveller]>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.groupPeopleList, withParameters: PeopleListParam(group: group))
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
		case .failure(let error): return .failure(getOriginalErrorIfAny(error))
		}
	}
	func changeStatus(ofTraveller traveller: MTTraveller) async -> Result<Void, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = ChangeStatusParam(traveller: traveller)
		let result = await requester.request(toURL: APPURL.changeStatusTraveller, withParameters: param)
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
	func delete(group: MTGroup) async -> Result<Void, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.deleteGroup, withParameters: PeopleListParam(group: group))
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
	func delete(traveller: MTTraveller) async -> Result<Void, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let param = ChangeStatusParam(traveller: traveller)
		let result = await requester.request(toURL: APPURL.deleteTraveller, withParameters: param)
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
extension GroupDetailAPIProvider.PeopleListParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case groupId = "group_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(group.id, forKey: .groupId)
	}
}
extension GroupDetailAPIProvider.ChangeStatusParam: Encodable {
	enum CodingKeys: String, CodingKey {
		case travellerId = "group_people_id"
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(traveller.id, forKey: .travellerId)
	}
}
