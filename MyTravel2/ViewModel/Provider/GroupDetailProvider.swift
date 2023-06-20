//
//  GroupDetailProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

protocol GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error>
}

struct GroupDetailAPIProvider: GroupDetailProvider {
	struct PeopleListParam {
		let group: MTGroup
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
