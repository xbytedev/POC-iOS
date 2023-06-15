//
//  GroupDetailPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

struct GroupDetailSuccessProvider: GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error> {
		return .success([.preview])
	}
}

struct GroupDetailFailureProvider: GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error> {
		return .failure(CustomError.message("Mock Failure"))
	}
}
