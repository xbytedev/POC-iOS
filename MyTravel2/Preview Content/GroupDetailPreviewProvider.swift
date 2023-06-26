//
//  GroupDetailPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

struct GroupDetailSuccessProvider: GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error> {
		.success([.preview])
	}

	func changeStatus(ofTraveller traveller: MTTraveller) async -> Result<Void, Error> {
		.success(())
	}

	func delete(group: MTGroup) async -> Result<Void, Error> {
		.success(())
	}

	func delete(traveller: MTTraveller) async -> Result<Void, Error> {
		.success(())
	}

	func makeDefault(group: MTGroup) async -> Result<Void, Error> {
		.success(())
	}
}

struct GroupDetailFailureProvider: GroupDetailProvider {
	func getGroupPeopleList(from group: MTGroup) async -> Result<[MTTraveller], Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func changeStatus(ofTraveller traveller: MTTraveller) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func delete(group: MTGroup) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func delete(traveller: MTTraveller) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}

	func makeDefault(group: MTGroup) async -> Result<Void, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
