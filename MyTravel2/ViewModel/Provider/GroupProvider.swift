//
//  GroupProvider.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

protocol GroupProvider {
	func doCreateGroup(user: WebUser, groupName name: String) async -> Result<MTGroup, Error>
	func getGroupList(user: WebUser) async -> Result<[MTGroup], Error>
}

struct GroupAPIProvider: GroupProvider {

	struct CreateGroupRequester {
		let name: String
		let agentId: Int
	}

	struct GroupListRequester {
		let agentId: Int
	}

	func doCreateGroup(user: WebUser, groupName name: String) async -> Result<MTGroup, Error> {
		let requester = WebRequester<MTResponse<MTGroup>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.createGroup,
											 withParameters: CreateGroupRequester(name: name,
																				  agentId: user.id))
		switch result {
		case .success(let response):
			if response.status == true {
				if let data = response.data {
					return .success(data)
				} else {
					return .failure(CustomError.message(R.string.localizable.requestSucceedNoData()))
				}
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func getGroupList(user: WebUser) async -> Result<[MTGroup], Error> {
		let requester = WebRequester<MTResponse<[MTGroup]>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.groupList,
											 withParameters: GroupListRequester(agentId: user.id))
		switch result {
		case .success(let response):
			if response.status == true {
				if let data = response.data {
					return .success(data)
				} else {
					return .failure(CustomError.message(R.string.localizable.requestSucceedNoData()))
				}
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(CustomError.message(error.localizedDescription))
		}
	}
}

extension GroupAPIProvider.CreateGroupRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case agentId = "agent_id"
		case name
	}
}

extension GroupAPIProvider.GroupListRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case agentId = "agent_id"
	}
}
