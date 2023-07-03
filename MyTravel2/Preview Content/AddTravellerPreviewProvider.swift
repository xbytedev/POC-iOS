//
//  AddTravellerPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

struct AddTravellerSuccessProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int, type: TravelerCodeType) async -> Result<Bool, Error> {
		.success(true)
	}
	func checkTraveler(to group: MTGroup, with code: Int) async -> Result<MTTempTraveler, Error> {
		.success(.preview)
	}
}

struct AddTravellerFailureProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int, type: TravelerCodeType) async -> Result<Bool, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
	func checkTraveler(to group: MTGroup, with code: Int) async -> Result<MTTempTraveler, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
