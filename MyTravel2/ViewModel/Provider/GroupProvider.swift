//
//  GroupProvider.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

protocol GroupProvider {
	func doCreateGroup(user: WebUser?, groupName name: String) async -> Result<Bool, Error>
	func getGroupList(user: WebUser?) async -> Result<[MTGroup], Error>
}

struct GroupAPIProvider: GroupProvider {

	struct CreateGroupRequester {
		let name: String
		let partnerID: Int
	}

	struct GroupListRequester {
		let partnerID: Int
	}

	func doCreateGroup(user: WebUser?, groupName name: String) async -> Result<Bool, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.createGroup,
											 withParameters: CreateGroupRequester(name: name,
																				  partnerID: user?.id ?? 0))
		switch result {
		case .success(let response):
			if response.status == true {
				return .success(true)
			} else {
				return .failure(CustomError.message(response.message ?? ""))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

	func getGroupList(user: WebUser?) async -> Result<[MTGroup], Error> {
		let requester = WebRequester<MTResponse<[MTGroup]>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.groupList,
											 withParameters: GroupListRequester(partnerID: user?.id ?? 0))
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
		case partnerID = "partner_id"
		case name
	}
}

extension GroupAPIProvider.GroupListRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case partnerID = "partner_id"
	}
}
