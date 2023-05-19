//
//  GroupProvider.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

protocol GroupProvider {
	func doCreateGroup(groupName name: String) async -> Result<Bool, Error>
	//func getGroupList()  async -> Result<[MTGroup], Error>
}

struct GroupAPIProvider: GroupProvider {

	struct CreateGroupRequester {
		let name: String
		let partnerID: Int
	}

	func doCreateGroup(groupName name: String) async -> Result<Bool, Error> {
		let requester = WebRequester<MTResponse<NullCodable>>(withSession: WebRequesterSessionProvider.session)
		let result = await requester.request(toURL: APPURL.createGroup,
											 withParameters: CreateGroupRequester(name: name,
																				  partnerID: MTUserDefaults.currentUser?.id ?? 0))
		switch result {
		case .success(let response):
			if response.status == true {
				return .success(true)
			} else {
				return .failure(CustomError.message(response.message))
			}
		case .failure(let error):
			return .failure(getOriginalErrorIfAny(error))
		}
	}

//	func getGroupList() async -> Result<[MTGroup], Error> {
//
//	}
}

extension GroupAPIProvider.CreateGroupRequester: Encodable {
	enum CodingKeys: String, CodingKey {
		case partnerID = "partner_id"
		case name
	}
}
